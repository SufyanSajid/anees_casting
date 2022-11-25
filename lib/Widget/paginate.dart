import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import '../Models/pagination.dart';

import '../contant.dart';

class Paginate extends StatelessWidget {
  Paginate({
    super.key,
    required this.page,
    required this.onTap,
  });
  CustomPage page;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: primaryColor,
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: page.active ? primaryColor : Colors.transparent,
            border: Border.all(
                color: page.url.isEmpty
                    ? Colors.black.withOpacity(0.2)
                    : page.active
                        ? primaryColor
                        : Colors.black,
                width: 0),
            borderRadius: BorderRadius.circular(50)),
        // margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: HtmlWidget(
          page.title,
          textStyle: TextStyle(
              color: page.url.isEmpty
                  ? Colors.black.withOpacity(0.2)
                  : page.active
                      ? Colors.white
                      : Colors.black),
        ),
      ),
    );
  }
}