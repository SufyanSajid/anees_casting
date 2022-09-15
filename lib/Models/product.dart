import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Helpers/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../contant.dart';

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
  List<String>? customers;

  Product(
      {required this.id,
      required this.name,
      required this.length,
      required this.width,
      required this.unit,
      required this.categoryId,
      required this.categoryTitle,
      required this.image,
      this.customers,
      required this.dateTime});
}

class Products with ChangeNotifier {
  List<Product> _products = [];
  Product? drawerProduct;
  String? pageToken;

  void setProduct(Product prod) {
    drawerProduct = prod;
  }

  List<Product> get products {
    return [..._products];
  }

  Future<void> addProduct(
      {required Product product,
      required userToken,
      required String imageExtension}) async {
    print(product.image);
    print(imageExtension);
    final url = Uri.parse('${baseUrl}products');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'name': product.name,
      'image': product.image,
      'length': product.length,
      'width': product.width,
      'unit': product.unit,
      'ext': imageExtension,
    });
    print(response.body);
  }

  void addCustomer(String cusId, String prodId) {
    var prod = _products.firstWhere((element) => element.id == prodId);
    prod.customers!.add(cusId);

    notifyListeners();
  }

  void removeCustomer(String cusId, String prodId) {
    List<Product> prods =
        _products.where((element) => element.id == prodId).toList();
    if (prods.isNotEmpty) {
      var prod = _products.firstWhere((element) => element.id == prodId);
      prod.customers!.remove(cusId);
    }
    notifyListeners();
  }

  Product getProdById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndUpdateProducts() async {
    List<Product> tempProds = [];
    http.Response prodRes = await FirestoreMethods()
        .getRecords(collection: "products", pageToken: pageToken);

    var data = json.decode(prodRes.body);
    List<dynamic> docsData = data["documents"];
    if (docsData.isEmpty && docsData == null) {
      return;
    }
    for (var element in docsData) {
      List<String> customers = [];
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

      if (fields['customers'] != null) {
        // print(fields['customers']);
        if (fields['customers']['arrayValue']['values'] != null) {
          var values = fields['customers']['arrayValue']['values'];
          for (var customer in values) {
            customers.add(customer['stringValue']);
          }
        }
      }

      tempProds.add(Product(
          id: id,
          name: productName,
          length: productLength,
          width: productWidth,
          unit: productUnit,
          categoryId: catId,
          categoryTitle: catTitle,
          customers: customers,
          image: imageUrl,
          dateTime: time));
    }
    if (pageToken != null) {
      _products.addAll(tempProds);
    } else {
      _products = tempProds;
    }

    if (data['nextPageToken'] != null) {
      pageToken = data['nextPageToken'];
    } else {
      pageToken = null;
    }

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
    List<Product> customerProducts = [];
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

  // Future<bool> _isProductExist(
  //     {required String title, required String field}) async {
  //   http.Response prodRes =
  //       await FirestoreMethods().searchProduct(title, field);

  //   List<dynamic> docsData = json.decode(prodRes.body);

  //   for (var element in docsData) {
  //     if (element['document'] == null) {
  //       return false;
  //     }
  //   }
  //   return true;
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

  Future<List<Product>> getCustomerProducts(String userId) async {
    List<Product> tempProds = [];
    http.Response prodRes =
        await FirestoreMethods().getCustomerProducts(userId);

    List<dynamic> docsData = json.decode(prodRes.body);
    print(docsData);

    for (var element in docsData) {
      if (element['document'] == null) {
        continue;
      }
      List<String> customers = [];
      var document = element['document'];
      Map fields = document["fields"];
      String catId = fields["catId"]["stringValue"];
      String catTitle = fields["catTitle"]["stringValue"];
      String imageUrl = fields["imageUrl"]["stringValue"];
      String productName = fields["productName"]["stringValue"];
      String productWidth = fields["productWidth"]["stringValue"];
      String productUnit = fields["productUnit"]["stringValue"];
      String productLength = fields["productLength"]["stringValue"];
      String id = (document["name"] as String).split("products/").last;
      String time = document["updateTime"];
      if (fields['customers'] != null) {
        // print(fields['customers']);
        if (fields['customers']['arrayValue']['values'] != null) {
          var values = fields['customers']['arrayValue']['values'];
          for (var customer in values) {
            customers.add(customer['stringValue']);
          }
        }
      }

      tempProds.add(Product(
          id: id,
          name: productName,
          length: productLength,
          width: productWidth,
          unit: productUnit,
          categoryId: catId,
          customers: customers,
          categoryTitle: catTitle,
          image: imageUrl,
          dateTime: time));
    }

    return tempProds;

    // print(documents.toString());
  }
}
