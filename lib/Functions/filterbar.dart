import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Widget/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widget/dropDown.dart';
import '../Widget/grad_button.dart';
import '../contant.dart';

Widget buildFilterBar(
    {required BuildContext context,
    required TextEditingController searchConttroller,
    required void Function()? btnTap,
    required String? btnText,
    required Widget? dropDown,
    required Function searchSubmitted}) {
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
            onSubmitted: (val) => searchSubmitted(val),
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
                GradientButton(
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
