import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/cart.dart';
import 'package:bumdeskm/pages/orders/order_list_item.dart';
import 'package:bumdeskm/pages/orders/payment_page.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Delivery { reguler, express }

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _isLoading = true;
  bool _isShipment = false;
  List<Cart> carts = [];
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  var user_id,
      subtotal,
      total,
      recipient,
      address,
      phone,
      codepost,
      estimasi = "...";
  var shipping = 0;
  var weight = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoading = true;
    });
    getProduct();
    getData();
    setState(() {
      _isLoading = false;
    });
  }

  void getProduct() async {
    var res = await ApiService().getUserCarts();
    carts.addAll(res);
    setState(() {});
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
      user_id = prefs.getInt('id_user');
      subtotal = prefs.getInt('subtotal');
      weight = prefs.getInt('weight') ?? 0;
      total = subtotal + shipping;
      _isLoading = false;
    });
  }

  _showMsg(msg) {
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
      backgroundColor: Color.fromARGB(255, 36, 126, 39),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
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
                          BigText(text: "Order"),
                          Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.transparent,
                          ),
                        ]),
                  ),
                  Container(
                    color: white,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // form penerima
                          SmallText(
                            text: 'Nama Penerima',
                            color: primaryColor,
                            size: 14.5,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            // height: 70,
                            child: TextFormField(
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Penerima tidak boleh kosong!";
                                } else if (value.length < 4) {
                                  return "Masukkan nama yang lebih spesifik!";
                                }
                                recipient = value;
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: primaryColor)),
                                hintText: "Budi Susanto",
                                hintStyle: txtForm,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF818181))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),

                          // form alamat
                          SmallText(
                            text: 'Alamat Tujuan',
                            color: primaryColor,
                            size: 14.5,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            // height: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.streetAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Alamat Tujuan tidak boleh kosong!";
                                } else if (value.length < 8) {
                                  return "Minimal 8 karakter ";
                                }
                                address = value;
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: primaryColor)),
                                hintText: "Jln. Medan Merdeka Barat No.12",
                                hintStyle: txtForm,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF818181))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),

                          // form nomor telepon
                          SmallText(
                            text: 'Nomor Telepon',
                            color: primaryColor,
                            size: 14.5,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 5),
                          SizedBox(
                            // height: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Nomor Telepon tidak boleh kosong!";
                                } else if (value.length < 11 ||
                                    value.length > 15) {
                                  return "Nomor Telepon tidak valid!";
                                }
                                phone = value;
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: primaryColor)),
                                hintText: "081234567890",
                                hintStyle: txtForm,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0xFF818181))),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),

                          // form kode pos
                          SmallText(
                            text: 'Kode Pos',
                            color: primaryColor,
                            size: 14.5,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.8,
                                child: TextFormField(
                                  key: _formKey2,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Kode Pos tidak boleh kosong!";
                                    } else if (value.length < 5) {
                                      _showMsg("Kode Pos tidak valid!");
                                    }
                                    codepost = value;
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 5),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1, color: primaryColor)),
                                    hintText: "60236",
                                    hintStyle: txtForm,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color(0xFF818181))),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 3.0,
                                height: 52,
                                decoration: BoxDecoration(
                                    color: primaryLight,
                                    borderRadius: BorderRadius.circular(16),
                                    gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          primaryColor,
                                          secondaryColor
                                        ])),
                                child: TextButton(
                                    style: TextButton.styleFrom(
                                        shadowColor: Color(0xFFd9d9d9),
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        )),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        // _showMsg(recipient);
                                        cekOngkir();
                                      }

                                      // if (codepost != null) {
                                      //   cekOngkir();
                                      // }
                                    },
                                    child: BigText(
                                      text: "Cek Ongkir",
                                      size: 16,
                                      color: white,
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          SmallText(
                            text:
                                "Kode Pos diperlukan untuk menghitung ongkos kirim",
                            size: 12.0,
                            color: Color(0xFF505050),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    color: white,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SmallText(
                            text: 'Pengiriman',
                            color: primaryColor,
                            size: 14.5,
                            weight: FontWeight.w500,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallText(
                                text: 'Biaya Pengiriman',
                              ),
                              SmallText(
                                text: CurrencyFormat.convertToIdr(shipping),
                                weight: FontWeight.w500,
                                color: primaryColor,
                                size: 13.5,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallText(
                                text: 'Estimasi',
                              ),
                              SmallText(
                                text: estimasi + " hari",
                                weight: FontWeight.w500,
                                color: black,
                                size: 13.5,
                              ),
                            ],
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  // list pesanan
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      color: white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12),
                            SmallText(
                              text: 'Pesanan Saya',
                              color: primaryColor,
                              size: 14.5,
                              weight: FontWeight.w500,
                            ),
                            SizedBox(height: 10),
                            ListView(
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: carts
                                    .map((e) => OrderProductItem(
                                        title: e.title,
                                        price: e.price,
                                        qty: e.qty,
                                        subtotal: e.subtotal,
                                        image: e.image))
                                    .toList()),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SmallText(
                                  text: 'Total Pesanan',
                                ),
                                SmallText(
                                  text: CurrencyFormat.convertToIdr(subtotal),
                                  weight: FontWeight.w500,
                                  color: primaryColor,
                                  size: 13.5,
                                ),
                                // SmallText(
                                //   text: '$weight',
                                //   weight: FontWeight.w500,
                                //   color: primaryColor,
                                //   size: 13.5,
                                // ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ])),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    color: white,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmallText(
                              text: 'Total Pesanan',
                            ),
                            SmallText(
                              text: CurrencyFormat.convertToIdr(subtotal),
                              weight: FontWeight.w500,
                              color: black,
                              size: 13.5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmallText(
                              text: 'Ongkos Kirim',
                            ),
                            SmallText(
                              text: CurrencyFormat.convertToIdr(shipping),
                              weight: FontWeight.w500,
                              color: black,
                              size: 13.5,
                            ),
                          ],
                        ),
                        Divider(
                          height: 16,
                          color: grey81,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SmallText(
                              text: 'Total Pembayaran',
                            ),
                            SmallText(
                              text: CurrencyFormat.convertToIdr(total),
                              weight: FontWeight.w500,
                              color: primaryColor,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                ],
              )),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 72,
        padding: EdgeInsets.only(left: 20, right: 18, top: 10, bottom: 10),
        decoration: BoxDecoration(
          color: white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 173, 173, 173),
                offset: Offset(0, 3),
                blurRadius: 8),
            BoxShadow(
                color: Color.fromARGB(255, 199, 199, 199),
                offset: Offset(0, 4),
                blurRadius: 6),
          ],
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SmallText(
                      text: 'Total :',
                      color: grey40,
                      weight: FontWeight.w500,
                      size: 13.8,
                    ),
                    BigText(
                      text: CurrencyFormat.convertToIdr(total),
                      color: primaryColor,
                      size: 15,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2.2,
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
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // _showMsg(recipient);
                        // cekOngkir();
                        if (shipping == 0) {
                          // showMsg(
                          //     "Hitung Ongkos Kirim terlebih dahulu sebelum melakukan pemesanan!");
                          showOngkirError();
                        } else {
                          order();
                        }
                      }
                    },
                    child: BigText(
                      text: "Buat Pesanan",
                      size: 16,
                      color: white,
                    )),
              ),
            ]),
      ),
    );
  }

  void cekOngkir() async {
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
    var data = {"destination": codepost, "weight": '1000'};
    var res = await ApiService().cekOngkir(data);
    var body = jsonDecode(res.body);
    var cost = body['cost'];
    var est = body['estimasi'];
    setState(() {
      shipping = cost;
      estimasi = est;
      total = shipping + subtotal;
      // _isLoading = false;
    });
    Navigator.of(context).pop(false);

    // setState(() {
    //   _isLoading = true;
    // // });
    // var data = {"destination": codepost, "weight": '1000'};
    // var res = await ApiService().cekOngkir(data);
    // var body = jsonDecode(res.body);
    // var cost = body['cost'];
    // var est = body['estimasi'];
    // setState(() {
    //   shipping = cost;
    //   estimasi = est;
    //   total = shipping + subtotal;
    //   // _isLoading = false;
    // });
    // _showMsg(cost.toString());
  }

  void order() async {
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
    // setState(() {
    //   _isLoading = true;
    // });
    var data = {
      'id_user': "$user_id",
      'recipient': "$recipient",
      'address': "$address (Kode Pos $codepost)",
      'phone': '$phone',
      'subtotal': "$subtotal",
      'shipment': "$shipping",
      'total': "$total",
      'resi': '-',
      'status': 'PENDING',
    };
    var res = await ApiService().createOrder(data);
    var body = jsonDecode(res.body);
    var message = body['message'];
    Navigator.of(context).pop(false);
    if (message == "SUCCESS") {
      // setState(() {
      //   _isLoading = false;
      // });
      Fluttertoast.showToast(msg: "Order berhasil...");
      await ApiService().getUserCarts();
      // Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => OrderFinalPage(shipment: total)));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentPage(
                    total: total,
                  )));
    } else {
      // setState(() {
      //   _isLoading = false;
      // });
      _showMsg("Terjadi kesalahan saat melakukan order...");
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
