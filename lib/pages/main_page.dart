import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bumdeskm/models/app_banner.dart';
import 'package:bumdeskm/pages/product/catalog_page.dart';
import 'package:bumdeskm/pages/home/home_page.dart';
import 'package:bumdeskm/pages/orders/my_order_page.dart';
import 'package:bumdeskm/pages/profile/profile_page.dart';
import 'package:bumdeskm/pages/wishlist/wishlist_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController pageController = PageController(viewportFraction: 0.8);
  int currentIndex = 0;
  bool isAuth = false;

  List<Widget> pages = [
    HomePage(),
    WishlistPage(),
    MyOrderPage(),
    ProfilePage()
  ];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.black.withOpacity(0.4),
        selectedFontSize: 0,
        unselectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 15,
        items: [
          BottomNavigationBarItem(
              label: "Home",
              icon: Icon(
                Icons.home_rounded,
                size: 30,
              )),
          BottomNavigationBarItem(
              label: "Wishlist",
              icon: Icon(
                Icons.favorite_rounded,
                size: 30,
              )),
          // BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search)),
          BottomNavigationBarItem(
              label: "Order",
              icon: Icon(
                Icons.receipt_long_rounded,
                size: 30,
              )),
          BottomNavigationBarItem(
              label: "Me",
              icon: Icon(
                Icons.person,
                size: 30,
              )),
        ],
      ),
      // bottomNavigationBar: Container(
      //   height: 60,
      //   width: MediaQuery.of(context).size.width,
      //   padding: EdgeInsets.symmetric(horizontal: 12),
      //   decoration: BoxDecoration(color: white, boxShadow: [
      //     BoxShadow(color: grey81, offset: Offset(0, 6), blurRadius: 12)
      //   ]),
      //   child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      //     IconButton(
      //         onPressed: () {},
      //         icon: Icon(
      //           Icons.home_rounded,
      //           size: 30,
      //         )),
      //     IconButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             // DetailPage adalah halaman yang dituju
      //             MaterialPageRoute(builder: (context) => WishlistPage()),
      //           );
      //         },
      //         icon: Icon(
      //           Icons.favorite_rounded,
      //           size: 30,
      //         )),
      //     IconButton(
      //         onPressed: () {},
      //         icon: Icon(
      //           Icons.person,
      //           size: 30,
      //         )),
      //     // IconBottomBar(
      //     //     icon: Icons.home_rounded, selected: true, onPressed: () {}),
      //     // IconBottomBar(
      //     //     icon: Icons.favorite_rounded, selected: false, onPressed: () {}),
      //     // IconBottomBar(icon: Icons.person, selected: false, onPressed: () {}),
      //   ]),
      // ),
    );
  }

  Widget customBottom() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10),
      ),
      child: BottomAppBar(
        child: BottomNavigationBar(
          backgroundColor: Colors.blue,
          selectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (value) {
            // print(value);
            setState(
              () {
                currentIndex = value;
              },
            );
          },
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}

Widget bannerItem(int position) {
  return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(horizontal: 12),
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            height: 50,
            width: double.maxFinite,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/craft0.png"))),
          ),
          SizedBox(
            height: 12,
          ),
          SmallText(text: bannerList[position].name),
          SizedBox(
            height: 12,
          ),
          SmallText(text: "Rp " + bannerList[position].price.toString()),
        ],
      ));
}
