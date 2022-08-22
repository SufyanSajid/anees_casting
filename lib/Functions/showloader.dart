import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

Future<void> showLoaderDialog(context, String text) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: btnbgColor.withOpacity(0.8),
          content: Row(
            children: [
              CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 4,
              ),
              const SizedBox(width: 15),
              Text(
                text,
              )
            ],
          ));
    },
  );
}
