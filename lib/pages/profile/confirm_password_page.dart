import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/profile/change_password.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfirmPasswordPage extends StatefulWidget {
  const ConfirmPasswordPage({Key? key}) : super(key: key);

  @override
  State<ConfirmPasswordPage> createState() => _ConfirmPasswordPageState();
}

class _ConfirmPasswordPageState extends State<ConfirmPasswordPage> {
  var password;
  bool _isObscure1 = true;
  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                  backgroundColor: gray,
                  color: primaryColor,
                  strokeWidth: 6,
                ))
              : ListView(
                  children: [
                    Container(
                      width: double.maxFinite,
                      height: 60,
                      color: white,
                      padding: EdgeInsets.symmetric(horizontal: 6),
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
                              color: primaryColor,
                            ),
                            BigText(text: "Konfirmasi Password"),
                            Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.transparent,
                            ),
                          ]),
                    ),
                    Container(
                      color: white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 7,
                          ),
                          Form(
                              key: _formkey,
                              child: TextFormField(
                                obscureText: _isObscure1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Password tidak boleh kosong!';
                                  } else if (value.length < 8) {
                                    return 'Minimal 8 karakter!';
                                  }
                                  password = value;
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryColor)),
                                  hintText: "Masukkan Password",
                                  hintStyle: txtForm,
                                  suffixIcon: IconButton(
                                      color: primaryColor,
                                      icon: Icon(_isObscure1
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure1 = !_isObscure1;
                                        });
                                      }),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                          width: 1, color: primaryColor)),
                                ),
                              )),
                          Container(
                            height: double.maxFinite,
                            color: white,
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 40),
                                        primary: primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    onPressed: () {
                                      if (_formkey.currentState!.validate()) {
                                        _formkey.currentState!.save();
                                        checkPassword();
                                      }
                                    },
                                    child: Text('Selanjutnya'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }

  void checkPassword() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id_user');
    var data = {"id_user": id, "password": password};
    var res = await ApiService().cekPassword(data);
    var body = jsonDecode(res.body);
    if (body['message'] == "OK") {
      setState(() {
        isLoading = false;
      });
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => ChangePasswordPage()));
    } else if (body['message'] == "FAILED") {
      setState(() {
        isLoading = false;
      });
      showMsg("Password salah!");
    } else {
      setState(() {
        isLoading = false;
      });
      showMsg("Terjadi kesalahan!");
    }
  }
}
