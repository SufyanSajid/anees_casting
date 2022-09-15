import 'dart:convert';

import '../contant.dart';
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
  List<AUser> _customers = [];

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

  List<AUser> get customers {
    return [..._customers];
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final url = Uri.parse('${baseUrl}register');

      var response = await http.post(url, body: {
        'name': name,
        'email': email,
        'password': password,
        'c_password': password,
        'phone': name,
      });

      var extractedData = json.decode(response.body);
      if (extractedData['success'] == true) {
        print(extractedData['message']);
      } else {
        var message = extractedData['message'];
        throw message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUserRole(
      {required String userId,
      required String userToken,
      required String userRole}) async {
    final url = Uri.parse('${baseUrl}update_role');
    String roleId;
    if (userRole.toLowerCase() == 'admin') {
      roleId = '1';
    } else if (userRole.toLowerCase() == 'seller') {
      roleId = '2';
    } else {
      roleId = '0';
    }

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer ${userToken}'
    }, body: {
      'user_id': userId,
      'role': roleId,
    });
    print(response.body);
  }

  Future<void> fetchAndUpdateUser() async {
    http.Response res =
        await FirestoreMethods().getRecords(collection: "users");
    List<dynamic> resData = jsonDecode(res.body)["documents"];

    List<AUser> tempUsers = [];
    List<AUser> tempCustomers = [];

    for (var element in resData) {
      Map fields = element["fields"];
      String authId = fields["authId"]["stringValue"];
      String name = fields["name"]["stringValue"];
      String email = fields["email"]["stringValue"];
      String phone = fields["phone"]["stringValue"];
      String role = fields["role"]["stringValue"];
      bool isBlocked = fields["isBlocked"]["booleanValue"];
      String id = (element["name"] as String).split("users/").last;

      AUser user = AUser(
          id: id,
          authId: authId,
          name: name,
          email: email,
          phone: phone,
          role: role,
          isBlocked: isBlocked);

      tempUsers.add(user);

      if (role == "Customer") {
        tempCustomers.add(user);
      }
    }

    _users = tempUsers;
    _customers = tempCustomers;

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
