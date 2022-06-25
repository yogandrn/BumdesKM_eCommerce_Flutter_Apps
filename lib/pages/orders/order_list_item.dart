import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/order.dart';
import 'package:bumdeskm/pages/orders/detail_order_page.dart';
import 'package:bumdeskm/pages/product/detail_product_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class OrderListItem extends StatelessWidget {
  Order order;
  var id, total, date, status, image;

  OrderListItem({
    Key? key,
    required this.order,
    required this.id,
    required this.date,
    required this.total,
    required this.status,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 105,
      margin: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        color: white,
        // borderRadius: BorderRadius.circular(8),
        // border: Border.all(width: 1, color: Color.fromARGB(255, 194, 194, 194)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Color(0xFF818181), offset: Offset(0, 3), blurRadius: 5)
        // ],
      ),
      padding: EdgeInsets.only(left: 14, top: 10, bottom: 10, right: 14),
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        SizedBox(
          height: 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmallText(
              text: '$date',
              size: 12,
              color: grey40,
              weight: FontWeight.w500,
            ),
            ProductText(
              text: status == "PENDING"
                  ? 'Menunggu Pembayaran'
                  : status == "ON_PROCESS"
                      ? 'Diproses'
                      : status == "ON_DELIVERY"
                          ? 'Dikirim'
                          : status == "SUCCESS"
                              ? 'Selesai'
                              : status == "CANCEL"
                                  ? 'Dibatalkan'
                                  : status == 'WAITING'
                                      ? 'Menunggu Konfirmasi'
                                      : '-',
              size: 12,
              weight: FontWeight.w500,
              color: primaryColor,
              align: TextAlign.end,
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: gray,
                borderRadius: BorderRadius.circular(5),
                // image: CachedNetworkImage(imageUrl: ApiService().imgURL + image,),
                image: DecorationImage(
                    image: NetworkImage(ApiService().imgURL + image),
                    fit: BoxFit.cover),
              ),
              // child: CachedNetworkImage(
              //   imageUrl: ApiService().imgURL + image,
              //   fit: BoxFit.cover,
              // ),
            ),
            SizedBox(
              width: 12,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      BigText(
                        text: 'Total Transaksi :',
                        size: 12.5,
                        weight: FontWeight.w400,
                        color: black,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      ProductText(
                        text: CurrencyFormat.convertToIdr(total),
                        size: 13,
                        weight: FontWeight.w600,
                        color: primaryColor,
                        align: TextAlign.end,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailOrderPage(
                                    id: order.id,
                                  )));
                    },
                    child: SmallText(
                      text: "Lihat",
                      color: white,
                      size: 13,
                      weight: FontWeight.w600,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // <-- Radius
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}

class OrderProductItem extends StatelessWidget {
  var title, price, qty, subtotal, image;
  OrderProductItem({
    Key? key,
    required this.title,
    required this.price,
    required this.qty,
    required this.subtotal,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 84,
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(width: 1, color: Color.fromARGB(255, 204, 204, 204)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Color(0xFF818181), offset: Offset(0, 3), blurRadius: 5)
        // ],
      ),
      padding: EdgeInsets.only(left: 6, top: 6, bottom: 6, right: 0),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                    image: NetworkImage(
                      ApiService().imgURL + image,
                    ),
                    fit: BoxFit.cover)),
          ),
          SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 1.58,
                      child:
                          ProductText(text: "$title", height: 1.0, size: 12.8)),
                ],
              ),
              Row(
                children: [
                  ProductText(
                      text: CurrencyFormat.convertToIdr(price),
                      color: primaryColor,
                      weight: FontWeight.w500,
                      size: 12.8),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.58,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProductText(text: "Jumlah : $qty", size: 12.8),
                      ProductText(
                          text: CurrencyFormat.convertToIdr(subtotal),
                          color: primaryColor,
                          weight: FontWeight.w500,
                          size: 13),
                    ]),
              ),
            ],
          )
          // Column(
          //   children: [
          //     ProductText(text: "$title"),
          //     SizedBox(
          //       height: 8,
          //     ),
          //     ProductText(
          //       text: CurrencyFormat.convertToIdr(price),
          //       color: primaryColor,
          //       weight: FontWeight.w500,
          //     ),
          //     SizedBox(
          //       height: 8,
          //     ),
          //     ProductText(
          //       text: CurrencyFormat.convertToIdr(subtotal),
          //       color: primaryColor,
          //       weight: FontWeight.w500,
          //     ),
          //   ],
          // )
        ],
      ),
    );
  }
}
