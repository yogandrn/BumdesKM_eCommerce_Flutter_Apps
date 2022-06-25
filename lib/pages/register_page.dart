import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/home/home_page.dart';
import 'package:bumdeskm/pages/login_page.dart';
import 'package:bumdeskm/pages/main_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email, password, confpass, name, username, phone;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 36),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: gray,
                  color: primaryColor,
                  strokeWidth: 6,
                ),
              )
            : ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 32,
                        ),
                        BigText(
                          text: "Register",
                          size: 26,
                          weight: FontWeight.w700,
                          color: grey40,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        BigText(
                          text: "Create your account here",
                          size: 15,
                          weight: FontWeight.w500,
                          color: grey40,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        // form nama
                        TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nama tidak boleh kosong!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
                            hintText: "Nama Lengkap",
                            hintStyle: txtForm,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF818181))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // form username
                        TextFormField(
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username tidak boleh kosong!';
                            } else if (value.length < 4) {
                              return 'Minimum username adalah 4 karakter!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            username = value!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
                            hintText: "Username",
                            hintStyle: txtForm,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF818181))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // form email
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Alamat Email tidak boleh kosong!';
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return 'Alamat Email tidak valid!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            email = value!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
                            hintText: "Email",
                            hintStyle: txtForm,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF818181))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        // form telepon
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Nomor Telepon tidak boleh kosong!';
                            } else if (value.length < 11 || value.length > 15) {
                              return 'Nomor Telepon tidak valid';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phone = value!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
                            hintText: "Nomor Telepon",
                            hintStyle: txtForm,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    width: 1, color: Color(0xFF818181))),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
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
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
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
                            }
                            return null;
                          },
                          onSaved: (value) {
                            confpass = value!;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide:
                                    BorderSide(width: 1, color: primaryColor)),
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
                              color: primaryLight,
                              borderRadius: BorderRadius.circular(16),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [primaryColor, secondaryColor])),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  shadowColor: Color(0xFFd9d9d9),
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();

                                  if (password == confpass) {
                                    _register();
                                  } else {
                                    _showMsg(
                                        "Konfirmasi Password tidak sesuai!");
                                  }
                                }
                              },
                              child: Text(
                                  _isLoading ? "Loading..." : "Register",
                                  style: buttonText18)),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Already have account?',
                                style: textRegister,
                              ),
                              // Text(" Register", style: textButtonRegister,),
                              TextButton(
                                  style: TextButton.styleFrom(
                                    shadowColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      // DetailPage adalah halaman yang dituju
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  child:
                                      Text("Login", style: textButtonRegister)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _register() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 138,
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
    var data = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'username': username,
      'gender': 'Not set',
      'roles': 'USER',
      'image': "assets/user_profile/default_user.png",
    };

    var res = await ApiService().auth(data, '/register');
    var body = json.decode(res.body);
    var id = body['id'];
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      localStorage.setString('user', json.encode(body['user']));
      localStorage.setString('id_user', json.encode(body['user']['id']));
      localStorage.setInt('id_user', id);
      Fluttertoast.showToast(msg: "Registrasi berhasil...");
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      if (body['message']['username'] != null) {
        Navigator.pop(context);
        _showErrorDialog("Username telah digunakan! Coba yang lainnya");
      } else if (body['message']['email'] != null) {
        Navigator.pop(context);
        _showErrorDialog("Email telah terdaftar! Coba yang lainnya");
      } else if (body['message']['phone'] != null) {
        Navigator.pop(context);
        _showErrorDialog("Nomor Telepon telah terdaftar! Coba yang lainnya");
      }
    }
  }

  _showErrorDialog(var msg) {
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
                    SizedBox(
                      height: 4,
                    ),
                    Image.asset(
                      'assets/images/error.png',
                      width: 56,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SmallText(
                      align: TextAlign.center,
                      text: "$msg",
                      size: 15,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop(true);
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
