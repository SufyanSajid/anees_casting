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
  bool isBlocked;

  AUser(
      {required this.id,
      required this.authId,
      required this.name,
      required this.email,
      required this.phone,
      required this.role,
      required this.isBlocked});
}

class Users with ChangeNotifier {
  List<AUser> _users = [];
  List<AUser> _searchedUsers = [];

  AUser? drawerUser;

  void setUser(AUser user) {
    drawerUser = user;
  }

  List<AUser> get users {
    return [..._users];
  }

  List<AUser> get searchedUsers {
    return [..._searchedUsers];
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
        "isBlocked": {"booleanValue": false},
      }
    };

    http.Response res = await FirestoreMethods()
        .createRecord(collection: "users", data: payLoad);
  }

  Future<void> fetchAndUpdateUser() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "users");
    List<dynamic> resData = jsonDecode(res.body)["documents"];

    List<AUser> tempUsers = [];
    for (var element in resData) {
      Map fields = element["fields"];
      String authId = fields["authId"]["stringValue"];
      String name = fields["name"]["stringValue"];
      String email = fields["email"]["stringValue"];
      String phone = fields["phone"]["stringValue"];
      String role = fields["role"]["stringValue"];
      bool isBlocked = fields["isBlocked"]["booleanValue"];
      String id = (element["name"] as String).split("users/").last;

      tempUsers.add(AUser(
          id: id,
          authId: authId,
          name: name,
          email: email,
          phone: phone,
          role: role,
          isBlocked: isBlocked));
    }

    _users = tempUsers;

    notifyListeners();
  }

  Future<void> blockUser({required AUser user, required bool block}) async {
    var body = jsonEncode({
      "fields": {
        "isBlocked": {"booleanValue": block ? true : false},
      }
    });
    http.Response res = await FirestoreMethods().updateSingleField(
        collection: "users",
        documentId: user.id,
        fieldName: "isBlocked",
        bodyData: body);
    // var res = await FirebaseAuth().deletUser("fl4tlZn5GlSzjHVQj4g3iKtB7vI3");

    // var res = await FirestoreMethods()
    // .deleteRecord(collection: "Users", prodId: "QHVDHDxycecWEoT6rIyk  ");
    // print("Storage");
    // print(res.statusCode);
    // print(res.);
    // print(res.body);

    // res = await FirebaseAuth().deletUser('nm4T8zsUnRT7txBrWbeIJ7t7dPt1');

    print(res.body);
  }

  getUsersByUser(AUser user) {
    List<AUser> temUsers = [];
    for (var element in _users) {
      if (element.name == user.name) {
        temUsers.add(element);
      }
    }
    _searchedUsers = temUsers;
    // notifyListeners();
  }

  resetSearchedUser() {
    _searchedUsers = [];
  }
}
