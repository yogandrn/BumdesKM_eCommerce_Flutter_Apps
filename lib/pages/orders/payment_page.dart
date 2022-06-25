import 'package:flutter/material.dart';
import 'package:bumdeskm/pages/orders/my_order_page.dart';
import 'package:bumdeskm/pages/orders/upload_payment.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class PaymentPage extends StatefulWidget {
  var total;
  PaymentPage({Key? key, this.total = 0}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String rekening = '351712345678';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.symmetric(),
          child: Column(
            children: [
              Container(
                width: double.maxFinite,
                height: 60,
                color: white,
                padding: EdgeInsets.symmetric(horizontal: 6),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  BigText(text: "Pembayaran"),
                ]),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: white,
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(
                          text: 'Lakukan Transfer ke :',
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        BigText(
                          text: '$rekening',
                          color: primaryColor,
                          size: 20,
                        ),
                        SmallText(
                          text: 'A.n. BUMDES Mandiri',
                          size: 14,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/images/bni_logo.png',
                      width: MediaQuery.of(context).size.width / 3.25,
                      // height: 100,
                    )
                  ],
                ),
              ),
              Container(
                color: white,
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 10,
                  top: 12,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(
                        text: "Total Pembayaran :",
                        size: 15,
                        weight: FontWeight.w500,
                      ),
                      SmallText(
                        text: CurrencyFormat.convertToIdr(widget.total),
                        size: 16,
                        weight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ]),
              ),
              Container(
                color: white,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Divider(
                  height: 10,
                  color: grey81,
                  thickness: 1,
                ),
              ),
              Container(
                color: white,
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    BigText(
                      text: 'Petunjuk Pembayaran',
                      size: 14,
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Buka aplikasi M-Banking dari masing-masing Bank  atau pergi ke mesin ATM jika anda menggunakan kartu debit atau kartu kredit',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text: 'Masuk ke menu Transfer',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Buka aplikasi M-Banking dari masing-masing Bank  atau pergi ke mesin ATM jika anda menggunakan kartu debit atau kartu kredit',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Pilih Bank tujuan BNI, atau masukkan kode Bank 009, lalu masukkan nomor rekening di atas.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Masukkan jumlah nominal transfer sesuai pesanan.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Periksa kembali nomor rekening tujuan dan nominal transfer, jika sudah sesuai klik YA',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Jika berhasil melakukan transfer, unggah bukti pembayaran di bagian pesanan',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyOrderPage()));
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => MyOrderPage()),
            //     (Route<dynamic> route) => false);
          },
          child: BigText(
            text: 'Lihat Pesanan',
            color: white,
            size: 16,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(400, 56),
            primary: primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

class HowtoPayPage extends StatefulWidget {
  var id, total;
  HowtoPayPage({Key? key, this.id = 0, this.total = 0}) : super(key: key);

  @override
  State<HowtoPayPage> createState() => _HowtoPayPageState();
}

class _HowtoPayPageState extends State<HowtoPayPage> {
  String rekening = '351712345678';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          // padding: EdgeInsets.symmetric(),
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
                      BigText(text: "Cara Bayar"),
                      Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.transparent,
                      ),
                    ]),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: white,
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 24, bottom: 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(
                          text: 'Lakukan Transfer ke :',
                          size: 13,
                          weight: FontWeight.w500,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        BigText(
                          text: '$rekening',
                          color: primaryColor,
                          size: 20,
                        ),
                        SmallText(
                          text: 'A.n. BUMDES Mandiri',
                          size: 14,
                          weight: FontWeight.w500,
                        )
                      ],
                    ),
                    Image.asset(
                      'assets/images/bni_logo.png',
                      width: MediaQuery.of(context).size.width / 3.25,
                      // height: 100,
                    )
                  ],
                ),
              ),
              Container(
                color: white,
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 10,
                  top: 12,
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SmallText(
                        text: "Total Pembayaran :",
                        size: 15,
                        weight: FontWeight.w500,
                      ),
                      SmallText(
                        text: CurrencyFormat.convertToIdr(widget.total),
                        size: 16,
                        weight: FontWeight.w500,
                        color: primaryColor,
                      ),
                    ]),
              ),
              Container(
                color: white,
                padding: EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                child: Divider(
                  height: 10,
                  color: grey81,
                  thickness: 1,
                ),
              ),
              Container(
                color: white,
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 12,
                    ),
                    BigText(
                      text: 'Petunjuk Pembayaran',
                      size: 14,
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Buka aplikasi M-Banking dari masing-masing Bank  atau pergi ke mesin ATM jika anda menggunakan kartu debit atau kartu kredit',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text: 'Masuk ke menu Transfer',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Buka aplikasi M-Banking dari masing-masing Bank  atau pergi ke mesin ATM jika anda menggunakan kartu debit atau kartu kredit',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Pilih Bank tujuan BNI, atau masukkan kode Bank 009, lalu masukkan nomor rekening di atas.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Masukkan jumlah nominal transfer sesuai pesanan.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Periksa kembali nomor rekening tujuan dan nominal transfer, jika sudah sesuai klik YA',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.circle,
                          color: primaryColor,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 70,
                          child: LongText(
                            text:
                                'Jika sudah melakukan transfer, silakan unggah bukti pembayaran',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => UploadPayment(
                      id_trasanction: widget.id,
                    )));
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => MyOrderPage()),
            //     (Route<dynamic> route) => false);
          },
          child: BigText(
            text: 'Unggah Bukti Pembayaran',
            color: white,
            size: 16,
          ),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(400, 56),
            primary: primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
