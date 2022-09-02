import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsersCount with ChangeNotifier {
  int? _userCount;

  int? get getUserCount => _userCount;

  Future<void> fetchtAndUpdateUsersCount() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "users count");

    List<dynamic> resData = jsonDecode(res.body)["documents"];

    Map fields = resData[0]["fields"];
    String count = fields["count"]["stringValue"];
    int uCount = int.parse(count);
    _userCount = uCount;
    notifyListeners();
  }

  Future<void> increaseUsersCount() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_userCount! + 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "users count", data: payLoad, prodId: "usersCount");

    _userCount = _userCount! + 1;
    notifyListeners();
  }

  Future<void> decreaseUsers() async {
    var payLoad = {
      "fields": {
        "catId": {"stringValue": (_userCount! - 1).toString()},
      }
    };

    await FirestoreMethods().updateRecords(
        collection: "users count", data: payLoad, prodId: "usersCount");

    _userCount = _userCount! - 1;
    notifyListeners();
  }
}
