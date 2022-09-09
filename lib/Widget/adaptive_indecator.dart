import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveIndecator extends StatelessWidget {
  Color color;

  AdaptiveIndecator({this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var height = mediaQuery.height / 100;
    var width = mediaQuery.width / 100;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Center(
      child: SizedBox(
        height: height * 2,
        width: height * 2,
        child: CircularProgressIndicator(
          color: color,
        ),
      ),
    );
  }
}
