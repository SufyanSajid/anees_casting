import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Helpers/show_snackbar.dart';
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

  Future<void> addProduct(
      {required Product product, required BuildContext context}) async {
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

    bool isProductExist =
        await _isProductExist(title: product.name, field: "productName");

    if (isProductExist) {
      showSnackBar(context, "Product Already exist");
    }
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

  Future<void> getPaginationProducts() async {
    http.Response res =
        await FirestoreMethods().getChunkRecords(collection: "products");
    print(jsonDecode(res.body)["nextPageToken"]);
    print(res.body);
  }

  Future<void> searchProduct(String title, String field) async {
    List<Product> tempProds = [];
    http.Response prodRes =
        await FirestoreMethods().searchProduct(title, field);

    List<dynamic> docsData = json.decode(prodRes.body);

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

  Future<bool> _isProductExist(
      {required String title, required String field}) async {
    http.Response prodRes =
        await FirestoreMethods().searchProduct(title, field);

    List<dynamic> docsData = json.decode(prodRes.body);

    for (var element in docsData) {
      if (element['document'] == null) {
        return false;
      }
    }
    return true;
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

  Future<void> sendProductToUser(
      {required Product product, required String userId}) async {
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
        .createRecord(collection: "sentproductsrecord/", data: payLoad);
  }
}
