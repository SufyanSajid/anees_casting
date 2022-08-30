import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
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
  String categoryTitle;

  Product(
      {required this.id,
      required this.name,
      required this.length,
      required this.width,
      required this.unit,
      required this.categoryId,
      required this.categoryTitle,
      required this.image,
      required this.dateTime});
}

class Products with ChangeNotifier {
  List<Product> _products = [];
  Product? drawerProduct;

  void setProduct(Product prod) {
    drawerProduct = prod;
  }

  List<Product> get products {
    return [..._products];
  }

  Future<void> addProduct({required Product product}) async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": product.categoryId},
        "catTitle": {"stringValue": product.categoryTitle},
        "imageUrl": {"stringValue": product.image},
        "productName": {"stringValue": product.name},
        "productWidth": {"stringValue": product.width},
        "productUnit": {"stringValue": product.unit},
        "productLength": {"stringValue": product.length},
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

    for (var element in docsData) {
      Map fields = element["fields"];
      String catId = fields["catId"]["stringValue"];
      String catTitle = fields["catTitle"]["stringValue"];
      String imageUrl = fields["imageUrl"]["stringValue"];
      String productName = fields["productName"]["stringValue"];
      String productWidth = fields["productWidth"]["stringValue"];
      String productUnit = fields["productUnit"]["stringValue"];
      String productLength = fields["productLength"]["stringValue"];
      String id = (element["name"] as String).split("products/").last;
      String time = element["updateTime"];

      tempProds.add(Product(
          id: id,
          name: productName,
          length: productLength,
          width: productWidth,
          unit: productUnit,
          categoryId: catId,
          categoryTitle: catTitle,
          image: imageUrl,
          dateTime: time));
    }

    _products = tempProds;

    notifyListeners();
  }

  Future<void> searchProduct(String title) async {
    List<Product> tempProds = [];
    String prodRes = await FirestoreMethods().searchProduct(title);

    List<dynamic> docsData = json.decode(prodRes);

    print(docsData);

    for (var element in docsData) {
      if (element['document'] == null) {
        break;
      }

      Map fields = element['document']["fields"];
      String catId = fields["catId"]["stringValue"];
      String catTitle = fields["catTitle"]["stringValue"];
      String imageUrl = fields["imageUrl"]["stringValue"];
      String productName = fields["productName"]["stringValue"];
      String productWidth = fields["productWidth"]["stringValue"];
      String productUnit = fields["productUnit"]["stringValue"];
      String productLength = fields["productLength"]["stringValue"];
      String id =
          (element['document']["name"] as String).split("products/").last;
      String time = element['document']["updateTime"];

      tempProds.add(Product(
          id: id,
          name: productName,
          length: productLength,
          width: productWidth,
          unit: productUnit,
          categoryId: catId,
          categoryTitle: catTitle,
          image: imageUrl,
          dateTime: time));
    }

    _products = tempProds;

    notifyListeners();
  }

  // Future<void> updatProduct(
  //     {required String imgUrl,
  //     required String prodName,
  //     required String prodWidth,
  //     required String unit,
  //     required String catId,
  //     required String prodLen,
  //     required String prodId,
  //     required var file}) async {
  //   // StorageMethods().updateImage(imgUrl: imgUrl, file: file);
  //   var payLoad = {
  //     "fields": {
  //       "catId": {"stringValue": catId},
  //       "imageUrl": {"stringValue": imgUrl},
  //       "productName": {"stringValue": prodName},
  //       "productWidth": {"stringValue": prodWidth},
  //       "productUnit": {"stringValue": unit},
  //       "productLength": {"stringValue": prodLen},
  //     }
  //   };
  //   http.Response res = await FirestoreMethods()
  //       .updateRecords(collection: "products", data: payLoad, prodId: prodId);
  // }

  Future<void> deleteProduct(String prodId) async {
    http.Response res = await FirestoreMethods()
        .deleteRecord(collection: "products", prodId: prodId);
  }

  Future<void> updateProduct({required Product product}) async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": product.categoryId},
        "catTitle": {"stringValue": product.categoryTitle},
        "imageUrl": {"stringValue": product.image},
        "productName": {"stringValue": product.name},
        "productWidth": {"stringValue": product.width},
        "productUnit": {"stringValue": product.unit},
        "productLength": {"stringValue": product.length},
      }
    };
    http.Response res = await FirestoreMethods().updateRecords(
        collection: "products", data: payLoad, prodId: product.id);
  }
}
