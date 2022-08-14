import 'package:anees_costing/Models/product.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../../../Widget/appbar.dart';
import '../../../contant.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            Appbar(
              title: 'Product',
              subtitle: 'List of Products',
              svgIcon: 'assets/icons/daimond.svg',
              leadingIcon: Icons.arrow_back,
              leadingTap: () {
                Navigator.of(context).pop();
              },
              tarilingIcon: Icons.filter_list,
              tarilingTap: () {},
            ),
          ]),
        ),
      ),
    );
  }
}
