import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bumdeskm/widgets/big_text.dart';
// import 'package:carousel_indicator/carousel_indicator.dart';
// import 'package:dots_indicator/dots_indicator.dart';

class Trial1 extends StatefulWidget {
  const Trial1({Key? key}) : super(key: key);

  @override
  State<Trial1> createState() => _Trial1State();
}

class _Trial1State extends State<Trial1> {
  var id = 1;
  List images = [];
  var pageIndex = 0;

  getImages() async {
    var res = await http.get(
        Uri.parse('http://192.168.1.2/coba_api/public/api/product/images/$id'));
    var json = jsonDecode(res.body);

    for (var u in json) {
      images.add(u['image']);
    }

    print(images[0]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getImages();
    // print(images[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2.8,
          child: PageView.builder(
              itemCount: images.length,
              pageSnapping: true,
              controller: PageController(viewportFraction: 1.0),
              onPageChanged: (page) {
                setState(() {
                  pageIndex = page;
                });
              },
              itemBuilder: (context, pageIndex) {
                // return Container(
                //   // margin: EdgeInsets.all(10),
                //   child: Image.network(images[pageIndex]),
                // );
                return imageItem(pageIndex);
              }),
        ),
      ],
    );
  }

  Widget imageCarousel() {
    return Container(
      height: MediaQuery.of(context).size.height / 2.95,
      child: PageView.builder(
          itemCount: images.length,
          pageSnapping: true,
          controller: PageController(viewportFraction: 1.0),
          onPageChanged: (page) {
            setState(() {
              pageIndex = page;
            });
          },
          itemBuilder: (context, index) {
            return imageItem(index);
          }),
    );
  }

  Widget imageItem(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.8,
      child: Image.network(
        images[index],
        fit: BoxFit.cover,
      ),
    );
  }
}
