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

class BestSellerPage extends StatefulWidget {
  const BestSellerPage({Key? key}) : super(key: key);

  @override
  State<BestSellerPage> createState() => _BestSellerPageState();
}

class _BestSellerPageState extends State<BestSellerPage> {
  bool _isLoading = true;
  List<Product> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    data.clear();
    final response = await ApiService().getAllBestSeller();
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
      // body: SafeArea(
      //   child: Stack(
      //     children: [
      //       Positioned(
      //         top: 0,
      //         left: 0,
      //         right: 0,
      //         child: Container(
      //           width: double.maxFinite,
      //           height: 60,
      //           color: white,
      //           padding: EdgeInsets.symmetric(horizontal: 6),
      //           child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 IconButton(
      //                   onPressed: () {
      //                     Navigator.pop(context);
      //                   },
      //                   icon: Icon(
      //                     Icons.arrow_back_rounded,
      //                     size: 30,
      //                   ),
      //                   color: primaryColor,
      //                 ),
      //                 BigText(text: "Katalog"),
      //                 IconButton(
      //                   onPressed: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                           builder: (context) => CartPage()),
      //                     );
      //                   },
      //                   icon: Icon(
      //                     Icons.shopping_cart_rounded,
      //                     size: 30,
      //                   ),
      //                   color: primaryColor,
      //                 ),
      //               ]),
      //         ),
      //       ),
      //       catalogList2(),
      //     ],
      //   ),
      // )
    );
  }

  // Widget catalogList() {
  //   Product product;
  //   return Container(
  //     padding: EdgeInsets.only(),
  //     child: GridView.builder(
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 2,
  //             crossAxisSpacing: 12,
  //             mainAxisSpacing: 12,
  //             childAspectRatio: 0.75),
  //         itemBuilder: (context, index) {
  //           return GestureDetector(
  //             onTap: () {},
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Container(
  //                     padding: EdgeInsets.all(12),
  //                     // For  demo we use fixed height  and width
  //                     // Now we dont need them
  //                     // height: 180,
  //                     // width: 160,
  //                     decoration: BoxDecoration(
  //                       color: white,
  //                       borderRadius: BorderRadius.circular(16),
  //                     ),
  //                     child: Hero(
  //                       tag: "${product.id}",
  //                       child: Image.network(product.image),
  //                     ),
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(vertical: 12),
  //                   child: SmallText(
  //                     // products is out demo list
  //                     text: product.name,
  //                   ),
  //                 ),
  //                 SmallText(
  //                   text: "Rp ${product.price}",
  //                   color: primaryColor,
  //                 )
  //               ],
  //             ),
  //           );
  //         }),
  //   );
  // }

  Widget CatalogBody() {
    return Column(
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
            BigText(text: "Produk Terlaris"),
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
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.76),
                      children: data
                          .map<Widget>((product) => BestSellerCard(
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
