// import 'dart:ffi';

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/detail_product.dart';
import 'package:bumdeskm/models/product.dart';
import 'package:bumdeskm/pages/cart/cart_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

class DetailProductPage extends StatefulWidget {
  int id;
  // int price, stock, sold, weight;
  // String name, description, image, materials;
  // bool isFavorite;
  DetailProductPage({
    Key? key,
    required this.id,
    // required this.name,
    // required this.description,
    // required this.materials,
    // required this.price,
    // required this.stock,
    // required this.weight,
    // required this.sold,
    // required this.isFavorite,
    // this.image =
    //     "https://thumbs.dreamstime.com/b/flat-isolated-vector-eps-illustration-icon-minimal-design-long-shadow-error-file-not-found-web-118526724.jpg"
  }) : super(key: key);

  @override
  State<DetailProductPage> createState() => _DetailProductPageState();
}

class _DetailProductPageState extends State<DetailProductPage> {
  // double _height = MediaQuery.of().size.height;
  static int qty = 1;
  static int id = 0;
  List<Product> data = [];
  List<ProductImage> imageList = [];
  List images = [];
  bool isLoading = true;
  var pageIndex = 0;
  // String image = DetailProduct.
  var title = "";
  var description = "......";
  var materials = "...";
  var price = 0;
  var stock = 0;
  var weight = 0;
  var sold = 0;
  var subtotal = 0;
  var image =
      "https://i.pinimg.com/originals/c9/22/68/c92268d92cf2dbf96e3195683d9e14fb.png";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getDataProduct(widget.id);
    setState(() {
      id = widget.id;
    });
    getImages(id);
    _getDetailProduk();
    // getProductImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _decrement() {
    setState(() {
      if (qty == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(
            "Minimum pembelian adalah 1 !",
          ),
          backgroundColor: Colors.red,
        ));
      } else {
        qty--;
      }
    });
  }

  void _increment() {
    setState(() {
      if (qty == stock) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Text("Batas maximum pembelian terpenuhi!"),
          backgroundColor: Colors.red,
        ));
      } else {
        qty++;
      }
    });
  }

  void _getDetailProduk() async {
    var res = await ApiService().getDataProduct(widget.id);
    var body = json.decode(res.body);
    setState(() {
      title = body['title'];
      price = body['price'];
      stock = body['stock'];
      description = body['description'];
      materials = body['materials'];
      weight = body['weight'];
      image = body['image'];
      sold = body['sold'];
      isLoading = false;
    });
  }

  getImages(var id_p) async {
    images.clear();
    setState(() {
      isLoading = true;
    });
    var res = await http
        .get(Uri.parse(ApiService().baseURL + "/product/images/$id_p"));
    var json = jsonDecode(res.body);

    for (var u in json) {
      images.add(u['image']);
    }
    setState(() {
      isLoading = false;
    });
  }

  _getImages() async {
    var res = await ApiService().getImages(widget.id);
    var body = json.decode(res.body);
    // images.addAll(body);
    setState(() {
      images = jsonDecode(res.body);
    });
  }

  void getProductImage() async {
    var res = await ApiService().getProductImage(widget.id);
    setState(() {
      imageList.addAll(res);
      // images.addAll(res);
    });
  }

  void addToCart() async {
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id_user = preferences.getInt('id_user');
    var data = {
      "id_user": id_user,
      "id_product": id,
      "qty": qty,
      "subtotal": price * qty,
    };
    var res = await ApiService().addToCart(data);
    var body = json.decode(res.body);
    var message = body['message'];
    Navigator.of(context).pop(false);
    if (message == "SUCCESS") {
      await ApiService().getUserData();
      _showMsg("Berhasil menambahkan ke Keranjang!");
    } else {
      _showMsgError(message);
    }

    setState(() {
      qty = 1;
    });
  }

  _showMsgError(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 1),
      backgroundColor: Color(0xFF0f8a30),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget myAppBar() {
    return new Container(
      width: double.maxFinite,
      height: 60,
      color: white,
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        IconButton(
          onPressed: () {
            setState(() {
              qty = 1;
            });
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_rounded,
            size: 30,
          ),
          color: primaryColor,
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 1.4,
            child: (isLoading == true || title == "")
                ? Container(
                    margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    color: bgWhite,
                  )
                : SmallText(
                    text: title,
                    size: 18,
                    weight: FontWeight.w500,
                    align: TextAlign.center,
                  )),
        IconButton(
          onPressed: () {
            setState(() {
              qty = 1;
            });
            Navigator.push(
              context,
              // DetailPage adalah halaman yang dituju
              MaterialPageRoute(builder: (context) => CartPage()),
            );
          },
          icon: Icon(
            Icons.shopping_cart_rounded,
            size: 28,
          ),
          color: primaryColor,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Product data;
    return Scaffold(
      backgroundColor: bgWhite,
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            getImages(id);
            _getDetailProduk();
          },
          child: isLoading
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
                    )
                  ],
                )
              : ListView(
                  children: [
                    myAppBar(),
                    Column(
                      children: [
                        Container(
                          height: 350,
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(bottom: 10),
                          height: 24,
                          color: white,
                          child: Center(
                            child: CarouselIndicator(
                              count:
                                  (images.length == 0 || images.length == null)
                                      ? 1
                                      : images.length,
                              index: pageIndex,
                              color: gray,
                              activeColor: primaryColor,
                            ),
                          ),
                        ),

                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   height: 15,
                        //   color: white,
                        //   child: PageViewDotIndicator(
                        //     currentItem: pageIndex,
                        //     count: isLoading ? 1 : images.length,
                        //     unselectedColor: Colors.black26,
                        //     selectedColor: Colors.blue,
                        //   ),
                        // ),

                        // DotsIndicator(
                        //   dotsCount: images.length,
                        //   position: pageIndex.toDouble(),
                        //   decorator: DotsDecorator(
                        //     size: const Size.square(8.0),
                        //     activeSize: const Size(18.0, 9.0),
                        //     activeShape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(5.0)),
                        //   ),
                        // ),

                        // // image produk
                        // Container(
                        //   width: double.maxFinite,
                        //   // height: _height / 2.4,
                        //   height: 350,
                        //   decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //           image: NetworkImage(image), fit: BoxFit.cover)),
                        // ),

                        // title produk
                        // Container(
                        //     width: double.maxFinite,
                        //     height: MediaQuery.of(context).size.height / 2.5,
                        //     child: PageView.builder(
                        //         itemCount: images.length,
                        //         pageSnapping: true,
                        //         itemBuilder: (context, index) {
                        //           return Container(
                        //               margin: EdgeInsets.all(10),
                        //               child: Image.network(
                        //                 images[index],
                        //                 fit: BoxFit.cover,
                        //               ));
                        //         })
                        //     // width: double.maxFinite,
                        //     // // height: _height / 2.4,
                        //     // height: 350,
                        //     // decoration: BoxDecoration(
                        //     //     image: DecorationImage(
                        //     //         image: NetworkImage(image), fit: BoxFit.cover)),
                        //     ),

                        // product name and price
                        Container(
                          color: white,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 240,
                                    child: ProductText(
                                      text: '$title',
                                      size: 16,
                                      weight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ProductText(
                                    text: CurrencyFormat.convertToIdr(price),
                                    size: 18,
                                    weight: FontWeight.w500,
                                    color: primaryColor,
                                  )
                                ],
                              ),
                              Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        // product info
                        Container(
                          color: white,
                          width: double.maxFinite,
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 14),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: "Bahan",
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                  SmallText(
                                    text: materials,
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: "Berat",
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                  SmallText(
                                    text: weight.toString() + " gr",
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: "Stok",
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                  SmallText(
                                    // text: stock == 0
                                    //     ? "Habis"
                                    //     : stock > 0
                                    //         ? stock.toString()
                                    //         : '...',
                                    text:
                                        stock == 0 ? "Habis" : stock.toString(),
                                    size: 14,
                                    weight: FontWeight.w500,
                                    color: stock == 0 ? Colors.red : black,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SmallText(
                                    text: "Terjual",
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                  SmallText(
                                    text: sold.toString(),
                                    size: 14,
                                    weight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        // product description
                        Container(
                            color: white,
                            width: double.maxFinite,
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 14),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SmallText(
                                    text: "Deskripsi Produk",
                                    size: 15,
                                    weight: FontWeight.w600,
                                    color: black,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SmallText(
                                    text: "$description",
                                    // "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptas ex delectus excepturi! Quidem laudantium sapiente, sit id illum earum itaque nobis! Accusantium corporis in possimus eligendi. Exercitationem minus facilis saepe obcaecati numquam nam recusandae labore blanditiis laudantium at, neque adipisci earum eum molestiae, sapiente accusantium est aspernatur rerum ratione! Autem voluptate mollitia accusamus porro dolores quo, ex, aliquam veritatis nemo aliquid odit vitae molestiae tempora ad ullam iste esse ratione eius totam officiis! Laudantium dignissimos suscipit, quisquam cumque voluptatem cum numquam ducimus magni aliquam excepturi inventore ipsum, modi quis ratione laboriosam nulla voluptates optio exercitationem tempora accusamus iure doloremque. Nobis culpa quidem unde ducimus eaque cum illo quo saepe placeat voluptatum qui cupiditate ad laborum velit nemo, doloribus iste voluptas voluptatem numquam. Explicabo harum porro voluptatibus tenetur assumenda eligendi suscipit labore et! Suscipit assumenda, maxime ullam quibusdam eligendi unde, facere laboriosam impedit iste cumque minima fugit a nemo blanditiis in sit reiciendis. Modi, soluta consequatur in et eum pariatur suscipit asperiores. Voluptate consequatur doloremque suscipit qui quia aut, quisquam dolores unde esse totam alias similique labore sint fugiat eius vero sit ut corrupti porro earum aliquid pariatur magnam! Repudiandae, ipsa possimus! Veritatis asperiores molestiae quasi et ratione vel natus soluta?",
                                    color: Color(0xFF404040),
                                    wrap: true,
                                    align: TextAlign.justify,
                                  ),
                                  SizedBox(
                                    height: 8,
                                  )
                                ])),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
        ),
      ),
      bottomNavigationBar: isLoading
          ? Container(
              height: 0,
              width: 0,
            )
          : stock == 0
              ? Container(
                  height: 0,
                  width: 0,
                )
              : Container(
                  height: 75,
                  width: double.maxFinite,
                  decoration: BoxDecoration(color: white, boxShadow: [
                    BoxShadow(
                        color: grey81, offset: Offset(0, 8), blurRadius: 12),
                  ]),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 156,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: gray,
                                  borderRadius: BorderRadius.circular(12)),
                              child: IconButton(
                                  onPressed: () {
                                    _decrement();
                                  },
                                  icon: Icon(
                                    Icons.remove,
                                    color: primaryColor,
                                    size: 24,
                                  )),
                            ),
                            BigText(text: '$qty'),
                            Container(
                              // padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: gray,
                                  borderRadius: BorderRadius.circular(12)),
                              child: IconButton(
                                  onPressed: () {
                                    _increment();
                                  },
                                  icon: Icon(
                                    Icons.add,
                                    color: primaryColor,
                                    size: 24,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.3,
                        height: 56,
                        decoration: BoxDecoration(
                          color: primaryLight,
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [primaryColor, secondaryColor]),
                        ),
                        child: TextButton(
                            style: TextButton.styleFrom(
                                shadowColor: Color(0xFFd9d9d9),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                )),
                            onPressed: () {
                              addToCart();
                            },
                            child: BigText(
                              text: "Add to Cart",
                              color: white,
                              size: 17,
                            )),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget imageItem(int index) {
    return Container(
      color: silver,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.8,
      child: CachedNetworkImage(
        imageUrl: ApiService().imgURL + images[index],
        fit: BoxFit.cover,
      ),
    );
  }
}

// class DetailProductPage2 extends StatelessWidget {
//   int id, price;
//   String name, description, image;

//   DetailProductPage2(
//       {Key? key,
//       required this.id,
//       required this.price,
//       required this.name,
//       required this.description,
//       this.image =
//           "https://thumbs.dreamstime.com/b/flat-isolated-vector-eps-illustration-icon-minimal-design-long-shadow-error-file-not-found-web-118526724.jpg"})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double _height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: bgWhite,
//       body: SafeArea(
//           child: Stack(
//         children: [
//           ListView(
//             children: [
//               Column(
//                 children: [
//                   // image produk
//                   Container(
//                     width: double.maxFinite,
//                     height: _height / 2.4,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: NetworkImage(image), fit: BoxFit.cover)),
//                   ),
//                   // product name and price
//                   Container(
//                     color: white,
//                     width: double.maxFinite,
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             BigText(
//                               text: name,
//                               size: 16,
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             BigText(
//                               text: "Rp " + price.toString(),
//                               size: 18,
//                               color: primaryColor,
//                             )
//                           ],
//                         ),
//                         IconButton(
//                           onPressed: () {},
//                           icon: Icon(
//                             Icons.favorite_border_outlined,
//                           ),
//                           iconSize: 25,
//                           color: primaryColor,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 14,
//                   ),
//                   // product info
//                   Container(
//                     color: white,
//                     width: double.maxFinite,
//                     padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SmallText(
//                               text: "Bahan",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                             SmallText(
//                               text: "Kayu",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SmallText(
//                               text: "Stok",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                             SmallText(
//                               text: "12",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SmallText(
//                               text: "Berat",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                             SmallText(
//                               text: "800" + " gr",
//                               size: 14,
//                               weight: FontWeight.w500,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 14,
//                   ),
//                   // product description
//                   Container(
//                       color: white,
//                       width: double.maxFinite,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             SmallText(
//                               text: "Deskripsi Produk",
//                               size: 15,
//                               weight: FontWeight.w500,
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             SmallText(
//                               text: description,
//                               // "Lorem ipsum dolor sit, amet consectetur adipisicing elit. Voluptas ex delectus excepturi! Quidem laudantium sapiente, sit id illum earum itaque nobis! Accusantium corporis in possimus eligendi. Exercitationem minus facilis saepe obcaecati numquam nam recusandae labore blanditiis laudantium at, neque adipisci earum eum molestiae, sapiente accusantium est aspernatur rerum ratione! Autem voluptate mollitia accusamus porro dolores quo, ex, aliquam veritatis nemo aliquid odit vitae molestiae tempora ad ullam iste esse ratione eius totam officiis! Laudantium dignissimos suscipit, quisquam cumque voluptatem cum numquam ducimus magni aliquam excepturi inventore ipsum, modi quis ratione laboriosam nulla voluptates optio exercitationem tempora accusamus iure doloremque. Nobis culpa quidem unde ducimus eaque cum illo quo saepe placeat voluptatum qui cupiditate ad laborum velit nemo, doloribus iste voluptas voluptatem numquam. Explicabo harum porro voluptatibus tenetur assumenda eligendi suscipit labore et! Suscipit assumenda, maxime ullam quibusdam eligendi unde, facere laboriosam impedit iste cumque minima fugit a nemo blanditiis in sit reiciendis. Modi, soluta consequatur in et eum pariatur suscipit asperiores. Voluptate consequatur doloremque suscipit qui quia aut, quisquam dolores unde esse totam alias similique labore sint fugiat eius vero sit ut corrupti porro earum aliquid pariatur magnam! Repudiandae, ipsa possimus! Veritatis asperiores molestiae quasi et ratione vel natus soluta?",
//                               color: Color(0xFF404040),
//                               wrap: true,
//                               align: TextAlign.justify,
//                             ),
//                             SizedBox(
//                               height: 8,
//                             )
//                           ])),
//                 ],
//               )
//             ],
//           ),
//           //icon button back and cart
//           Positioned(
//               left: 4,
//               right: 4,
//               top: 8,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Icon(
//                       Icons.arrow_back_rounded,
//                       size: 28,
//                       color: primaryColor,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       elevation: 7,
//                       primary: white,
//                       shape: CircleBorder(),
//                       padding: EdgeInsets.all(10),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         // DetailPage adalah halaman yang dituju
//                         MaterialPageRoute(builder: (context) => CartPage()),
//                       );
//                     },
//                     child: Icon(
//                       Icons.shopping_cart_rounded,
//                       size: 28,
//                       color: primaryColor,
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       elevation: 7,
//                       primary: white,
//                       shape: CircleBorder(),
//                       padding: EdgeInsets.all(8),
//                     ),
//                   ),
//                 ],
//               ))
//         ],
//       )),
//       // bottomNavigationBar: ,
//     );
//   }
// }
