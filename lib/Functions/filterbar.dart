import 'package:flutter/material.dart';

import '../Widget/dropDown.dart';
import '../Widget/grad_button.dart';
import '../contant.dart';

Widget buildFilterBar({
  required BuildContext context,
  required TextEditingController searchConttroller,
  required,
  required void Function()? btnTap,
  required String btnText,
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
        SizedBox(
          width: width(context) * 20,
          child: TextField(
            style: TextStyle(color: headingColor),
            controller: searchConttroller,
            decoration: InputDecoration(
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

        Row(
          children: [
            SizedBox(
              width: width(context) * 8,
              child: CustomDropDown(
                onChanged: (value) {
                  print(value);
                },
                items: const [
                  'Asc',
                  'Dec',
                ],
              ),
            ),
            SizedBox(
              width: width(context) * 2,
            ),
            gradientButton(
              onTap: btnTap,
              title: btnText,
            ),
          ],
        ),
      ],
    ),
  );
}
