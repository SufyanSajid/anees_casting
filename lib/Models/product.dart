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
  String? pageToken;

  void setProduct(Product prod) {
    drawerProduct = prod;
  }

  List<Product> get products {
    return [..._products];
  }

  Future<void> addProduct({
    required Product product,
    required userToken,
    required String imageExtension,
  }) async {
    try {
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
        'category_id': product.categoryId,
      });
      var extractedData = json.decode(response.body);
      if (extractedData['success'] == true) {
        print(extractedData['message']);
      } else {
        var message = extractedData['message'];
        throw message;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product getProdById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndUpdateProducts(String userToken) async {
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}products');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    print(response.body);
    var extractedData = json.decode(response.body);

    if (extractedData['success'] == true) {
      var data = extractedData['data'] as List<dynamic>;
      data.forEach((prod) {
        tempProds.add(
          Product(
            id: prod['id'].toString(),
            name: prod['name'],
            length: prod['length'],
            width: prod['width'],
            unit: prod['unit'],
            categoryId: prod['category_id'].toString(),
            categoryTitle: prod['category_name'],
            image: prod['imageUrl'],
            dateTime: prod['created_at'],
          ),
        );
      });
      _products = tempProds;
      notifyListeners();
    } else {
      var message = extractedData['message'];
      throw message;
    }

    //  tempProds.add(
    //     Product(
    //         id: id,
    //         name: productName,
    //         length: productLength,
    //         width: productWidth,
    //         unit: productUnit,
    //         categoryId: catId,
    //         categoryTitle: catTitle,
    //         customers: customers,
    //         image: imageUrl,
    //         dateTime: time),
    //   );
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

  // Future<List<Product>> getCustomerProducts(String userId) async {
  //   List<Product> tempProds = [];
  //   http.Response prodRes =
  //       await FirestoreMethods().getCustomerProducts(userId);

  //   List<dynamic> docsData = json.decode(prodRes.body);
  //   print(docsData);

  //   for (var element in docsData) {
  //     if (element['document'] == null) {
  //       continue;
  //     }
  //     List<String> customers = [];
  //     var document = element['document'];
  //     Map fields = document["fields"];
  //     String catId = fields["catId"]["stringValue"];
  //     String catTitle = fields["catTitle"]["stringValue"];
  //     String imageUrl = fields["imageUrl"]["stringValue"];
  //     String productName = fields["productName"]["stringValue"];
  //     String productWidth = fields["productWidth"]["stringValue"];
  //     String productUnit = fields["productUnit"]["stringValue"];
  //     String productLength = fields["productLength"]["stringValue"];
  //     String id = (document["name"] as String).split("products/").last;
  //     String time = document["updateTime"];
  //     if (fields['customers'] != null) {
  //       // print(fields['customers']);
  //       if (fields['customers']['arrayValue']['values'] != null) {
  //         var values = fields['customers']['arrayValue']['values'];
  //         for (var customer in values) {
  //           customers.add(customer['stringValue']);
  //         }
  //       }
  //     }

  //     tempProds.add(Product(
  //         id: id,
  //         name: productName,
  //         length: productLength,
  //         width: productWidth,
  //         unit: productUnit,
  //         categoryId: catId,
  //         categoryTitle: catTitle,
  //         image: imageUrl,
  //         dateTime: time));
  //   }

  //   return tempProds;

  //   // print(documents.toString());
  // }
}
