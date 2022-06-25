import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/model_product.dart';
import 'package:bumdeskm/models/product.dart';
import 'package:bumdeskm/pages/product/detail_product_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final int id;
  const ProductCard({Key? key, required this.product, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 350,
      // width: 285,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: gray,
            offset: Offset(2, 2),
            blurRadius: 13,
          )
        ],
        // borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailProductPage(
                        id: id,
                        // isFavorite: product.isFavorite,
                        // price: product.price,
                        // stock: product.stock,
                        // name: product.title,
                        // image: product.image,
                        // description:
                        //     id.toString() + " - " + product.description
                      )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(context),
            buildBodyText(context),
            // buildFooter(context),
          ],
        ),
      ),
    );
  }

  Stack buildImage(context) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: silver,
            image: DecorationImage(
                image: NetworkImage(ApiService().imgURL + "${product.image}"),
                fit: BoxFit.cover),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            // borderRadius: BorderRadius.circular(8),
          ),
        ),
        product.stock == 0
            ? Positioned(
                top: 10,
                left: 0,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: SmallText(
                      text: "Stok Habis",
                      color: white,
                      size: 11.8,
                      weight: FontWeight.w500,
                    ),
                  )
                ]),
              )
            : Positioned(
                top: 8,
                right: 16,
                child: Container(),
              )
      ],
    );
  }

  Container buildBodyText(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: white,
      ),
      padding: const EdgeInsets.only(left: 10, right: 9, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            // width: 150,
            // height: 35,
            child: ProductText(
              text: product.title,
              size: 13.5,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            // width: 150,
            // height: 35,
            child: ProductText(
              text: CurrencyFormat.convertToIdr(product.price),
              size: 15,
              color: primaryColor,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }
}

class BestSellerCard extends StatelessWidget {
  final Product product;
  final int id;
  const BestSellerCard({Key? key, required this.product, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 350,
      // width: 285,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            color: gray,
            offset: Offset(2, 2),
            blurRadius: 13,
          )
        ],
        // borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: primaryColor, width: 1.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailProductPage(
                        id: id,
                        // isFavorite: product.isFavorite,
                        // price: product.price,
                        // stock: product.stock,
                        // name: product.title,
                        // image: product.image,
                        // description:
                        //     id.toString() + " - " + product.description
                      )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildImage(context),
            buildBodyText(context),
            // buildFooter(context),
          ],
        ),
      ),
    );
  }

  Stack buildImage(context) {
    return Stack(
      children: [
        Container(
          height: 160,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: silver,
            image: DecorationImage(
                image: NetworkImage(ApiService().imgURL + "${product.image}"),
                fit: BoxFit.cover),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            // borderRadius: BorderRadius.circular(8),
          ),
        ),
        product.stock == 0
            ? Positioned(
                top: 10,
                left: 0,
                // right: 0,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: SmallText(
                      text: "Stok Habis",
                      color: white,
                      size: 11.8,
                      weight: FontWeight.w500,
                    ),
                  ),
                  // Container(
                  //   padding:
                  //       EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //   decoration: BoxDecoration(
                  //     color: primaryColor,
                  //   ),
                  //   child: SmallText(
                  //     text: product.sold.toString() + " terjual",
                  //     color: white,
                  //     size: 11.8,
                  //     weight: FontWeight.w500,
                  //   ),
                  // )
                ]),
              )
            : Positioned(
                top: 8,
                right: 0,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                    ),
                    child: SmallText(
                      text: product.sold.toString() + " terjual",
                      color: white,
                      size: 11.8,
                      weight: FontWeight.w500,
                    ),
                  )
                ]),
              )
      ],
    );
  }

  Container buildBodyText(BuildContext context) {
    return Container(
      width: double.maxFinite,
      // height: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        color: white,
      ),
      padding: const EdgeInsets.only(left: 10, right: 9, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          SizedBox(
            // width: 150,
            // height: 35,
            child: ProductText(
              text: product.title,
              size: 13.5,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            // width: 150,
            // height: 35,
            child: ProductText(
              text: CurrencyFormat.convertToIdr(product.price),
              size: 15,
              color: primaryColor,
              weight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 6,
          )
        ],
      ),
    );
  }
}
