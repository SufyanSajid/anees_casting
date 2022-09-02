import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoriesCount with ChangeNotifier {
  int? _categoriesCount;

  int? get getCategoriesCount => _categoriesCount;

  Future<void> fetchtAndUpdateCategoriesCount() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "categories count");

    List<dynamic> resData = jsonDecode(res.body)["documents"];

    Map fields = resData[0]["fields"];
    String count = fields["count"]["stringValue"];
    int cCount = int.parse(count);
    _categoriesCount = cCount;
    notifyListeners();
  }

  Future<void> increaseCategoriesCount() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_categoriesCount! + 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "users count", data: payLoad, prodId: "categoriesCount");

    _categoriesCount = _categoriesCount! + 1;
    notifyListeners();
  }

  Future<void> decreaseCategoriesCount() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_categoriesCount! + 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "users count", data: payLoad, prodId: "categoriesCount");

    _categoriesCount = _categoriesCount! + 1;
    notifyListeners();
  }
}
