import 'package:bumdeskm/widgets/product_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/model_product.dart';
import 'package:bumdeskm/models/picsum.dart';
import 'package:bumdeskm/pages/cart/cart_page.dart';
import 'package:bumdeskm/pages/product/detail_product_page.dart';
import 'package:bumdeskm/pages/product/product_card.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import '../../models/product.dart';

class SearchPage extends StatefulWidget {
  String keyword;
  SearchPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = true;
  String keyword = "";
  List<Product> data = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      keyword = widget.keyword;
    });
    fetchData();
  }

  fetchData() async {
    data.clear();
    final response = await ApiService().searchProduct(keyword);
    setState(() {
      _isLoading = true;
      data.addAll(response);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: CatalogBody(),
      ),
    );
  }

  Widget CatalogBody() {
    return new RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _isLoading = true;
        });
        fetchData();
      },
      color: primaryColor,
      child: new Column(
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
                  BigText(text: "Pencarian"),
                  Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.transparent,
                  ),
                ]),
          ),
          data.length == 0
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: 0,
                  // margin: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 4),
                  // child: ProductText(
                  //   text: "Hasil pencarian \"$keyword\" tidak ditemukan",
                  //   size: 15,
                  //   weight: FontWeight.w500,
                  // ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  margin:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
                  child: ProductText(
                    text: "Hasil pencarian dari \"$keyword\" :",
                    size: 15,
                    weight: FontWeight.w500,
                  ),
                ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
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
                  : data.length > 0
                      ? GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio: 0.76),
                          children: data
                              .map<Widget>((product) => ProductCard(
                                    product: product,
                                    id: product.id,
                                  ))
                              .toList(),
                        )
                      : Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/search_not_found.png',
                                width: MediaQuery.of(context).size.width / 2.5,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SmallText(
                                align: TextAlign.center,
                                text:
                                    "Tidak ditemukan\nhasil pencarian untuk \"$keyword\"",
                                color: Color(0xFF404040),
                                size: 13.6,
                                weight: FontWeight.w500,
                              )
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
