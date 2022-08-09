import 'dart:convert';

import 'package:anees_costing/Models/storage_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'firestore_methods.dart';

class Category {
  String id;
  String title;
  String parentId;
  Category({
    required this.id,
    required this.parentId,
    required this.title,
  });
}

class Categories with ChangeNotifier {
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

  Future<void> uploadCatagory(String parentId, String title) async {
    var payLoad = {
      "fields": {
        "title": {"stringValue": title},
        "parentId": {"stringValue": parentId}
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
    http.Response catRes =
        await methods.getRecords(collection: "categories/?pageSize=100");
    List<dynamic> docsData = json.decode(catRes.body)["documents"];

    docsData.forEach((element) {
      Map fields = element["fields"];
      String parentId = fields["parentId"]["stringValue"];
      String title = fields["title"]["stringValue"];
      String id = (element["name"] as String).split("categories/").last;
      tempCat.add(Category(id: id, parentId: parentId, title: title));
    });

    for (var cat in tempCat) {
      cat.parentId.isEmpty ? tempParentCat.add(cat) : tempChildCat.add(cat);
    }

    _categories = tempCat;
    _parentCategories = tempParentCat;
    _childCategories = tempChildCat;
    notifyListeners();
  }

  Future<void> deleteCat() async {
    String res = await StorageMethods().deleteImage();
    print(res);
  }
}
