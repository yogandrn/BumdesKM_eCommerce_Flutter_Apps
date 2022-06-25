import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/pages/profile/profile_page.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class EditPhotoPage extends StatefulWidget {
  int id;
  String img;
  EditPhotoPage({Key? key, required this.id, required this.img})
      : super(key: key);

  @override
  State<EditPhotoPage> createState() => _EditPhotoPageState();
}

class _EditPhotoPageState extends State<EditPhotoPage> {
  int id_user = 0;
  String img = "";

  PickedFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id_user = widget.id;
      img = widget.img;
    });
  }

  void _pickImage() async {
    try {
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _imageFile = pickedFile;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Gagal memilih gambar\n" + e.toString());
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Container(
        height: MediaQuery.of(context).size.height / 2.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width / 1.8,
                height: MediaQuery.of(context).size.width / 1.8,
                margin: EdgeInsets.only(left: 18, right: 18, top: 24),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 2.4,
                    left: MediaQuery.of(context).size.width / 3.0),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 2.5, color: primaryColor),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width / 3),
                  image: DecorationImage(
                      image: FileImage(File(_imageFile!.path)),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 16,
                      backgroundColor: primaryColor,
                      child: InkWell(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: white,
                          size: MediaQuery.of(context).size.width / 15,
                        ),
                        onTap: _pickImage,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 2.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: MediaQuery.of(context).size.width / 1.8,
                height: MediaQuery.of(context).size.width / 1.8,
                margin: EdgeInsets.only(left: 18, right: 18, top: 24),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.width / 2.4,
                    left: MediaQuery.of(context).size.width / 3.0),
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(width: 2.5, color: primaryColor),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width / 3),
                  image: DecorationImage(
                      image: NetworkImage(img), fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: MediaQuery.of(context).size.width / 16,
                      backgroundColor: primaryColor,
                      child: InkWell(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          color: white,
                          size: MediaQuery.of(context).size.width / 15,
                        ),
                        onTap: _pickImage,
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
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
                      BigText(text: "Perbarui Foto Profil"),
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
      ),
      bottomNavigationBar: _imageFile == null
          ? Container(
              height: 0,
              width: 0,
            )
          : Container(
              padding: EdgeInsets.only(left: 25, bottom: 20, right: 25),
              child: ElevatedButton(
                onPressed: () {
                  uploadImage(_imageFile!.path);
                },
                child: BigText(
                  text: 'Simpan',
                  color: white,
                  size: 15,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 56),
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
    );
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

      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text(response.exception.code)));
    }
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
        'POST', Uri.parse(ApiService().baseURL + '/user/edit/photo'));
    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    request.fields.addAll({
      "id_user": widget.id.toString(),
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
      // _showError();
      Fluttertoast.showToast(msg: "Gagal memperbarui foto profil!");
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
                      text: "Gagal memperbarui foto Profil",
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
                          //       builder: (context) => ProfilePage(),
                          //     )).then((value) => ApiService().getUserData());
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
                      height: 12,
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
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop(true);
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           DetailOrderPage(id: widget.id_trasanction),
                          //     ));
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              )).then((value) => ApiService().getUserData());
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
}
