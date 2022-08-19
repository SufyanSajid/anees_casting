import 'package:anees_costing/Screen/Auth/Login/mobilelogin.dart';
import 'package:anees_costing/Screen/Auth/Login/weblogin.dart';
import 'package:flutter/material.dart';

import '../../../Responsive/responsive.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileLayout: MobileLoginScreen(),
      webLayout: WebLogin(),
    );
  }
}
