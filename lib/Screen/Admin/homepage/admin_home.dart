import 'package:anees_costing/Responsive/responsive.dart';
import 'package:anees_costing/Screen/Admin/homepage/tab_home.dart';
import 'package:anees_costing/Screen/Admin/homepage/web_home.dart';
import 'package:flutter/material.dart';
import 'package:anees_costing/Screen/Admin/homepage/mobile.dart';

class AdminHomePage extends StatelessWidget {
  static const routeName = '/adminhome';
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileAdminHomePage(),
        webLayout: WebHome(),
        tabLayout: TabHome());
  }
}
