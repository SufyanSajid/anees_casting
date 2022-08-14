import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  Widget mobileLayout;
  Widget webLayout;
  Widget tabLayout;

  ResponsiveLayout({
    required this.mobileLayout,
    required this.webLayout,
    required this.tabLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) {
        if (constraints.maxWidth < 1100) {
          return tabLayout;
        } else if (constraints.maxWidth < 600) {
          return mobileLayout;
        } else {
          return webLayout;
        }
      }),
    );
  }
}
