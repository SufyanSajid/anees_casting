import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Screen/Admin/Product/components/add_product_field.dart';
import 'package:anees_costing/Screen/Admin/users/add_user.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/category.dart';
import '../../Screen/Admin/category/components/AddCategoryFeild.dart';
import '../customautocomplete.dart';
import '../input_feild.dart';
import '../submitbutton.dart';

class WebDrawer extends StatelessWidget {
  const WebDrawer({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  final int selectedIndex;

  bool isCategoryEmpty(BuildContext context) {
    var category =
        Provider.of<Categories>(context, listen: false).drawerCategory;
    if (category == null) {
      return true;
    } else {
      return false;
    }
  }

  bool isProductEmpty(BuildContext context) {
    var prod = Provider.of<Products>(context, listen: false).drawerProduct;
    if (prod == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      width: width(context) * 35,
      color: Colors.white,
      child: SizedBox(
        height: height(context) * 100,
        child: Column(
          children: [
            if (selectedIndex == 1)
              DrawerAppbar(
                title: 'Design',
                subTitle:
                    isProductEmpty(context) ? 'Add New Design' : 'Edit Design',
                svgIcon: 'assets/icons/daimond.svg',
              ),
            if (selectedIndex == 3)
              DrawerAppbar(
                title: 'Category',
                subTitle: isCategoryEmpty(context)
                    ? 'Add New Category'
                    : 'Edit Category',
                svgIcon: 'assets/icons/category.svg',
              ),
            if (selectedIndex == 2)
              const DrawerAppbar(
                title: 'Users',
                subTitle: 'Add New Users',
                svgIcon: 'assets/icons/profile.svg',
              ),
            SizedBox(
              height: height(context) * 5,
            ),

            //Feilds Area
            if (selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AddProductFeilds(),
              ),
            if (selectedIndex == 2)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: AddUserFeilds(),
              ),
            if (selectedIndex == 3)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: AddCategoryFeilds(),
              ),

            //Feilds Area End
          ],
        ),
      ),
    );
  }
}

class DrawerAppbar extends StatelessWidget {
  const DrawerAppbar({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.svgIcon,
  }) : super(key: key);

  final String svgIcon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgIcon,
          height: 50,
          color: primaryColor,
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        Text(
          title,
          style: GoogleFonts.righteous(
            fontSize: 20,
            color: headingColor,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: height(context) * 0.1,
                  color: const Color.fromRGBO(197, 154, 120, 1),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    subTitle,
                    style: TextStyle(color: contentColor),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: height(context) * 0.1,
                  color: Color.fromRGBO(197, 154, 120, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
