import 'package:anees_costing/Widget/dropdown.dart';
import 'package:flutter/material.dart';

import '../Widget/dropDown.dart';
import '../Widget/grad_button.dart';
import '../contant.dart';

Widget buildFilterBar({
  required BuildContext context,
  required TextEditingController searchConttroller,
  required,
  required void Function()? btnTap,
  required String? btnText,
  required Widget? dropDown,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: shadow,
      borderRadius: customRadius,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //search box
        Expanded(
          flex: 2,
          child: TextField(
            style: TextStyle(color: headingColor),
            controller: searchConttroller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              hintText: 'Search Here',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey.withOpacity(1),
                ),
              ),
            ),
          ),
        ),
        //search box

        Expanded(
          flex: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (dropDown != null) dropDown,
              SizedBox(
                width: width(context) * 2,
              ),
              if (btnTap != null && btnText != null)
                gradientButton(
                  onTap: btnTap,
                  title: btnText,
                ),
            ],
          ),
        ),
      ],
    ),
  );
}
