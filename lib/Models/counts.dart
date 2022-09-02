// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:anees_costing/Helpers/firestore_methods.dart';

class Count {
  int productsCount;
  int usersCount;
  int catsCount;
  Count({
    required this.productsCount,
    required this.usersCount,
    required this.catsCount,
  });
}

class Counts with ChangeNotifier {
  Count? _counts;

  Count? get getCount => _counts;

  Future<void> fetchtAndUpdateCount() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "counts");

    List<dynamic> resData = jsonDecode(res.body)["documents"];

    Map fields = resData[0]["fields"];
    String users = fields["users"]["stringValue"];
    String categories = fields["categories"]["stringValue"];
    String products = fields["products"]["stringValue"];

    _counts = Count(
        productsCount: int.parse(products),
        usersCount: int.parse(users),
        catsCount: int.parse(categories));

    notifyListeners();
  }

  // Future<void> increaseUsersCount() async {
  //   var payLoad = {
  //     "fields": {
  //       "catId": {"stringValue": (_userCount! + 1).toString()},
  //     }
  //   };

  //   await FirestoreMethods().updateRecords(
  //       collection: "users count", data: payLoad, prodId: "usersCount");

  //   _userCount = _userCount! + 1;
  //   notifyListeners();
  // }

  // Future<void> decreaseUsers() async {
  //   var payLoad = {
  //     "fields": {
  //       "catId": {"stringValue": (_userCount! - 1).toString()},
  //     }
  //   };

  //   await FirestoreMethods().updateRecords(
  //       collection: "users count", data: payLoad, prodId: "usersCount");

  //   _userCount = _userCount! - 1;
  //   notifyListeners();
  // }
}
