import 'dart:convert';

import '/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AUser {
  String id;
  String authId;
  String name;
  String email;
  String role;
  String phone;

  AUser({
    required this.id,
    required this.authId,
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
    required String authId,
    required String name,
    required String email,
    required String role,
    required String image,
    required String phone,
  }) async {
    var payLoad = {
      "fields": {
        "authId": {"stringValue": authId},
        "phone": {"stringValue": phone},
        "name": {"stringValue": name},
        "email": {"stringValue": email},
        "role": {"stringValue": role},
        "image": {"stringValue": image},
      }
    };

    http.Response res = await FirestoreMethods()
        .createRecord(collection: "users", data: payLoad);
  }

  fetchAndUpdateUser() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "users/?pageSize=100");
    List<dynamic> resData = jsonDecode(res.body)["documents"];

    List<AUser> tempUsers = [];
    for (var element in resData) {
      Map fields = element["fields"];
      String authId = fields["authId"]["stringValue"];
      String name = fields["name"]["stringValue"];
      String email = fields["email"]["stringValue"];
      String phone = fields["phone"]["stringValue"];
      String role = fields["role"]["stringValue"];
      String id = (element["name"] as String).split("users/").last;

      tempUsers.add(AUser(
        id: id,
        authId: authId,
        name: name,
        email: email,
        phone: phone,
        role: role,
      ));
    }

    _users = tempUsers;

    notifyListeners();
  }
}
