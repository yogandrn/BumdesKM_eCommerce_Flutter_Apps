import 'dart:convert';

import 'package:bumdeskm/pages/product/search_product_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bumdeskm/API/api_services.dart';
import 'package:bumdeskm/models/app_banner.dart';
import 'package:bumdeskm/models/product.dart';
import 'package:bumdeskm/models/review.dart';
import 'package:bumdeskm/models/user.dart';
import 'package:bumdeskm/pages/cart/cart_page.dart';
import 'package:bumdeskm/pages/orders/my_order_page.dart';
import 'package:bumdeskm/pages/product/best_seller_page.dart';
import 'package:bumdeskm/pages/product/catalog_page.dart';
import 'package:bumdeskm/pages/product/detail_product_page.dart';
import 'package:bumdeskm/pages/product/product_card.dart';
import 'package:bumdeskm/pages/profile/profile_page.dart';
import 'package:bumdeskm/pages/review/review_ilist_tem.dart';
import 'package:bumdeskm/pages/wishlist/wishlist_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/long_text_widget.dart';
import 'package:bumdeskm/widgets/product_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  int? id;
  var subtotal;
  List<Product> products = [];
  List<User> user = [];
  List<Review> reviews = [];
  String img = "";
  TextEditingController keywordController = TextEditingController();
  var keyword;

  void getID() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = (pref.getInt('id_user') ?? 0);
      // subtotal = CurrencyFormat.convertToIdr(pref.getInt('subtotal'));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getID();
    fetchDataUser();
    fetchDataProduct();
    setState(() {});
    fetchReviews();
  }

  fetchDataProduct() async {
    products.clear();
    try {
      var res = await ApiService().getBestSeller();
      setState(() {
        _isLoading = true;
        products.addAll(res);
        _isLoading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  fetchDataUser() async {
    final response = await ApiService().getUserData();
    var body = json.decode(response.body);

    setState(() {
      img = body['image'];
      // _isLoading = true;
      // _isLoading = false;
    });
  }

  void fetchReviews() async {
    final res = await ApiService().getAllReviews();
    setState(() {
      _isLoading = true;
      reviews.addAll(res);
      _isLoading = false;
    });
  }

  _showMessage(msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<bool> confirmExit() async {
    Widget cancelButton = FlatButton(
      child: SmallText(
        text: "Batal",
        color: grey40,
        size: 13.5,
        weight: FontWeight.w500,
      ),
      // color: Color(0xFFD9D9D9),
      onPressed: () {
        Navigator.of(context).pop(false);
      },
    );
    Widget continueButton = FlatButton(
      child: SmallText(
        text: "Keluar",
        color: Colors.red,
        size: 13.5,
        weight: FontWeight.w500,
      ),
      onPressed: () {
        Navigator.of(context).pop(true);
        // Navigator.of(context).pop(true);
        // Navigator.pop(context);
      },
    );
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: SmallText(
              text: "Ingin Keluar?",
              size: 15,
              weight: FontWeight.w500,
            ),
            content: ProductText(text: "Apakah Anda yakin ingin keluar ?"),
            actions: <Widget>[
              cancelButton,
              continueButton,
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: confirmExit,
      child: Scaffold(
        backgroundColor: white,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              // var response = await ApiService().getUserData();
              // var res = await ApiService().getAllProducts();
              setState(() {
                _isLoading = true;
              });
              getID();
              fetchDataUser();
              fetchDataProduct();
            },
            color: primaryColor,
            child: _isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color.fromARGB(20, 0, 0, 0),
                    child: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: gray,
                        color: primaryColor,
                        strokeWidth: 6,
                      ),
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  EdgeInsets.only(left: 18, right: 18, top: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        // DetailPage adalah halaman yang dituju
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            ApiService().imgURL + "$img"),
                                        radius: 18,
                                      ),
                                    ),
                                  ),
                                  BigText(text: "Beranda"),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          // DetailPage adalah halaman yang dituju
                                          MaterialPageRoute(
                                              builder: (context) => CartPage()),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.shopping_cart_rounded,
                                        size: 32,
                                        color: primaryColor,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            //seacrh bar
                            Container(
                              padding: EdgeInsets.only(
                                left: 18,
                                right: 18,
                              ),
                              child: Form(
                                key: _formKey,
                                child: TextFormField(
                                  autofocus: false,
                                  controller: keywordController,

                                  // onSaved: (newValue) => keyword = newValue!,
                                  // onTap: () {
                                  //   ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(content: Text("Anjay")));
                                  // },
                                  // onEditingComplete: _showMessage("ifgwbi"),
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: grey40,
                                      fontWeight: FontWeight.w400),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        top: 10, bottom: 10, left: 20),
                                    filled: true,
                                    fillColor: Color(0xFFF1f1f1),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: grey81, width: 1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusColor: grey81,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: grey81, width: 1)),
                                    hintText: "Cari",
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.search_rounded),
                                      color: primaryColor,
                                      onPressed: () {
                                        _formKey.currentState!.save();
                                        setState(() {
                                          keyword = keywordController.text;
                                          keywordController.clear();
                                        });
                                        if (keyword == "" || keyword == null) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Ups, kolom pencarian masih kosong!");
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SearchPage(
                                                          keyword: keyword)));
                                        }
                                      },
                                    ),
                                    suffixIconColor: primaryColor,
                                    // prefixIcon: Icon(
                                    //   Icons.search_rounded,
                                    //   color: grey81,
                                    // ),
                                    // prefixIconColor: grey81,
                                    // iconColor: grey81,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                // menu utama
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      //button produk
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CatalogPage()),
                                              );
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/cib_snapcraft.png"),
                                              width: 30,
                                              height: 30,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: primaryLight,
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          BigText(
                                            text: "Produk",
                                            size: 14,
                                            weight: FontWeight.w500,
                                            color: primaryColor,
                                          )
                                        ],
                                      ),
                                      // button keranjang
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CartPage()),
                                              );
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/cib_shopping_cart.png"),
                                              width: 30,
                                              height: 30,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: primaryLight,
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          BigText(
                                            text: "Keranjang",
                                            size: 14,
                                            weight: FontWeight.w500,
                                            color: primaryColor,
                                          )
                                        ],
                                      ),
                                      // button pesanan
                                      Column(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MyOrderPage()),
                                              );
                                            },
                                            child: Image(
                                              image: AssetImage(
                                                  "assets/images/cib_pesanan.png"),
                                              width: 30,
                                              height: 30,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              primary: primaryLight,
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          BigText(
                                            text: "Pesanan",
                                            size: 14,
                                            weight: FontWeight.w500,
                                            color: primaryColor,
                                          )
                                        ],
                                      ),
                                      // button favorit
                                      // Column(
                                      //   children: [
                                      //     ElevatedButton(
                                      //       onPressed: () {
                                      //         Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   WishlistPage()),
                                      //         );
                                      //       },
                                      //       child: Image(
                                      //         image: AssetImage(
                                      //             "assets/images/cib_favorite.png"),
                                      //         width: 30,
                                      //         height: 30,
                                      //       ),
                                      //       style: ElevatedButton.styleFrom(
                                      //         primary: primaryLight,
                                      //         shape: CircleBorder(),
                                      //         padding: EdgeInsets.all(16),
                                      //       ),
                                      //     ),
                                      //     SizedBox(
                                      //       height: 8,
                                      //     ),
                                      //     BigText(
                                      //       text: "Wishlist",
                                      //       size: 14,
                                      //       weight: FontWeight.w500,
                                      //       color: primaryColor,
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                // banner utama
                                Banner1(),
                                // Container(
                                //   width: MediaQuery.of(context).size.width,
                                //   height: 160,
                                //   child: CarouselSlider(
                                //     options: CarouselOptions(
                                //       autoPlay: true,
                                //       autoPlayAnimationDuration:
                                //           Duration(seconds: 1),
                                //       autoPlayCurve: Curves.fastOutSlowIn,
                                //       pauseAutoPlayOnTouch: true,
                                //       enlargeCenterPage: true,
                                //       viewportFraction: 1.0,
                                //     ),
                                //     items: [Banner1(), Banner2()],
                                //   ),
                                // ),
                                SizedBox(
                                  height: 24,
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 18,
                                    right: 18,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      BigText(
                                        text: "Best Seller",
                                        size: 18,
                                      ),
                                      InkWell(
                                        child: SmallText(
                                          text: "Lihat semua",
                                          size: 14,
                                          color: primaryColor,
                                          weight: FontWeight.w500,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BestSellerPage()));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),

                                // Container(
                                //   height: 196,
                                //   child: ListView.builder(
                                //       scrollDirection: Axis.horizontal,
                                //       itemCount: bannerList.length,
                                //       itemBuilder: (context, index) {
                                //         return Container(
                                //           height: 196,
                                //           width: 135,
                                //           margin: EdgeInsets.symmetric(
                                //             horizontal: 6,
                                //           ),
                                //           padding: EdgeInsets.all(5),
                                //           decoration: BoxDecoration(
                                //             border:
                                //                 Border.all(color: primaryColor, width: 2),
                                //             color: white,
                                //             borderRadius: BorderRadius.circular(15),
                                //           ),
                                //           child: Column(
                                //             crossAxisAlignment: CrossAxisAlignment.start,
                                //             children: [
                                //               Container(
                                //                 width: 125,
                                //                 height: 125,
                                //                 decoration: BoxDecoration(
                                //                     borderRadius:
                                //                         BorderRadius.circular(14),
                                //                     image: DecorationImage(
                                //                         image: AssetImage(
                                //                             "assets/images/craft0.png"),
                                //                         fit: BoxFit.cover)),
                                //               ),
                                //               SizedBox(
                                //                 height: 5,
                                //               ),
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     left: 4, right: 4),
                                //                 child: SmallText(
                                //                   text: bannerList[index].name,
                                //                   size: 12,
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 6,
                                //               ),
                                //               Padding(
                                //                 padding: const EdgeInsets.only(
                                //                     left: 4, right: 4),
                                //                 child: BigText(
                                //                   text: "Rp " +
                                //                       bannerList[index].price.toString(),
                                //                   size: 13,
                                //                   color: primaryColor,
                                //                 ),
                                //               ),
                                //               SizedBox(
                                //                 height: 12,
                                //               )
                                //             ],
                                //           ),
                                //         );
                                //       }),
                                // ),

                                Container(
                                  // color: grey81,
                                  height:
                                      // MediaQuery.of(context).size.height / 3.95,
                                      196,
                                  padding: EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: products
                                        .map((product) => BestSellerCard(
                                            product: product, id: product.id))
                                        .toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 24,
                                ),

                                // reviews.length == 0
                                //     ? Container(
                                //         height: 0,
                                //         width: 0,
                                //       )
                                //     : Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Container(
                                //               padding: EdgeInsets.only(
                                //                 left: 18,
                                //                 right: 18,
                                //               ),
                                //               child: BigText(
                                //                   text: "Ulasan Pelanggan")),
                                //           SizedBox(
                                //             height: 8,
                                //           ),
                                //           Container(
                                //             // color: grey81,
                                //             height:
                                //                 // MediaQuery.of(context).size.height / 3.95,
                                //                 160,
                                //             width:
                                //                 MediaQuery.of(context).size.width,
                                //             child: CarouselSlider(
                                //                 options: CarouselOptions(
                                //                   autoPlay: reviews.length == 1
                                //                       ? false
                                //                       : true,
                                //                   autoPlayAnimationDuration:
                                //                       Duration(
                                //                           milliseconds: 1000),
                                //                   autoPlayCurve:
                                //                       Curves.fastOutSlowIn,
                                //                   pauseAutoPlayOnTouch: true,
                                //                   enlargeCenterPage: true,
                                //                   viewportFraction:
                                //                       reviews.length == 1
                                //                           ? 0.9
                                //                           : 0.8,
                                //                 ),
                                //                 items: reviews.map((review) {
                                //                   return Center(
                                //                     child: ReviewItem(
                                //                       review: review,
                                //                       id: review.id,
                                //                     ),
                                //                   );
                                //                 }).toList()),
                                //           ),
                                //           SizedBox(
                                //             height: 32,
                                //           ),
                                //         ],
                                //       ),
                              ],
                            ),
                          ]),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget Banner1() {
    return Container(
      height: 160,
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 18,
        right: 18,
      ),
      padding: EdgeInsets.only(left: 20, top: 24),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [secondaryColor, primaryColor]
              // colors: [Color.fromARGB(255, 22, 148, 133), Color(0xFF191654)],
              ),
          borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          //gambar banner
          Positioned(
              bottom: -5,
              right: 6,
              child: Image(
                image: AssetImage("assets/images/drawkit1.png"),
                height: 130,
              )),
          //text and button
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.2,
                child: ProductText(
                  text: "Temukan apapun yang Anda inginkan...",
                  size: MediaQuery.of(context).size.width / 25,
                  weight: FontWeight.w600,
                  color: white,
                  height: 1.4,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              //button explore
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CatalogPage()));
                },
                child: SmallText(
                  text: "Jelajahi",
                  color: primaryColor,
                  size: 13.8,
                  weight: FontWeight.w500,
                ),
                style: ElevatedButton.styleFrom(
                  primary: white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // <-- Radius
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget Banner2() {
    return Container(
      height: 160,
      width: double.maxFinite,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      padding: EdgeInsets.only(top: 24, right: 15),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF302b63), secondaryColor]),
          borderRadius: BorderRadius.circular(16)),
      // child: Stack(
      //   children: [
      //     //gambar banner
      //     Positioned(
      //         bottom: 15,
      //         left: 8,
      //         child: Image(
      //           image: AssetImage("assets/images/review.png"),
      //           height: 120,
      //         )),
      //     //text and button
      //     Positioned(
      //       right: 0,
      //       top: 18,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           SizedBox(
      //             width: MediaQuery.of(context).size.width / 3,
      //             child: LongText(
      //               text: "Lihat ulasan dari pelanggan kami",
      //               size: 16,
      //               weight: FontWeight.w500,
      //               color: white,
      //               height: 1.0,
      //               align: TextAlign.end,
      //             ),
      //           ),
      //           SizedBox(
      //             height: 12,
      //           ),
      //           //button explore
      //           ElevatedButton(
      //             onPressed: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => CatalogPage()));
      //             },
      //             child: SmallText(
      //               text: "Explore",
      //               color: primaryColor,
      //               size: 14.5,
      //               weight: FontWeight.w500,
      //             ),
      //             style: ElevatedButton.styleFrom(
      //               primary: white,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(12), // <-- Radius
      //               ),
      //               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      //             ),
      //           ),
      //         ],
      //       ),
      //     )
      //   ],
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          Image.asset(
            'assets/images/review.png',
            height: 110,
          ),
          SizedBox(
            width: 4,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 2.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  LongText(
                    text: "Lihat",
                    size: 15,
                    weight: FontWeight.w500,
                    color: white,
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class BestSellerCard extends StatelessWidget {
  Product product;
  int id;
  BestSellerCard({Key? key, required this.product, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width / 2.8,
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        color: white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailProductPage(id: product.id)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 125,
              height: 125,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                    image:
                        NetworkImage(ApiService().imgURL + "${product.image}"),
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: SmallText(
                      text: product.title,
                      size: 12.5,
                      weight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: BigText(
                      // text: "Rp " + product.price.toString(),
                      text: CurrencyFormat.convertToIdr(product.price),
                      size: 13.5,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
