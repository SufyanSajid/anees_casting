import 'package:anees_costing/Models/category.dart';
import 'package:flutter/material.dart';

class Product {
  int id;
  String name;
  Category category;
  double length;
  double width;
  String unit;
  String image;

  Product({
    required this.id,
    required this.name,
    required this.length,
    required this.width,
    required this.unit,
    required this.category,
    required this.image,
  });
}

class Products with ChangeNotifier {
  final List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }
}
