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

class Products with ChangeNotifier{
  List<Product> _products = [
    Product(
      id: 16,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 24,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 433,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
        Product(
      id: 123,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 22,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 3323,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
        Product(
      id: 331,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 32,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
       Product(
      id: 33,
      name: 'Ring',
      length: 20.0,
      width: 40.0,
      unit: 'CM',
      image: '',
      category: Category(
        id: 1,
        name: 'Ring',
        type: 'Parent',
      ),
    ),
  ];

  List<Product> get products{
    return [..._products];
  }
}
