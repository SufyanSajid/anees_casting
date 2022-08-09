import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../contant.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({
    Key? key,
    required this.height,
    required this.width,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final double height;
  final double width;
  Function() onTap;
  String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height * 5,
        width: width * 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), gradient: primaryGradient),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
