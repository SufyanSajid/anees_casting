import 'package:flutter/material.dart';

class Category {
  int id;
  String name;
  String type;
  Category({required this.id, required this.name, required this.type});
}

class Categories with ChangeNotifier{
  List<Category> _categories = [
    Category(
      id: 1,
      name: 'Ring',
      type: 'Parent',
    ),
     Category(
      id: 12,
      name: 'Daimond',
      type: 'Parent',
    ),
     Category(
      id: 122,
      name: 'Ring',
      type: 'Parent',
    ),
     Category(
      id: 21,
      name: 'Gold',
      type: 'Sub',
    ),
     Category(
      id: 212,
      name: 'Bengales',
      type: 'Sub',
    ),
     Category(
      id: 2212,
      name: 'Neclas',
      type: 'Sub',
    ),
  ];

  List<Category> get categories{
    return [..._categories];
  }
}
