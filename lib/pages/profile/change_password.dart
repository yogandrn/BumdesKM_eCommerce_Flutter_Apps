import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  var password, confpass;
  bool isLoading = false;
  bool _isObscure1 = true;
  bool _isObscure2 = true;
  final _formKey = GlobalKey<FormState>();

  showMsgError(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Color(0xFF0f8a30),
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
                  ),
                )
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
                            BigText(text: "Ubah Password"),
                            Icon(
                              Icons.close,
                              size: 30,
                              color: Colors.transparent,
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // form password
                            TextFormField(
                              obscureText: _isObscure1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong!';
                                } else if (value.length < 8) {
                                  return 'Minimal 8 karakter!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                password = value!;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: primaryColor)),
                                hintText: "Password",
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
                                        width: 1, color: Color(0xFF818181))),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            // form confirm password
                            TextFormField(
                              obscureText: _isObscure2,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukkan kembali password yang dibuat!';
                                } else if (value.length < 8) {
                                  return 'Minimal 8 karakter!';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                confpass = value!;
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: primaryColor)),
                                hintText: "Konfirmasi Password",
                                hintStyle: txtForm,
                                suffixIcon: IconButton(
                                    color: primaryColor,
                                    icon: Icon(_isObscure2
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        _isObscure2 = !_isObscure2;
                                      });
                                    }),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF818181))),
                              ),
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 56,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(16),
                                // gradient: LinearGradient(
                                //     begin: Alignment.topLeft,
                                //     end: Alignment.bottomRight,
                                //     colors: [primaryColor, secondaryColor]),
                              ),
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      shadowColor: Color(0xFFd9d9d9),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      )),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      if (password == confpass) {
                                        // _register();
                                        // showOngkirError();
                                        changePassword();
                                      } else {
                                        showMsgError(
                                            "Konfirmasi Password tidak sesuai!");
                                      }
                                    }
                                  },
                                  child: BigText(
                                    text: "Simpan",
                                    color: white,
                                    size: 16,
                                    weight: FontWeight.w600,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Container(
                    //   color: white,
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //   child: Form(
                    //     key: _formkey,
                    //     child: Column(
                    //       children: [
                    //         TextFormField(
                    //           obscureText: _isObscure1,
                    //           validator: (value) {
                    //             if (value!.isEmpty) {
                    //               return 'Password tidak boleh kosong!';
                    //             } else if (value.length < 8) {
                    //               return 'Minimal 8 karakter!';
                    //             }
                    //             // password = value;
                    //             return null;
                    //           },
                    //           onSaved: (value) {
                    //             password = value!;
                    //           },
                    //           keyboardType: TextInputType.text,
                    //           decoration: InputDecoration(
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 borderSide: BorderSide(
                    //                     width: 1, color: primaryColor)),
                    //             hintText: "Password Baru",
                    //             hintStyle: txtForm,
                    //             suffixIcon: IconButton(
                    //                 color: primaryColor,
                    //                 icon: Icon(_isObscure1
                    //                     ? Icons.visibility
                    //                     : Icons.visibility_off),
                    //                 onPressed: () {
                    //                   setState(() {
                    //                     _isObscure1 = !_isObscure1;
                    //                   });
                    //                 }),
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 borderSide: BorderSide(
                    //                     width: 1, color: primaryColor)),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 15,
                    //         ),
                    //         TextFormField(
                    //           obscureText: _isObscure2,
                    //           validator: (value) {
                    //             if (value!.isEmpty) {
                    //               return 'Konfirmasi Password tidak boleh kosong!';
                    //             } else if (value.length < 8) {
                    //               return 'Minimal 8 karakter!';
                    //             }
                    //             // confpass = value;
                    //             return null;
                    //           },
                    //           onSaved: (value) {
                    //             password = value!;
                    //           },
                    //           keyboardType: TextInputType.text,
                    //           decoration: InputDecoration(
                    //             focusedBorder: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 borderSide: BorderSide(
                    //                     width: 1, color: primaryColor)),
                    //             hintText: "Konfirmasi Password Baru",
                    //             hintStyle: txtForm,
                    //             suffixIcon: IconButton(
                    //                 color: primaryColor,
                    //                 icon: Icon(_isObscure2
                    //                     ? Icons.visibility
                    //                     : Icons.visibility_off),
                    //                 onPressed: () {
                    //                   setState(() {
                    //                     _isObscure2 = !_isObscure2;
                    //                   });
                    //                 }),
                    //             border: OutlineInputBorder(
                    //                 borderRadius: BorderRadius.circular(12),
                    //                 borderSide: BorderSide(
                    //                     width: 1, color: primaryColor)),
                    //           ),
                    //         ),
                    //         SizedBox(
                    //           height: 18,
                    //         ),
                    //         Container(
                    //           height: 56,
                    //           color: white,
                    //           child: ElevatedButton(
                    //             onPressed: () {
                    //               if (_formkey.currentState!.validate()) {
                    //                 _formkey.currentState!.save();
                    //                 // if (!confpass == password) {
                    //                 //   showMsg("Konfirmasi Password tidak sesuai!");
                    //                 // } else {
                    //                 //   showMsg("$confpass | $password");
                    //                 // }
                    //                 // showMsg("$confpass | $password");
                    //                 if (password == confpass) {
                    //                   changePassword();
                    //                 } else {
                    //                   showMsg("error");
                    //                 }
                    //               }
                    //             },
                    //             child: BigText(
                    //               text: 'Simpan',
                    //               color: white,
                    //               size: 16,
                    //             ),
                    //             style: ElevatedButton.styleFrom(
                    //               minimumSize: Size(400, 56),
                    //               primary: primaryColor,
                    //               shape: RoundedRectangleBorder(
                    //                   borderRadius: BorderRadius.circular(12)),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    // Container(
                    //   height: 400,
                    //   color: white,
                    //   padding:
                    //       EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    //   child: Column(
                    //     children: [
                    //       ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //             minimumSize: Size(400, 50),
                    //             primary: primaryColor,
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(15),
                    //             ),
                    //           ),
                    //           onPressed: () {
                    //             if (_formkey.currentState!.validate()) {
                    //               _formkey.currentState!.save();
                    //               if (confpass != password) {
                    //                 showMsg(
                    //                     "Konfirmasi Password tidak sesuai!");
                    //               } else {}
                    //             }
                    //           },
                    //           child: Text(
                    //             'Simpan',
                    //           ))
                    //     ],
                    //   ),
                    // ),
                  ],
                )),
    );
  }

  void changePassword() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getInt('id_user');
    var data = {'id_user': id, 'new_password': password};
    var res = await ApiService().changePassword(data);
    var body = jsonDecode(res.body);
    if (body['message'] == 'SUCCESS') {
      setState(() {
        isLoading = false;
      });
      showMsg("Berhasil memperbarui password");
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        isLoading = false;
      });
      showMsgError("Terjadi kesalahan saat memperbarui password!");
    }
  }

  void showOngkirError() {
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
                      'assets/images/shipment_not_found.png',
                      width: 56,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      text: "Belum menghitung Ongkos Kirim",
                      size: 15,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop(false);
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
}
