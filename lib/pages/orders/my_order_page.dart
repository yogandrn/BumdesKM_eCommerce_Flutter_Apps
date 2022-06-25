import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/order.dart';
import 'package:bumdeskm/pages/orders/order_list_item.dart';
import 'package:bumdeskm/pages/product/catalog_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({Key? key}) : super(key: key);

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  bool _isLoading = true;
  List<Order> orders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    setState(() {});
  }

  void fetchData() async {
    orders.clear();
    var res = await ApiService().getUserOrder();
    setState(() {
      orders.addAll(res);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgWhite,
        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            await ApiService().getUserOrder();
            setState(() {
              _isLoading = true;
              // orders = [];
            });
            fetchData();
          },
          color: primaryColor,
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
                      BigText(text: "Pesanan Saya"),
                      Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.transparent,
                      ),
                    ]),
              ),
              Expanded(
                  child: Container(
                      child: _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: gray,
                                color: primaryColor,
                                strokeWidth: 6,
                              ),
                            )
                          : orders.length > 0
                              ? ListView(
                                  scrollDirection: Axis.vertical,
                                  children: orders
                                      .map((order) => OrderListItem(
                                            order: order,
                                            id: order.id,
                                            date: order.date,
                                            total: order.total,
                                            status: order.status,
                                            image: order.image,
                                          ))
                                      .toList(),
                                )
                              : Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/empty_order.png',
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SmallText(
                                        align: TextAlign.center,
                                        text:
                                            "Anda belum pernah\nmelakukan transaksi..",
                                        color: Color(0xFF404040),
                                        size: 14,
                                        weight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                ))),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        )),
        bottomNavigationBar: _isLoading
            ? Container(
                width: 0,
                height: 0,
              )
            : orders.length == 0
                ? Container(
                    margin: EdgeInsets.only(
                        left: 14, right: 14, top: 8, bottom: 12),
                    width: MediaQuery.of(context).size.width,
                    height: 56,
                    decoration: BoxDecoration(
                        color: primaryLight,
                        borderRadius: BorderRadius.circular(12),
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
                                builder: (context) => CatalogPage()));
                      },
                      child: BigText(
                        text: "Belanja Sekarang",
                        color: white,
                        size: 16,
                      ),
                    ),
                  )
                : Container(
                    // color: Colors.transparent,
                    width: 0,
                    height: 0,
                  ));
  }
}
