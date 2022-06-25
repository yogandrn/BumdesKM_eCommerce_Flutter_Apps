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

class CatalogPage extends StatefulWidget {
  const CatalogPage({Key? key}) : super(key: key);

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool _isLoading = true;
  List<Product> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    data.clear();
    final response = await ApiService().getAllProducts();
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
    return new Column(
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
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            BigText(text: "Katalog"),
            Icon(
              Icons.close,
              size: 30,
              color: Colors.transparent,
            ),
          ]),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              fetchData();
            },
            color: primaryColor,
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
                  : GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
