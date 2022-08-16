import 'package:anees_costing/Screen/Admin/Product/components/formfeilds.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WebDrawer extends StatelessWidget {
  WebDrawer({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      width: width(context) * 35,
      color: Colors.white,
      child: Column(
        children: [
          if (selectedIndex == 1)
            DrawerAppbar(
              title: 'Design',
              subTitle: 'Add New Design',
              svgIcon: 'assets/icons/daimond.svg',
            ),
          if (selectedIndex == 3)
            DrawerAppbar(
              title: 'Category',
              subTitle: 'Add New Category',
              svgIcon: 'assets/icons/category.svg',
            ),
          SizedBox(
            height: height(context) * 5,
          ),

          //Feilds Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: AddProductFeilds(),
          ),
          //Feilds Area End
        ],
      ),
    );
  }
}

class DrawerAppbar extends StatelessWidget {
  DrawerAppbar({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.svgIcon,
  }) : super(key: key);

  String svgIcon;
  String title;
  String subTitle;

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
                  color: Color.fromRGBO(197, 154, 120, 1),
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
