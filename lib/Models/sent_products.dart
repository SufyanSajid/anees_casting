import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class SentProduct {
  String id;
  String userId;
  String prodId;
  String prodName;
  String prodCategoryId;
  String prodLength;
  String prodWidth;
  String prodUnit;
  String prodImage;
  String prodCategoryTitle;

  SentProduct(
      {required this.id,
      required this.prodCategoryId,
      required this.userId,
      required this.prodCategoryTitle,
      required this.prodId,
      required this.prodImage,
      required this.prodLength,
      required this.prodName,
      required this.prodUnit,
      required this.prodWidth});
}

class SentProducts with ChangeNotifier {
  // List<SentProduct> _sentProducts = [];

  // List<SentProduct> get sentProducts {
  //   return [..._sentProducts];
  // }

  Future<void> addProduct(
      {required Product product, required String userId}) async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": product.categoryId},
        "prodId": {"stringValue": product.id},
        "catTitle": {"stringValue": product.categoryTitle},
        "imageUrl": {"stringValue": product.image},
        "productName": {"stringValue": product.name},
        "productWidth": {"stringValue": product.width},
        "productUnit": {"stringValue": product.unit},
        "productLength": {"stringValue": product.length},
      }
    };
    http.Response res = await FirestoreMethods()
        .createRecord(collection: "users/$userId/products", data: payLoad);

    print(res.body);
  }

  Future<List<SentProduct>> fetchSentProducts({required String userId}) async {
    List<SentProduct> tempList = [];
    http.Response res = await FirestoreMethods()
        .getRecords(collection: "users/$userId/products");

    if (jsonDecode(res.body)["documents"] == null) {
      return [];
    }

    List<dynamic> docsData = json.decode(res.body)["documents"];
    for (var element in docsData) {
      Map fields = element["fields"];
      String catId = fields["catId"]["stringValue"];
      String prodId = fields["productId"]["stringValue"];
      String catTitle = fields["catTitle"]["stringValue"];
      String imageUrl = fields["imageUrl"]["stringValue"];
      String productName = fields["productName"]["stringValue"];
      String productWidth = fields["productWidth"]["stringValue"];
      String productUnit = fields["productUnit"]["stringValue"];
      String productLength = fields["productLength"]["stringValue"];
      String id = (element["name"] as String).split("products/").last;
      String time = element["updateTime"];

      tempList.add(SentProduct(
          id: id,
          prodCategoryId: catId,
          userId: userId,
          prodCategoryTitle: catTitle,
          prodId: prodId,
          prodImage: imageUrl,
          prodLength: productLength,
          prodName: productName,
          prodUnit: productUnit,
          prodWidth: productWidth));
    }
    print(tempList);
    return tempList;
  }

  // Future<void> fetchAndUpdateSentProducts() async {
  //   List<SentProduct> tempSentProds = [];
  //   http.Response prodRes =
  //       await FirestoreMethods().getRecords(collection: "sentporducts");

  //   List<dynamic> docsData = json.decode(prodRes.body)["documents"];

  //   for (var element in docsData) {
  //     Map fields = element["fields"];
  //     String userId = fields["userId"]["stringValue"];
  //     String prodId = fields["productId"]["stringValue"];
  //     String catId = fields["catId"]["stringValue"];
  //     String catTitle = fields["catTitle"]["stringValue"];
  //     String imageUrl = fields["imageUrl"]["stringValue"];
  //     String productName = fields["productName"]["stringValue"];
  //     String productWidth = fields["productWidth"]["stringValue"];
  //     String productUnit = fields["productUnit"]["stringValue"];
  //     String productLength = fields["productLength"]["stringValue"];
  //     String id = (element["name"] as String).split("products/").last;
  //     String time = element["updateTime"];

  //     tempSentProds.add(SentProduct(
  //         userId: userId,
  //         productId: prodId,
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

  //   _sentProducts = tempSentProds;

  //   notifyListeners();
  // }

  // Future<void> searchProduct(String title, String field) async {
  //   List<Product> tempProds = [];
  //   String prodRes = await FirestoreMethods().searchProduct(title, field);

  //   List<dynamic> docsData = json.decode(prodRes);

  //   for (var element in docsData) {
  //     if (element['document'] == null) {
  //       break;
  //     }

  //     Map fields = element['document']["fields"];
  //     String catId = fields["catId"]["stringValue"];
  //     String catTitle = fields["catTitle"]["stringValue"];
  //     String imageUrl = fields["imageUrl"]["stringValue"];
  //     String productName = fields["productName"]["stringValue"];
  //     String productWidth = fields["productWidth"]["stringValue"];
  //     String productUnit = fields["productUnit"]["stringValue"];
  //     String productLength = fields["productLength"]["stringValue"];
  //     String id =
  //         (element['document']["name"] as String).split("products/").last;
  //     String time = element['document']["updateTime"];

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

  //   _products = tempProds;

  //   notifyListeners();
  // }

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

  Future<void> deleteSentProduct(String sentProductId) async {
    http.Response res = await FirestoreMethods()
        .deleteRecord(collection: "products", prodId: sentProductId);
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

  Future<void> patchProductToUser() async {
// http.patch(`https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/sentproductsrecord/<DOCID>?updateMask.fieldPaths=catId&updateMask.fieldPaths=catTitle`,

    var url = Uri.parse(
        "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/sentproductsrecord/nSjSkxHjK2aleq8WhQra?updateMask.fieldPaths=catId&updateMask.fieldPaths=catTitle");
    var body = jsonEncode({
      "fields": {
        "catId": {"stringValue": "newcatId"},
        "catTitle": {"stringValue": "newnewn"},
      }
    });
    http.Response res = await http.patch(url, body: body);
    print(res.body);
  }
}

// axios.patch(`https://firestore.googleapis.com/v1/projects/<PROJECTIDHERE>/databases/(default)/documents/<COLLECTIONNAME>/<DOCID>?updateMask.fieldPaths=title&updateMask.fieldPaths=post&updateMask.fieldPaths=summary&updateMask.fieldPaths=category &updateMask.fieldPaths=published&updateMask.fieldPaths=modified`,
//         { fields:
//             { title:
//                 { stringValue: this.post.title },
//                 post: { stringValue: this.post.post },
//                 summary: { stringValue: this.post.description },
//                 category: { stringValue: this.post.category },
//                 published: { booleanValue: this.post.published },
//                 modified: { timestampValue: new Date() }
//             }
//         }
//     )
//     .then(doc => {
//         console.log("Document successfully updated!");
//     })
