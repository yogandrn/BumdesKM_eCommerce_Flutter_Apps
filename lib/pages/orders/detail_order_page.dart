import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/order.dart';
import 'package:bumdeskm/pages/cart/cart_page.dart';
import 'package:bumdeskm/pages/orders/my_order_page.dart';
import 'package:bumdeskm/pages/orders/send_review.dart';
import 'package:bumdeskm/pages/orders/order_list_item.dart';
import 'package:bumdeskm/pages/orders/payment_page.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class DetailOrderPage extends StatefulWidget {
  int id;
  DetailOrderPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailOrderPage> createState() => _DetailOrderPageState();
}

class _DetailOrderPageState extends State<DetailOrderPage> {
  bool _isLoading = true;
  int id_trx = 0;
  var date = "0000-00-00 00:00:00";
  var status = "...";
  var recipient = "...";
  var address = ".....";
  var phone = "...";
  var subtotal = 0;
  var shipment = 0;
  var total = 0;
  var resi = "...";
  List<OrderItem> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      id_trx = widget.id;
    });
    getOrderDetail();
    getOrderItem();
  }

  void getOrderDetail() async {
    var res = await ApiService().getDataOrder(widget.id);
    var body = jsonDecode(res.body);
    setState(() {
      id_trx = widget.id;
      date = body['date'];
      var a = body['status'];
      switch (a) {
        case ('PENDING'):
          status = "Menunggu Pembayaran";
          break;
        case ('ON_PROCESS'):
          status = "Diproses";
          break;
        case ('WAITING'):
          status = "Menunggu Konfirmasi";
          break;
        case ('ON_DELIVERY'):
          status = "Dikirim";
          break;
        case ('SUCCESS'):
          status = "Selesai";
          break;
        default:
          status = body['status'];
          break;
      }
      recipient = body['recipient'];
      address = body['address'];
      phone = body['phone'];
      subtotal = body['subtotal'];
      shipment = body['shipment'];
      total = body['total'];
      resi = body['resi'];
      _isLoading = false;
    });
  }

  void getOrderItem() async {
    items.clear();
    var res = await ApiService().getOrderItem(widget.id);
    setState(() {
      items.addAll(res);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgWhite,
        body: SafeArea(
          child: RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              getOrderDetail();
              getOrderItem();
            },
            child: _isLoading
                ? ListView(
                    children: [
                      myAppBar(),
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
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      myAppBar(),
                      // Container(
                      //   color: gray,
                      //   height: MediaQuery.of(context).size.height / 6,
                      // ),
                      Container(
                        color: white,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        margin: EdgeInsets.only(bottom: 12, top: 12),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallText(
                                text: 'Status Transaksi',
                              ),
                              SmallText(
                                text: '$status',
                                weight: FontWeight.w500,
                                color: primaryColor,
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
                                text: 'Kode Transaksi',
                              ),
                              SmallText(
                                text: '$id_trx',
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
                                text: 'Tanggal Transaksi',
                              ),
                              SmallText(
                                text: '$date',
                                weight: FontWeight.w500,
                                color: primaryColor,
                                size: 12.8,
                              ),
                            ],
                          ),
                        ]),
                      ),
                      Container(
                        color: white,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        margin: EdgeInsets.only(bottom: 12),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                text: "Alamat Penerima",
                                size: 14,
                                weight: FontWeight.w500,
                                color: primaryColor,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: ProductText(
                                  text: '$recipient',
                                  size: 12.8,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: ProductText(
                                  text: '$address ',
                                  line: 6,
                                  size: 12.8,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.3,
                                child: ProductText(
                                  text: '$phone',
                                  size: 12.8,
                                ),
                              ),
                            ]),
                      ),

                      Container(
                        color: white,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        margin: EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BigText(
                              text: "Pesanan Saya",
                              size: 14,
                              weight: FontWeight.w500,
                              color: primaryColor,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: items
                                  .map((item) => OrderProductItem(
                                      title: item.title,
                                      price: item.price,
                                      qty: item.qty,
                                      subtotal: item.subtotal,
                                      image: item.image))
                                  .toList(),
                            ),
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
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        color: white,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: 'Biaya Pengiriman',
                                  ),
                                  SmallText(
                                    text: CurrencyFormat.convertToIdr(shipment),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: 'Nomor Resi',
                                  ),
                                  SmallText(
                                    text: "$resi",
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

                      Container(
                        color: white,
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        margin: EdgeInsets.only(bottom: 16),
                        child: Column(children: [
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
                                text: CurrencyFormat.convertToIdr(shipment),
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
                                weight: FontWeight.w600,
                                color: primaryColor,
                                size: 14,
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ],
                  ),
          ),
        ),
        bottomNavigationBar: _isLoading
            ? Container(
                height: 0,
                width: 0,
              )
            : status == "Menunggu Pembayaran"
                ? Container(
                    height: 68,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: white, boxShadow: [
                      BoxShadow(
                          color: grey81, offset: Offset(0, 8), blurRadius: 12),
                    ]),
                    padding: EdgeInsets.only(
                        left: 14, right: 14, bottom: 10, top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HowtoPayPage(
                                      id: id_trx,
                                      total: total,
                                    )));
                      },
                      child: BigText(
                        text: 'Bayar',
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
                  )
                : status == "Dikirim"
                    ? Container(
                        height: 68,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: white, boxShadow: [
                          BoxShadow(
                              color: grey81,
                              offset: Offset(0, 8),
                              blurRadius: 12),
                        ]),
                        padding: EdgeInsets.only(
                            left: 14, right: 14, bottom: 10, top: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             SendReviewPage(order_id: id_trx)));
                            confirmDelete(context);
                          },
                          child: BigText(
                            text: 'Konfirmasi',
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
                      )
                    : Container(
                        height: 68,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(color: white, boxShadow: [
                          BoxShadow(
                              color: grey81,
                              offset: Offset(0, 8),
                              blurRadius: 12),
                        ]),
                        padding: EdgeInsets.only(
                            left: 14, right: 14, bottom: 10, top: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: BigText(
                            text: 'Kembali',
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
                      ));
  }

  confirmDelete(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: SmallText(
        text: "Batal",
        color: grey40,
        size: 13.5,
        weight: FontWeight.w500,
      ),
      // color: Color(0xFFD9D9D9),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = FlatButton(
      child: SmallText(
        text: "Konfirmasi",
        color: primaryColor,
        size: 13.5,
        weight: FontWeight.w500,
      ),
      onPressed: () async {
        Navigator.of(context).pop(true);
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
        // var data = {"id": id_trx, "status": "Selesai"};
        var res = await ApiService().confirmOrder(id_trx);
        var body = jsonDecode(res.body);
        if (body['message'] == "SUCCESS") {
          Navigator.of(context).pop(true);
          // Fluttertoast.showToast(msg: "Berhasil mengkonfirmasi pesanan");
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SendReviewPage(
                  order_id: id_trx,
                ),
              ));
        } else {
          Fluttertoast.showToast(
              msg: "Terjadi kesalahan saat mengkonfirmasi pesanan");
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: SmallText(
        text: "Konfirmasi Pesanan",
        size: 14,
        weight: FontWeight.w500,
      ),
      content: ProductText(
          text: "Apakah Anda yakin ingin melakukan konfirmasi pesanan ini ?"),
      actions: [
        cancelButton,
        continueButton,
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
}

class myAppBar extends StatelessWidget {
  const myAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 60,
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 6),
      margin: EdgeInsets.only(bottom: 0),
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
        BigText(text: "Detail Pesanan"),
        Icon(
          Icons.close,
          size: 30,
          color: Colors.transparent,
        ),
      ]),
    );
  }
}

