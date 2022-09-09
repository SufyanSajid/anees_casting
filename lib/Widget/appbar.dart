import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../contant.dart';

class Appbar extends StatelessWidget {
  Appbar({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.svgIcon,
    this.leadingIcon,
    this.leadingTap,
    this.tarilingIcon,
    this.tarilingTap,
  }) : super(key: key);

  String title;
  String subtitle;
  String svgIcon;
  IconData? leadingIcon;
  Function()? leadingTap;
  IconData? tarilingIcon;
  Function()? tarilingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: leadingTap,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 5),
                          blurRadius: 5),
                    ]),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  leadingIcon,
                  color: btnbgColor.withOpacity(1),
                ),
              ),
            ),
            SvgPicture.asset(
              svgIcon,
              height: 44,
              color: btnbgColor.withOpacity(1),
            ),
            InkWell(
              onTap: tarilingTap,
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 5),
                          blurRadius: 5),
                    ]),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  tarilingIcon,
                  color: btnbgColor.withOpacity(1),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        Column(
          children: [
            Text(
              title,
              style: GoogleFonts.righteous(
                fontSize: 20,
                color: headingColor,
              ),
            ),
            SizedBox(
              height: height(context) * 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: height(context) * 0.1,
                      color: btnbgColor.withOpacity(1),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Text(
                        subtitle,
                        style: TextStyle(color: contentColor),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: height(context) * 0.1,
                      color: btnbgColor.withOpacity(1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
