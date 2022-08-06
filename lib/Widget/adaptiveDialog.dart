import 'dart:io';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../contant.dart';


class AdaptiveDiaglog extends StatelessWidget {
  BuildContext ctx;
  String? content;
  String title;
  String btnYes;
  String btnNO;
  Function yesPressed;
  Function? noPressed;

  AdaptiveDiaglog({
    required this.ctx,
    this.content = '',
    required this.title,
    required this.btnYes,
    this.btnNO = '',
    required this.yesPressed,
    this.noPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoAlertDialog(
            title: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Text(content!),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  btnYes,
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: yesPressed as Function()?,
              ),
              if (btnNO != '')
                CupertinoDialogAction(
                  child: Text(
                    btnNO,
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: noPressed as Function()?,
                ),
            ],
          )
        : AlertDialog(
            title: Center(
              child: Text(title,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 22,
                  )),
            ),
            content: Text(
              content!,
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
            actions: [
              TextButton(
                child: Text(
                  btnYes,
                  style: TextStyle(color: primaryColor),
                ),
                onPressed: yesPressed as Function()?,
              ),
              if (btnNO != '')
                TextButton(
                  child: Text(
                    btnNO,
                    style: TextStyle(color: primaryColor),
                  ),
                  onPressed: noPressed as Function()?,
                ),
            ],
          );
  }
}
