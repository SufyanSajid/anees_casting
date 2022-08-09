import 'dart:convert';

import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  String id;
  String name;
  String categoryId;
  String length;
  String width;
  String unit;
  String image;
  String dateTime;

  Product(
      {required this.id,
      required this.name,
      required this.length,
      required this.width,
      required this.unit,
      required this.categoryId,
      required this.image,
      required this.dateTime});
}

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Future<void> addProduct(
      {required String imgUrl,
      required String prodName,
      required String prodWidth,
      required String unit,
      required String catId,
      required String prodLen}) async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": catId},
        "imageUrl": {"stringValue": imgUrl},
        "productName": {"stringValue": prodName},
        "productWidth": {"stringValue": prodWidth},
        "productUnit": {"stringValue": unit},
        "productLength": {"stringValue": prodLen},
      }
    };
    http.Response res = await FirestoreMethods()
        .createRecord(collection: "products", data: payLoad);
  }

  Future<void> fetchAndUpdateProducts() async {
    List<Product> tempProds = [];
    http.Response prodRes =
        await FirestoreMethods().getRecords(collection: "products");

    List<dynamic> docsData = json.decode(prodRes.body)["documents"];

    docsData.forEach((element) {
      Map fields = element["fields"];
      String catId = fields["catId"]["stringValue"];
      String imageUrl = fields["imageUrl"]["stringValue"];
      String productName = fields["productName"]["stringValue"];
      String productWidth = fields["productWidth"]["stringValue"];
      String productUnit = fields["productUnit"]["stringValue"];
      String productLength = fields["productLength"]["stringValue"];
      String id = (element["name"] as String).split("categories/").last;
      String time = element["updateTime"];
      tempProds.add(Product(
          id: id,
          name: productName,
          length: productLength,
          width: productWidth,
          unit: productUnit,
          categoryId: catId,
          image: imageUrl,
          dateTime: time));
    });
    _products = tempProds;

    notifyListeners();
  }
}

Map a = {
  "name":
      "projects/aneescasting-ec184/databases/(default)/documents/products/IzhOER0vIRiXgTtH9LOl",
  "fields": {
    "productName": {"stringValue": "ggggg"},
    "productUnit": {"stringValue": "CM"},
    "imageUrl": {
      "stringValue":
          "https://firebasestorage.googleapis.com/v0/b/aneescasting-ec184.appspot.com/o/products%2F1660031687012.png?alt=media&token=05e376d6-aadb-4524-b159-eb75710417dd"
    },
    "catId": {"stringValue": "Eb1AccjvlgKTeQCJKeki"},
    "productLength": {"stringValue": "44"},
    "productWidth": {"stringValue": "55"}
  },
  "createTime": "2022-08-09T07:54:48.854670Z",
  "updateTime": "2022-08-09T07:54:48.854670Z"
};
