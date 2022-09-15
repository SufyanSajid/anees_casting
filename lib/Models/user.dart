import 'dart:convert';

import '../contant.dart';
import '/Helpers/firestore_methods.dart';
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

  Future<void> fetchAndUpdateUser({required String userToken}) async {
    List<AUser> tempUsers = [];
    List<AUser> tempCustomers = [];

    final url = Uri.parse('${baseUrl}users');

    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $userToken'});

    var extractedData = json.decode(response.body);

    if (extractedData['success'] == true) {
      var data = extractedData['data'] as List<dynamic>;
      data.forEach((user) {
        String userRole;

        if (user['role'] == '1') {
          userRole = 'Admin';
        } else if (user['role'] == '2') {
          userRole = 'Seller';
        } else {
          userRole = 'Customer';
        }
        tempUsers.add(
          AUser(
            id: user['id'].toString(),
            name: user['name'],
            email: user['email'],
            phone: user['phone'],
            role: userRole,
          ),
        );
      });
      tempUsers.forEach((element) {
        element.role.toLowerCase() == 'customer'
            ? tempCustomers.add(element)
            : null;
      });
      _customers = tempCustomers;
      _users = tempUsers;
      print(_users.length);
      print(_customers.length);

      notifyListeners();
    } else {
      var message = extractedData['message'];
      throw message;
    }

    // _users = tempUsers;
    // _customers = tempCustomers;

    // notifyListeners();
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
