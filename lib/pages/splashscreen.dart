import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bumdeskm/pages/home/home_page.dart';
import 'package:bumdeskm/pages/login_page.dart';
import 'package:bumdeskm/pages/main_page.dart';
import 'package:bumdeskm/pages/welcome_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/widgets/big_text.dart';
import 'package:bumdeskm/widgets/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAuth = false;
  _splashScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var id = prefs.getInt('id_user');
    if (token != null && id != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
    } else {
      setState(() {
        isAuth = false;
      });
    }
    var duration = const Duration(seconds: 1);
    return Timer(duration, () {
      if (isAuth) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WelcomePage()));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _splashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: MediaQuery.of(context).size.width / 3,
        ),
      ),

      // Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     SizedBox(
      //       height: 5,
      //     ),
      //     SmallText(
      //       text: "BumdesApp",
      //       size: 16,
      //       weight: FontWeight.w500,
      //       color: grey40,
      //     ),
      //   ],
      // ),
    );
  }
}
