import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AUser {
  String id;
  String name;
  String email;
  String role;
  String phone;

  AUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });
}

class Users with ChangeNotifier {
  List<AUser> _users = [];

  List<AUser> get users {
    return [..._users];
  }

  Future<void> createUser({
    required String id,
    required String name,
    required String email,
    required String role,
    required String image,
    required String phone,
  }) async {
    var payLoad = {
      "fields": {
        "id": {"stringValue": id},
        "phone": {"stringValue": phone},
        "name": {"stringValue": name},
        "email": {"stringValue": email},
        "role": {"stringValue": role},
        "image": {"stringValue": image},
      }
    };

    http.Response res = await FirestoreMethods()
        .createRecord(collection: "users", data: payLoad);
    print(res);
  }

  fetchAndUpdateUser() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "users/?pageSize=100");
    List<dynamic> resData = jsonDecode(res.body)["documents"];

    List<AUser> tempUsers = [];
    for (var element in resData) {
      Map fields = element["fields"];
      String id = fields["id"]["stringValue"];
      String name = fields["name"]["stringValue"];

      String email = fields["email"]["stringValue"];
      String phone = fields["phone"]["stringValue"];
      String role = fields["role"]["stringValue"];

      tempUsers.add(AUser(
        id: id,
        name: name,
        email: email,
        phone: phone,
        role: role,
      ));
    }

    _users = tempUsers;
    print(_users);
    notifyListeners();
  }
}
