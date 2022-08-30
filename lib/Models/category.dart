import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Helpers/firestore_methods.dart';

class Category {
  String id;
  String title;
  String parentTitle;
  String parentId;
  Category({
    required this.id,
    required this.parentId,
    required this.title,
    required this.parentTitle,
  });
}

class Categories with ChangeNotifier {
  Category? drawerCategory;

  void setCatgeory(Category cat) {
    drawerCategory = cat;
  }

  List<Category> _categories = [];
  List<Category> _parentCategories = [];
  List<Category> _childCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Category> get parentCategories {
    return [..._parentCategories];
  }

  List<Category> get childCategories {
    return [..._childCategories];
  }

  Future<void> uploadCatagory(
      {required String parentId,
      required String title,
      required String parentTitle}) async {
    var payLoad = {
      "fields": {
        "title": {"stringValue": title},
        "parentId": {"stringValue": parentId},
        "parentTitle": {"stringValue": parentTitle},
      }
    };
    var catRes = await FirestoreMethods()
        .createRecord(collection: "categories", data: payLoad);
  }

  Future<void> fetchAndUpdateCat() async {
    List<Category> tempCat = [];
    List<Category> tempParentCat = [];
    List<Category> tempChildCat = [];

    FirestoreMethods methods = FirestoreMethods();
    http.Response catRes = await methods.getRecords(collection: "categories");

    List<dynamic> docsData = json.decode(catRes.body)["documents"];
    for (var element in docsData) {
      Map fields = element["fields"];
      String parentId = fields["parentId"]["stringValue"];
      String title = fields["title"]["stringValue"];
      String parentTitle = fields["parentTitle"]["stringValue"];
      String id = (element["name"] as String).split("categories/").last;
      tempCat.add(
        Category(
            id: id, parentId: parentId, title: title, parentTitle: parentTitle),
      );
    }

    for (var cat in tempCat) {
      cat.parentId.isEmpty ? tempParentCat.add(cat) : tempChildCat.add(cat);
    }

    _categories = tempCat;
    _parentCategories = tempParentCat;
    _childCategories = tempChildCat;
    notifyListeners();
  }

  // Add new items in categories list

  bool isCatExist({required String title, required String parentTitle}) {
    bool catExist = false;

    for (var element in _categories) {
      if (element.title == title && element.parentTitle == parentTitle) {
        catExist = true;
        break;
      }
    }

    return catExist;
  }
}
