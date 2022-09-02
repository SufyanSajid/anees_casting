import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductsCount with ChangeNotifier {
  int? _productsCount;

  int? get getProductsCount => _productsCount;

  Future<void> fetchAndGetProductsCount() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "products count");

    List<dynamic> resData = jsonDecode(res.body)["documents"];

    Map fields = resData[0]["fields"];
    String count = fields["count"]["stringValue"];
    int pCount = int.parse(count);
    _productsCount = pCount;
    notifyListeners();
  }

  Future<void> increaseProductsCount() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_productsCount! + 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "products count", data: payLoad, prodId: "productsCount");

    _productsCount = _productsCount! + 1;
    notifyListeners();
  }

  Future<void> decreaseProductsCount() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_productsCount! - 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "products count", data: payLoad, prodId: "productsCount");

    _productsCount = _productsCount! - 1;
    notifyListeners();
  }
}
