import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/user.dart';
import 'package:bumdeskm/pages/cart/cart_page.dart';
import 'package:bumdeskm/pages/login_page.dart';
import 'package:bumdeskm/pages/orders/my_order_page.dart';
import 'package:bumdeskm/pages/profile/change_password.dart';
import 'package:bumdeskm/pages/profile/confirm_password_page.dart';
import 'package:bumdeskm/pages/profile/edit_profile.dart';
import 'package:bumdeskm/pages/welcome_page.dart';
import 'package:bumdeskm/pages/wishlist/wishlist_page.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  List<User> user = [];
  String img = "";
  String name = "";
  String username = "";
  String email = "";
  String phone = "";
  int carts = 0;
  int wishlists = 7;
  int orders = 0;

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
      phone = body['phone'];
      carts = body['carts'];
      orders = body['orders'];
      _isLoading = false;
    });
  }

  Widget ProfileAppBar() {
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
            Icons.arrow_back,
            size: 30,
          ),
          color: primaryColor,
        ),
        BigText(text: "Profil Saya"),
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
            ? ListView(children: [
                ProfileAppBar(),
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
              ])
            : ListView(
                children: [
                  ProfileAppBar(),
                  Container(
                    color: white,
                    padding: EdgeInsets.only(
                        left: 20, right: 16, top: 12, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                radius: 34,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      ApiService().imgURL + "$img"),
                                  radius: 32,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BigText(
                                    text: '$name',
                                    color: black,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  BigText(
                                    text: '$phone',
                                    color: black,
                                    size: 13,
                                    weight: FontWeight.w400,
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  BigText(
                                    text: '$email',
                                    color: black,
                                    size: 13,
                                    weight: FontWeight.w400,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfilePage(),
                                  ));
                            },
                            icon: Image.asset(
                              "assets/images/cib_edit.png",
                              color: primaryColor,
                            ),
                            iconSize: 30),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    color: white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => MyOrderPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(
                                text: orders.toString(),
                                size: 32,
                                weight: FontWeight.w500,
                                color: primaryColor,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              BigText(
                                text: "Pesanan",
                                size: 14,
                                color: black,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => CartPage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(
                                text: "$carts",
                                size: 32,
                                weight: FontWeight.w500,
                                color: primaryColor,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              BigText(
                                text: "Keranjang",
                                size: 14,
                                color: black,
                                weight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       new MaterialPageRoute(
                        //           builder: (context) => WishlistPage()),
                        //     );
                        //   },
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       BigText(
                        //         text: "$wishlists",
                        //         size: 32,
                        //         weight: FontWeight.w500,
                        //         color: primaryColor,
                        //       ),
                        //       SizedBox(
                        //         height: 4,
                        //       ),
                        //       BigText(
                        //         text: "Wishlist",
                        //         size: 14,
                        //         color: black,
                        //         weight: FontWeight.w500,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConfirmPasswordPage()));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.vpn_key_outlined,
                                  size: 22,
                                  color: primaryColor,
                                ),
                                SizedBox(width: 16),
                                BigText(
                                  text: 'Ubah Password',
                                  size: 15,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.navigate_next_rounded,
                              size: 30,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  InkWell(
                      onTap: () {
                        confirmLogout(context);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        color: white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              children: [
                                Icon(
                                  Icons.logout,
                                  size: 24,
                                  color: primaryColor,
                                ),
                                SizedBox(width: 16),
                                BigText(
                                  text: 'Logout',
                                  size: 15,
                                  weight: FontWeight.w500,
                                ),
                              ],
                            ),
                            Icon(
                              Icons.navigate_next_rounded,
                              size: 30,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
      )),
    );
  }

  confirmLogout(BuildContext context) {
    Widget cancel = FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: SmallText(
          text: "Batal",
        ));
    Widget confirm = FlatButton(
        onPressed: () {
          Navigator.pop(context);
          logout();
        },
        child: SmallText(
          text: "Logout",
          color: Colors.red,
        ));
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi Logout"),
      content: Text("Apakah Anda yakin ingin keluar ?"),
      actions: [
        cancel,
        confirm,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void logout() async {
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
    setState(() {
      _isLoading = true;
    });
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    localStorage.remove('id_user');
    localStorage.remove('subtotal');
    localStorage.remove('weight');
    localStorage.clear();
    setState(() {
      _isLoading = false;
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => WelcomePage()),
          (Route<dynamic> route) => false);
    });
    // var res = await ApiService().logout('/logout');
    // var body = jsonDecode(res.body);
    // if (body['success']) {
    //   SharedPreferences localStorage = await SharedPreferences.getInstance();
    //   localStorage.remove('user');
    //   localStorage.remove('token');
    //   localStorage.remove('id_user');
    //   localStorage.remove('subtotal');
    //   localStorage.remove('weight');
    //   localStorage.clear();
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // Navigator.pushReplacement(
    //   //     context, MaterialPageRoute(builder: (context) => WelcomePage()));
    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (context) => WelcomePage()),
    //       (Route<dynamic> route) => false);
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Fluttertoast.showToast(msg: "Terjadi kesalahan...");
    // }
  }
}
