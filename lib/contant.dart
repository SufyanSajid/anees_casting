import 'package:flutter/material.dart';

String APIkey = 'AIzaSyBYhlmeIwLt0sdLzbvdUxU5JWFB-pgoa_Y';

LinearGradient gradientBase(List<Color> colorList) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    // stops: [0.05, 0.35, 0.50, 0.60, 0.80],
    colors: colorList,
  );
}

var primaryGradient = gradientBase([
  Color.fromRGBO(197, 154, 120, 1),
  Color.fromRGBO(141, 90, 49, 1),
]);

var primaryColor = Color.fromRGBO(150, 105, 34, 1);
var btnbgColor = Color.fromRGBO(213, 178, 79, 0.17);
var secondaryColor = Colors.blueGrey;
var backgroundColor = Color.fromRGBO(245, 245, 245, 1);
var headingColor = Color.fromRGBO(137, 123, 115, 1);
var contentColor = Color.fromRGBO(176, 176, 176, 1);

height(context) => MediaQuery.of(context).size.height / 100;
width(context) => MediaQuery.of(context).size.width / 100;

var mainGradient = const LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color.fromRGBO(213, 178, 79, 1), Color.fromARGB(0, 148, 103, 31)]);

//shadow
List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.grey.withOpacity(
      0.5,
    ),
    offset: Offset(0, 5),
    blurRadius: 20,
    spreadRadius: 1,
  ),
];
BorderRadius customRadius = BorderRadius.circular(10);

var customGradient = const LinearGradient(colors: [
  Color.fromRGBO(213, 178, 79, 1),
  Color.fromRGBO(150, 105, 34, 1),
], end: Alignment.bottomCenter, begin: Alignment.topCenter);
