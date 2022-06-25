import 'package:flutter/material.dart';
import 'package:bumdeskm/pages/login_page.dart';
import 'package:bumdeskm/utils/colors.dart';
import 'package:bumdeskm/utils/textstyle.dart';
import 'package:bumdeskm/widgets/big_text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        padding: const EdgeInsets.only(left: 32, right: 32),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [primaryColor, secondaryColor],
        )),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 84,
            ),
            Column(
              children: [
                Text("Discover more", style: textHeading),
                SizedBox(
                  height: 2,
                ),
                Image.asset(
                  "assets/images/drawkit2.png",
                  width: 320,
                ),
                Text(
                  "Temukan berbagai produk menarik dengan kemudahan transaksi",
                  style: textSubheading,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.only(
                        top: 22, bottom: 22, left: 24, right: 10),
                    minimumSize: Size(200, 60),
                    textStyle: buttonText18,
                    primary: white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(width: 1, color: white),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BigText(
                        text: 'Get started',
                        color: white,
                        weight: FontWeight.w600,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: white,
                        size: 28,
                      ),
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      // DetailPage adalah halaman yang dituju
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ))
          ],
        ),
      )),
    );
  }
}
