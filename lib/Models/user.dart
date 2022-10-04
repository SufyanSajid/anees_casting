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

  Future<String> createUser({
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
        return extractedData['data']['user_id'].toString();
      } else {
        var message = extractedData['message'];

        throw message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> editrUser({
    required String userId,
    required String userName,
    required String userPhone,
    required String userToken,
  }) async {
    final url = Uri.parse('${baseUrl}edit_user');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken'
    }, body: {
      'user_id': userId,
      'name': userName,
      'phone': userPhone,
    });
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      print(extractedData['data']);
    } else {
      var message = extractedData['message'];
      throw message;
    }
  }

  void updateUserLocally(AUser user) {
    print('yeh ha role ${user.role}');

    _customers.removeWhere((element) => element.id == user.id);
    _users.removeWhere((element) => element.id == user.id);
    _users.add(user);

    if (user.role.toLowerCase() == 'customer') {
      _customers.add(user);
    }
    notifyListeners();


  }

  Future<void> updateUserRole(
      {required String userId,
      required String userToken,
      required String userRole}) async {
    final url = Uri.parse('${baseUrl}update_role');
    print(userRole);
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

  Future<void> deleteUser(
      {required String userId, required String userToken}) async {
    // try {
    final url = Uri.parse('${baseUrl}delete_user');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken'
    }, body: {
      'user_id': userId,
    });
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      _customers.removeWhere((element) => element.id == userId);
      _users.removeWhere(
        (element) => element.id == userId,
      );
      notifyListeners();
      print(extractedData['data']);
    } else {
      var message = extractedData['message'];
      print(message);
      throw message;
    }
    // } catch (error) {
    //   throw error;
    // }
  }

  Future<void> fetchAndUpdateUser({
    required String userToken,
  }) async {
    if (_users.isNotEmpty) {
      print(999);
      return;
    }
    List<AUser> tempUsers = [];
    List<AUser> tempCustomers = [];

    final url = Uri.parse('${baseUrl}users');

    var response =
        await http.get(url, headers: {'Authorization': 'Bearer $userToken'});
    print(response.body);
    print('uuuuuibfskhkbskfbvkfbvkdfbvkfbvdfkjbvdfkjbvdfkvbfkbv');

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
      print('yyyfhfbvkjbfvkjkksdbk  ${_users.length}');
      notifyListeners();
    } else {
      var message = extractedData['message'];
      // throw message;
    }

    // _users = tempUsers;
    // _customers = tempCustomers;

    // notifyListeners();
  }

  // Future<void> blockUser({required AUser user, required bool block}) async {
  //   var body = jsonEncode({
  //     "fields": {
  //       "isBlocked": {"booleanValue": block ? true : false},
  //     }
  //   });
  //   http.Response res = await FirestoreMethods().updateSingleField(
  //       collection: "users",
  //       documentId: user.id,
  //       fieldName: "isBlocked",
  //       bodyData: body);
  //   // var res = await FirebaseAuth().deletUser("fl4tlZn5GlSzjHVQj4g3iKtB7vI3");

  //   // var res = await FirestoreMethods()
  //   // .deleteRecord(collection: "Users", prodId: "QHVDHDxycecWEoT6rIyk  ");
  //   // print("Storage");
  //   // print(res.statusCode);
  //   // print(res.);
  //   // print(res.body);

  //   // res = await FirebaseAuth().deletUser('nm4T8zsUnRT7txBrWbeIJ7t7dPt1');

  //   print(res.body);
  // }

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

  List<AUser> getFilteredUsers(String filter) {
    if (filter == "Customer") {
      return _customers;
    }

    if (filter == "Seller") {
      return _users
          .where((element) => element.role.toLowerCase() == "seller")
          .toList();
    }

    if (filter == "Admin") {
      return _users
          .where((element) => element.role.toLowerCase() == "admin")
          .toList();
    }
    return _users;
  }

  resetSearchedUser() {
    _searchedUsers = [];
  }
}