class DetailOrder extends StatefulWidget {
  const DetailOrder({Key? key}) : super(key: key);

  @override
  State<DetailOrder> createState() => _DetailOrderState();
}

class _DetailOrderState extends State<DetailOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
          child: ListView(
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
                  BigText(text: "Detail Pesanan"),
                  Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.transparent,
                  ),
                ]),
          ),
          Container(
            color: white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status Transaksi',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Menunggu Pembayaran',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  height: 20,
                  color: Colors.black87,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nomor Transaksi',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'TRK-2204022',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tanggal Transaksi',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '2022-04-20 21:50:01',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 500,
            color: white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'Alamat Penerima',
                style:
                    TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Yoga'),
              Text('Jombang'),
              Text('082364777645'),
            ]),
          ),
          SizedBox(height: 10),
          Container(
            color: white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pesanan',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Card(
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Image.network(
                        'https://images.unsplash.com/photo-1585155770447-2f66e2a397b5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8OHx8cHJvZHVjdHN8ZW58MHx8MHx8&auto=format&fit=crop&w=800&q=60',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lorem ipsum sir amet'),
                          SizedBox(height: 5),
                          Text(
                            'Rp 59.000',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10),
                          Text('Qty : 1'),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 15)),
                      Text(
                        'Rp 59.000',
                        style: TextStyle(
                            color: primaryColor, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Belanja',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    Text(
                      'Rp 59.000',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Pengiriman',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '...',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '-',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Biaya Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Rp. 20.000',
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            color: white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Transaksi',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Rp. 79.000',
                  style: TextStyle(
                      color: primaryColor, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            color: white,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Bayar'),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(340, 50),
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
