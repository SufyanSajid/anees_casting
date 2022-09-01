import 'package:flutter/material.dart';

import '../contant.dart';

class GradientButton extends StatelessWidget {
  GradientButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);
  void Function()? onTap;
  String title;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: customGradient),
      child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            maximumSize: Size(170, 50),
            minimumSize: Size(120, 50),
          ),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }
}
