import 'package:flutter/material.dart';

class AppBanner {
  final int id, price;
  final String name;
  final String imgURL;

  AppBanner(this.id, this.name, this.price, this.imgURL);
}

List<AppBanner> bannerList = [
  AppBanner(1, "Lorem damet ipsum ", 59000, "assets/images/craft0"),
  AppBanner(2, "Lorem ipsum damet sir amet", 69000, "assets/images/craft0"),
  AppBanner(3, "Lorem anjay sit dolor", 109000, "assets/images/craft0"),
  AppBanner(4, "Lorem ipsum dolor amet ", 49000, "assets/images/craft0"),
  AppBanner(5, "Lorem ipsum anjay damet jamet", 65000, "assets/images/craft0"),
];
