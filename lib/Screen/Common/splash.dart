import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Auth/Login/login.dart';
import 'package:anees_costing/Screen/Customer/customer_home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/auth.dart';
import '../../contant.dart';
import '../Admin/homepage/admin_home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isFirst = true;
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      Provider.of<Language>(context, listen: false).defaultLang();
      await Future.delayed(const Duration(seconds: 2)).then(
        (value) async {
          bool isLogin =
              await Provider.of<Auth>(context, listen: false).tryAutoLogin();
          if (isLogin) {}

          currentUser = Provider.of<Auth>(context, listen: false).currentUser;

          if (isLogin && currentUser!.role!.toLowerCase() == 'customer') {
            Navigator.of(context)
                .pushReplacementNamed(CustomerHomeScreen.routeName);
          } else if (isLogin && currentUser!.role!.toLowerCase() == 'seller') {
            Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
          } else if (isLogin && currentUser!.role!.toLowerCase() == 'admin') {
            Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
          } else {
            Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
          }
          isFirst = false;
        },
      );
    }

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Text(
          'Anees Casting',
          textAlign: TextAlign.center,
          style: GoogleFonts.berkshireSwash(
            fontSize: 60,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
