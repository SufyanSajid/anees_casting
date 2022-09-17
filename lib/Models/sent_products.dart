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
  List<String>? customers;
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
      this.customers,
      required this.prodUnit,
      required this.prodWidth});
}

class SentProducts with ChangeNotifier {
  // List<SentProduct> _sentProducts = [];

  // List<SentProduct> get sentProducts {
  //   return [..._sentProducts];
  // }

  // Future<void> addProduct(
  //     {required Product product, required String userId}) async {
  //   List<String>? productCustomers = product.customers;

  //   List<dynamic> customers = [];

  //   if (productCustomers != null && productCustomers.isNotEmpty) {
  //     if (!productCustomers.contains(userId)) {
  //       customers.add({
  //         'stringValue': userId,
  //       });
  //     }
  //     for (var customer in productCustomers) {
  //       customers.add({'stringValue': customer});
  //     }
  //   } else {
  //     customers.add({
  //       'stringValue': userId,
  //     });
  //   }

  //   var payLoad = jsonEncode({
  //     "fields": {
  //       "customers": {
  //         "arrayValue": {'values': customers}
  //       },
  //     }
  //   });

  //   var response = await FirestoreMethods().updateSingleField(
  //       collection: 'products',
  //       documentId: product.id,
  //       fieldName: 'customers',
  //       bodyData: payLoad);
  // }

  // Future<void> deleteSentProduct(
  //     {required Product product, required String userId}) async {
  //   List<String>? productCustomers = product.customers;

  //   List<dynamic> customers = [];

  //   if (productCustomers != null && productCustomers.isNotEmpty) {
  //     productCustomers.remove(userId);

  //     for (var customer in productCustomers) {
  //       customers.add({'stringValue': customer});
  //     }
  //   }
  //   print(productCustomers);
  //   print(customers);

  //   var payLoad = jsonEncode({
  //     "fields": {
  //       "customers": {
  //         "arrayValue": {'values': customers}
  //       },
  //     }
  //   });

  //   var response = await FirestoreMethods().updateSingleField(
  //       collection: 'products',
  //       documentId: product.id,
  //       fieldName: 'customers',
  //       bodyData: payLoad);
  // }

  // Future<List<SentProduct>> fetchSentProducts({required String userId}) async {
  //   List<SentProduct> tempList = [];
  //   http.Response res = await FirestoreMethods()
  //       .getRecords(collection: "users/$userId/products");

  //   if (jsonDecode(res.body)["documents"] == null) {
  //     return [];
  //   }

  //   List<dynamic> docsData = json.decode(res.body)["documents"];
  //   for (var element in docsData) {
  //     List<String> customers = [];
  //     Map fields = element["fields"];
  //     String catId = fields["catId"]["stringValue"];
  //     String prodId = fields["productId"]["stringValue"];
  //     String catTitle = fields["catTitle"]["stringValue"];
  //     String imageUrl = fields["imageUrl"]["stringValue"];
  //     String productName = fields["productName"]["stringValue"];
  //     String productWidth = fields["productWidth"]["stringValue"];
  //     String productUnit = fields["productUnit"]["stringValue"];
  //     String productLength = fields["productLength"]["stringValue"];
  //     String id = (element["name"] as String).split("products/").last;
  //     String time = element["updateTime"];
  //     if (fields['customers'] != null) {
  //       // print(fields['customers']);
  //       if (fields['customers']['arrayValue']['values'] != null) {
  //         var values = fields['customers']['arrayValue']['values'];
  //         for (var customer in values) {
  //           customers.add(customer['stringValue']);
  //         }
  //       }
  //     }

  //     tempList.add(SentProduct(
  //         id: id,
  //         prodCategoryId: catId,
  //         userId: userId,
  //         prodCategoryTitle: catTitle,
  //         prodId: prodId,
  //         prodImage: imageUrl,
  //         prodLength: productLength,
  //         prodName: productName,
  //         customers: customers,
  //         prodUnit: productUnit,
  //         prodWidth: productWidth));
  //   }
  //   print(tempList);
  //   return tempList;
  // }

  Future<void> updateProduct({required Product product}) async {
    var payLoad = {
      "fields": {
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
