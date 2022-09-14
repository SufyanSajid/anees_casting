import 'dart:io';

import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../Widget/appbar.dart';
import '../../../contant.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  ProductDetailScreen({Key? key}) : super(key: key);
  Product? product;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    product = ModalRoute.of(context)!.settings.arguments as Product;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final imageUrl = Uri.parse(product!.image);
          final response = await http.get(imageUrl);
          final bytes = response.bodyBytes;

          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';
          File(path).writeAsBytesSync(bytes);
          await Share.shareFiles([path]);
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.share),
      ),
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(children: [
            Appbar(
              title: 'Product',
              subtitle: product!.name,
              svgIcon: 'assets/icons/daimond.svg',
              leadingIcon: Icons.arrow_back,
              leadingTap: () {
                Navigator.of(context).pop();
              },
              tarilingIcon: Icons.filter_list,
              tarilingTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            SizedBox(
              height: height(context) * 2,
            ),
            Container(
              height: height(context) * 50,
              child: InteractiveViewer(
                clipBehavior: Clip.none,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: ExtendedImage.network(
                      product!.image,
                      cache: true,
                    )),
              ),
            ),
            SizedBox(
              height: height(context) * 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RowItem(
                  svgIcon: 'assets/icons/category.svg',
                  value: product!.categoryTitle.toUpperCase(),
                ),
                RowItem(
                  svgIcon: 'assets/icons/weight.svg',
                  value: '${product!.unit}',
                ),
                RowItem(
                  svgIcon: 'assets/icons/arrow2.svg',
                  value: '${product!.length} * ${product!.width}',
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  RowItem({
    Key? key,
    required this.svgIcon,
    required this.value,
  }) : super(key: key);

  String svgIcon;
  String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 9,
      color: const Color.fromRGBO(242, 240, 240, 1),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            svgIcon,
            height: height(context) * 5,
            color: btnbgColor.withOpacity(1),
          ),
          // SizedBox(
          //   height: height(context) * 0.8,
          // ),
          Text(
            value,
            style: TextStyle(color: primaryColor),
          )
        ],
      ),
    );
  }
}
