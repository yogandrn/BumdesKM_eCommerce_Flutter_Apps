// import 'dart:ffi';

import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/cart.dart';
import 'package:bumdeskm/pages/cart/cart_item.dart';
import 'package:bumdeskm/pages/orders/order_page.dart';
import 'package:bumdeskm/pages/product/catalog_page.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int id_user = 0;
  bool _isLoading = true;
  List<Cart> carts = [];
  var subtotal = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    fetchData();
    setState(() {});
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   setState(() {
  //     carts = [];
  //   });
  //   fetchData();
  // }

  // ambil id_user
  void getID() async {
    ApiService().getUserData();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      // id_user = preferences.getInt('id_user');
      id_user = preferences.getInt('id_user') ?? 0;
      subtotal = preferences.getInt('subtotal') ?? 0;
    });
    // print(id_user);
  }

  // Future getData() async {
  //   var res =
  //       await http.get("http://192.168.1.2/coba_api/public/carts/$id_user");
  //   var jsonData = jsonDecode(res.body);
  //   List<Cart> carts = [];

  //   for (var json in jsonData) {
  //     Cart cart = Cart(
  //         id: json['id'],
  //         idUser: json['id_user'],
  //         idProduct: json['id_product'],
  //         title: json['title'],
  //         image: json['image'],
  //         price: json['price'],
  //         qty: json['qty'],
  //         subtotal: json['subtotal']);
  //     carts.add(cart);
  //   }
  //   return carts;
  // }

  //ambil data keranjang
  fetchData() async {
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(child: CircularProgressIndicator());
    //     },);
    final response = await ApiService().getUserCarts();
    await ApiService().getUserData();
    setState(() {
      carts.addAll(response);
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ApiService().getAllProducts();
            setState(() {
              _isLoading = true;
              carts = [];
            });
            // await ApiService().getUserCarts();
            // getData();
            await fetchData();
          },
          color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.maxFinite,
                height: 60,
                color: white,
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                ),
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
                      BigText(text: "Keranjang"),
                      Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.transparent,
                      ),
                    ]),
              ),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                      // horizontal: 12,
                      vertical: 10,
                    ),
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              backgroundColor: gray,
                              color: primaryColor,
                              strokeWidth: 6,
                            ),
                          )
                        : carts.length > 0
                            ? ListView(
                                scrollDirection: Axis.vertical,
                                children: carts
                                    .map<Widget>((data) => CartItem(
                                          cart: data,
                                          id: data.id,
                                          product_id: data.idProduct,
                                          price: data.price,
                                          images: data.image,
                                          title: data.title,
                                          subtotal: data.subtotal,
                                          qty: data.qty,
                                        ))
                                    .toList(),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/empty_cart.png",
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    SmallText(
                                      text:
                                          "Tidak ada apapun\ndi dalam Keranjang",
                                      color: grey40,
                                      align: TextAlign.center,
                                      size: 14,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                                // ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //         padding: EdgeInsets.symmetric(
                                //             horizontal: 16, vertical: 12),
                                //         primary: primaryLight,
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(12),
                                //         )),
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   CatalogPage()));
                                //     },
                                //     child: BigText(
                                //       text: "Mulai Belanja",
                                //       color: white,
                                //     ))
                              )),
              ),
              // Positioned(
              //     bottom: 0,
              //     left: 0,
              //     right: 0,
              //     child: Container(
              //       color: gray,
              //       height: 60,
              //       width: double.maxFinite,
              //     ))
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isLoading
          ? Container(
              height: 0,
              width: 0,
            )
          : carts.length == 0
              ? Container(
                  margin:
                      EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 12),
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
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CatalogPage(
                                  // id_user: id_user,
                                  )));
                    },
                    child: BigText(
                      text: "Belanja Sekarang",
                      color: white,
                      size: 16,
                    ),
                  ),
                )
              :

              // Container(
              //     margin: EdgeInsets.only(left: 16, bottom: 12, right: 16),
              //     width: MediaQuery.of(context).size.width,
              //     height: 56,
              //     decoration: BoxDecoration(
              //         color: primaryLight,
              //         borderRadius: BorderRadius.circular(16),
              //         gradient: LinearGradient(
              //             begin: Alignment.topLeft,
              //             end: Alignment.bottomRight,
              //             colors: [primaryColor, secondaryColor])),
              //     child: TextButton(
              //       style: TextButton.styleFrom(
              //           shadowColor: Color(0xFFd9d9d9),
              //           backgroundColor: Colors.transparent,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(16),
              //           )),
              //       onPressed: () {
              //         if (subtotal == 0) {
              //           initState();
              //           Fluttertoast.showToast(msg: "Terjadi kesalahan!");
              //         } else {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                   builder: (context) => OrderPage(
              //                       // id_user: id_user,
              //                       )));
              //         }
              //       },
              //       child: BigText(
              //         text: "Order",
              //         color: white,
              //         size: 16,
              //       ),
              //     ),
              //   )

              Container(
                  padding:
                      EdgeInsets.only(left: 24, top: 10, bottom: 10, right: 16),
                  color: white,
                  height: 72,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SmallText(
                              text: "Subtotal :",
                              size: 14,
                              weight: FontWeight.w500,
                            ),
                            SmallText(
                              text: CurrencyFormat.convertToIdr(subtotal),
                              size: 16,
                              weight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
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
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderPage(
                                            // id_user: id_user,
                                            )));
                              },
                              child: BigText(
                                text: "Check Out",
                                color: white,
                                size: 16,
                              ),
                            ),
                          ))
                    ],
                  )),

      // body: SafeArea(
      //     child: Stack(
      //   children: [
      //     Positioned(
      //       top: 0,
      //       left: 0,
      //       right: 0,
      //       child: Container(
      //         width: double.maxFinite,
      //         height: 60,
      //         color: white,
      //         padding: EdgeInsets.symmetric(horizontal: 6),
      //         child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               IconButton(
      //                 onPressed: () {
      //                   Navigator.pop(context);
      //                 },
      //                 icon: Icon(
      //                   Icons.arrow_back_rounded,
      //                   size: 30,
      //                 ),
      //                 color: primaryColor,
      //               ),
      //               BigText(text: "Keranjang"),
      //               Icon(
      //                 Icons.close,
      //                 size: 30,
      //                 color: Colors.transparent,
      //               ),
      //             ]),
      //       ),
      //     ),
      //     Positioned(
      //       top: 60, left: 0, right: 0, bottom: 0,
      //       // height: double.maxFinite,
      //       child: ListView.builder(
      //           scrollDirection: Axis.vertical,
      //           // children:
      //           // carts.map<Widget>((cart) => CartItem(cart: cart)).toList(),
      //           itemCount: 5,
      //           itemBuilder: (context, index) {
      //             // return CartItem(cart: data,);
      //             // return cartItem(index);
      //             return listCart();
      //           }),
      //     )
      //   ],
      // )),
    );
  }
}
