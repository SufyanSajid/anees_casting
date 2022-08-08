import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Category {
  String id;
  String title;
  String parentId;
  Category({
    required this.id,
    required this.parentId,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'parentId': parentId});

    return result;
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      parentId: map['parentId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}

class Categories with ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  uploadCatagory(String parentId, String title) async {
    try {
      await db
          .collection("categories")
          .add({"title": title, "parentId": parentId});
    } catch (e) {
      print('sufyan');
    }
  }
}
