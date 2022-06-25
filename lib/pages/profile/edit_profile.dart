import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/profile/edit_photo.dart';
import 'package:bumdeskm/pages/profile/profile_page.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/small_text.dart';

enum Gender { Pria, Wanita }

class EditProfilePage extends StatefulWidget {
  EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  Gender? _gender = Gender.Pria;
  bool _isLoading = true;
  String img = "";
  String name = "";
  String gender = "";
  String username = "";
  String email = "";
  String phone = "";
  String jenis_kelamin = "";
  int id_user = 0;

  @override
  void initState() {
    super.initState();
    fetchDataUser();
  }

  fetchDataUser() async {
    final response = await ApiService().getUserData();
    var body = json.decode(response.body);

    setState(() {
      img = body['image'];
      name = body['name'];
      username = body['username'];
      email = body['email'];
      gender = body['gender'];
      phone = body['phone'];
      id_user = body['id'];
      gender == "Pria"
          ? _gender = Gender.Pria
          : gender == "Wanita"
              ? _gender = Gender.Wanita
              : _gender == Gender.Pria;
      _isLoading = false;
    });
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget EditProfileAppBar() {
    return Container(
      width: double.maxFinite,
      height: 60,
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
        BigText(text: "Edit Profil"),
        Icon(
          Icons.close,
          size: 30,
          color: Colors.transparent,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _isLoading = true;
          });
          fetchDataUser();
        },
        color: primaryColor,
        child: _isLoading
            ? ListView(
                children: [
                  EditProfileAppBar(),
                  Container(
                    height: MediaQuery.of(context).size.height - 60,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: gray,
                        color: primaryColor,
                        strokeWidth: 6,
                      ),
                    ),
                  )
                ],
              )
            : ListView(
                children: [
                  EditProfileAppBar(),
                  Container(
                    padding: EdgeInsets.only(top: 30, bottom: 20),
                    color: white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                              radius: 60,
                              child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(ApiService().imgURL + "$img"),
                                radius: 58,
                                child: Row(
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 70)),
                                    Column(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(top: 70)),
                                        CircleAvatar(
                                          backgroundColor: primaryColor,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.edit_rounded,
                                              color: white,
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditPhotoPage(
                                                              id: id_user,
                                                              img: ApiService()
                                                                      .imgURL +
                                                                  "$img")));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(height: 30),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: white,
                          child: Column(
                            children: [
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SmallText(
                                        text: "Nama Lengkap",
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.name,
                                        initialValue: '$name',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Nama tidak boleh kosong!";
                                          } else if (value.length < 4) {
                                            return "Mohon masukkan nama lengkap!";
                                          }
                                          email = value;
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor)),
                                          // hintText: "$name",
                                          hintStyle: txtForm,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      SmallText(
                                        text: "Jenis Kelamin",
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Radio<Gender>(
                                                  value: Gender.Pria,
                                                  groupValue: _gender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _gender = value;
                                                    });
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text('Pria'),
                                                )
                                              ],
                                            ),
                                            flex: 1,
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Radio<Gender>(
                                                  value: Gender.Wanita,
                                                  groupValue: _gender,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _gender = value;
                                                    });
                                                  },
                                                ),
                                                Expanded(child: Text('Wanita'))
                                              ],
                                            ),
                                            flex: 1,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      // form email
                                      SmallText(
                                        text: "Email",
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      TextFormField(
                                        initialValue: '$email',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Email tidak boleh kosong!";
                                          } else if (!value.contains('@') ||
                                              !value.contains(".")) {
                                            return "Email tidak valid!";
                                          }
                                          email = value;
                                          return null;
                                        },
                                        // onSaved: (value) {
                                        //   email = value!;
                                        // },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor)),
                                          // hintText: "$email",
                                          hintStyle: txtForm,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF818181))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      SmallText(
                                        text: "Nomor Telepon",
                                        size: 14,
                                        weight: FontWeight.w500,
                                        color: primaryColor,
                                      ),
                                      SizedBox(
                                        height: 6,
                                      ),
                                      TextFormField(
                                        initialValue: '$phone',
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Nomor Telepon tidak boleh kosong!";
                                          } else if (value.length < 9 ||
                                              value.length > 15) {
                                            return "Nomor Telepon tidak valid!";
                                          }
                                          phone = value;
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor)),
                                          // hintText: "$phone",
                                          hintStyle: txtForm,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: primaryColor)),
                                        ),
                                      ),

                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
      )),
      bottomNavigationBar: _isLoading
          ? Container(
              height: 0,
              width: 0,
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    switch (_gender) {
                      case Gender.Pria:
                        setState(() {
                          jenis_kelamin = "Pria";
                        });
                        break;
                      case Gender.Wanita:
                        setState(() {
                          jenis_kelamin = "Wanita";
                        });
                        break;
                      default:
                        setState(() {
                          jenis_kelamin = "Not Set";
                        });
                        break;
                    }

                    editData();
                  }
                },
                child: BigText(
                  text: 'Simpan',
                  color: white,
                  size: 16,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(400, 56),
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
    );
  }

  void editData() async {
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

    var data = {
      "id": id_user,
      "name": name,
      "email": email,
      "gender": jenis_kelamin,
      "phone": phone,
    };
    var req = await ApiService().updateProfile(data);
    var response = json.decode(req.body);
    if (response['message'] == "SUCCESS") {
      Navigator.of(context).pop(true);
      Navigator.of(context).pop(true);
      Fluttertoast.showToast(msg: "Berhasil memperbarui data");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(),
          )).then((value) => ApiService().getUserData());
    } else if (response['message'] == "The email has already been taken.") {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email sudah terdaftar! Cobalah menggunakan email lain"),
        backgroundColor: Colors.red,
      ));
    } else if (response['message'] == "The phone has already been taken.") {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Nomor Telepon sudah terdaftar! Cobalah menggunakan nomor lain"),
        backgroundColor: Colors.red,
      ));
    } else {
      Navigator.of(context).pop(true);
      Fluttertoast.showToast(msg: "Terjadi kesalahan\n" + response['message']);
    }
  }
}
