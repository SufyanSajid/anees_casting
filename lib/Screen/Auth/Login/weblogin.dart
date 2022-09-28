import 'package:anees_costing/Screen/Auth/Login/mobilelogin.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WebLogin extends StatelessWidget {
  const WebLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    print(width);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png'),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    LoginFeilds(),
                  ],
                ),
              ),
            ),
            if (width > 1000)
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/poster.jpeg',
                      fit: BoxFit.cover,
                      height: height(context) * 100,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.8),
                      height: height(context) * 100,
                    ),
                    Center(
                        child: FittedBox(
                      child: Text(
                        'Welcome To Anees Casting',
                        style: GoogleFonts.berkshireSwash(
                            fontSize: 54, color: primaryColor),
                      ),
                    ))
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
