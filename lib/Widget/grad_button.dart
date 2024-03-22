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
            backgroundColor: Colors.transparent,
            maximumSize: Size(150, 50),
            minimumSize: Size(150, 50),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: width(context) * 100 > 900 ? 12 : 12),
          ),),
    );
  }
}
