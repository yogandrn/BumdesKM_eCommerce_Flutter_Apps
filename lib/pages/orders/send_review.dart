import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/home/home_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendReviewPage extends StatefulWidget {
  var order_id;
  SendReviewPage({Key? key, required this.order_id}) : super(key: key);

  @override
  State<SendReviewPage> createState() => _SendReviewPageState();
}

class _SendReviewPageState extends State<SendReviewPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  static int id_transaction = 0;
  var id_user, comment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setId();
  }

  void setId() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_transaction = widget.order_id;
      id_user = prefs.getInt('id_user');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: gray,
                    color: primaryColor,
                    strokeWidth: 6,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        height: 60,
                        color: white,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(text: "Ulasan"),
                            ]),
                      ),
                      Container(
                        color: white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductText(
                                  text:
                                      "Beritahu kami bagaimana pengalaman Anda membeli produk kami"),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Silakan mengisi ulasan untuk melanjutkan";
                                  } else if (value.length < 15) {
                                    return "Ulasan harus mengandung setidaknya 15 karakter";
                                  } else if (value.length > 300) {
                                    return "Ulasan tidak boleh melibihi 300 karakter!";
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  comment = value;
                                },
                                maxLines: 10,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryColor)),
                                  hintText: "Masukkan ulasan...",
                                  hintStyle: txtForm,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryColor)),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: ProductText(
                                  text:
                                      "Ulasan minimal 15 karakter, dan maksimal 300 karakter",
                                  color: primaryColor,
                                  size: 12.5,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
      bottomNavigationBar: Container(
        height: 64,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.8,
              child: Center(
                child: InkWell(
                  child: BigText(
                    text: "Lewati",
                    size: 14.5,
                    color: primaryColor,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.0,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Fluttertoast.showToast(msg: comment);
                    sendReview();
                  }
                  // Navigator.of(context).pop(true);
                },
                child: BigText(
                  text: 'Kirim Ulasan',
                  size: 15,
                  color: white,
                  weight: FontWeight.w500,
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(340, 56),
                    primary: primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendReview() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 135,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      backgroundColor: gray,
                      color: primaryColor,
                      strokeWidth: 6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      text: "Loading...",
                      size: 14,
                    )
                  ]),
            ),
          );
        });
    var data = {
      "id_transaction": id_transaction,
      "id_user": id_user,
      "comment": comment,
    };
    var res = await ApiService().createReview(data);
    var body = jsonDecode(res.body);
    if (body['message'] == "SUCCESS") {
      Navigator.of(context).pop(true);
      // Fluttertoast.showToast(msg: "Berhasil mengkonfirmasi pesanan");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
    } else {
      Fluttertoast.showToast(msg: body['message']);
    }
  }
}
