import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
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
    required Widget? CustomWidget,
    required Function searchSubmitted}) {
  var currentUser = Provider.of<Auth>(context).currentUser;
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
    decoration: BoxDecoration(
      border: Border.all(color: btnbgColor.withOpacity(0.6), width: 1),
      color: Colors.white,
      boxShadow: shadow,
      borderRadius: customRadius,
    ),
    child: LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //search box

            Expanded(
              flex: width(context) * 100 > 900 ? 2 : 4,
              child: TextField(
                style: TextStyle(color: headingColor),
                controller: searchConttroller,
                onSubmitted: (val) => searchSubmitted(val),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                  hintText: Provider.of<Language>(context, listen: true)
                      .get('Search Here'),
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
              flex: width(context) * 100 > 900 ? 8 : 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //   if (dropDown != null) dropDown,
                  // SizedBox(
                  //   width: width(context) * 2,
                  // ),
                  CustomWidget!,
                  SizedBox(
                    width: width(context) * 2,
                  ),
                  if (currentUser!.role!.toLowerCase() == 'admin')
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
    }),
  );
}
