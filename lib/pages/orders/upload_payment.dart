import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/home/home_page.dart';
import 'package:bumdeskm/pages/main_page.dart';
import 'package:bumdeskm/pages/orders/detail_order_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class UploadPayment extends StatefulWidget {
  var id_trasanction;
  UploadPayment({Key? key, required this.id_trasanction}) : super(key: key);

  @override
  State<UploadPayment> createState() => _UploadPaymentState();
}

class _UploadPaymentState extends State<UploadPayment> {
  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      print("Image picker error " + e.toString());
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.height / 1.8,
              margin: EdgeInsets.only(left: 18, right: 18, top: 24),
              decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: FileImage(File(_imageFile!.path)),
                      fit: BoxFit.cover)),
              // child: Image.file(
              //   File(_imageFile!.path),
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: ElevatedButton(
                onPressed: () {
                  uploadImage(_imageFile!.path);
                },
                child: BigText(
                  text: 'Unggah',
                  color: white,
                  size: 15,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(400, 56),
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            // RaisedButton(
            //   onPressed: () async {
            //     uploadImage(_imageFile!.path);
            //     // var res = await uploadImage(_imageFile!.path,
            //     //     'http://192.168.1.6/coba_api/public/api/payment/upload');
            //     // print(res);
            //   },
            //   child: const Text('Upload'),
            // )
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 1.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 48,
              height: MediaQuery.of(context).size.height / 1.8,
              margin: EdgeInsets.only(left: 18, right: 18, top: 24),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Unggah bukti pembayaran disini',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    }
  }

  Future<void> retriveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      // print('Retrieve error ' + response.exception.code);
      _showMsgError('Terjadi kesalahan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 60,
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 6),
              margin: EdgeInsets.only(bottom: 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        size: 30,
                      ),
                      color: Colors.indigo,
                    ),
                    BigText(text: "Unggah Bukti Pembayaran"),
                    Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.transparent,
                    ),
                  ]),
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                child: FutureBuilder<void>(
                  future: retriveLostData(),
                  builder:
                      (BuildContext context, AsyncSnapshot<void> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return const Text('Picked an image');
                      case ConnectionState.done:
                        return _previewImage();
                      default:
                        return const Text('Picked an image');
                    }
                  },
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image from gallery',
        child: Icon(Icons.photo_library),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void uploadImage(filepath) async {
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
                      backgroundColor: Colors.white70,
                      color: Colors.indigo,
                      strokeWidth: 6,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(text: "Loading...", size: 13.6),
                  ]),
            ),
          );
        });
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiService().baseURL + '/payment/upload'));
    request.files.add(await http.MultipartFile.fromPath('payment', filepath));
    request.fields.addAll({
      "id_transaction": widget.id_trasanction.toString(),
      "status": "WAITING"
    });
    var res = await request.send();
    // var response = res.reasonPhrase;
    var code = res.statusCode;
    if (code == 200) {
      Navigator.of(context).pop(false);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("OK DONG!")));
      _showSuccess();
    } else {
      Navigator.of(context).pop(false);
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text("YAAH GAGAL!")));
      _showError();
    }
  }

  _showError() {
    // Widget okBtn = FlatButton(onPressed: (onPressed), child: child)
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 170,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/error.png',
                      width: 56,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      align: TextAlign.center,
                      text:
                          "Terjadi kesalahan saat\nmengunggah bukti pembayaran",
                      size: 15,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailOrderPage(id: widget.id_trasanction),
                              ));
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: primaryColor,
                          ),
                          child: Center(
                              child:
                                  BigText(text: "OK", color: white, size: 14)),
                        )),
                  ]),
            ),
          );
        });
  }

  _showSuccess() {
    // Widget okBtn = FlatButton(onPressed: (onPressed), child: child)
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 170,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/check.png',
                      width: 56,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      align: TextAlign.center,
                      text: "Berhasil menggunggah gambar",
                      size: 15,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           DetailOrderPage(id: widget.id_trasanction),
                          //     ));
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (Route<dynamic> route) => false);
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: primaryColor,
                          ),
                          child: Center(
                              child:
                                  BigText(text: "OK", color: white, size: 14)),
                        )),
                  ]),
            ),
          );
        });
  }

  _showMsgError(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Color(0xFF0f8a30),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
