import 'dart:convert';
import 'dart:async';
import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import '../Models/http_exception.dart';

class CurrentUser {
  String id;
  String? name;
  String? role;
  String token;
  String phone;
  String email;
  CurrentUser({
    required this.id,
    required this.token,
    required this.phone,
    this.name,
    this.role,
    required this.email,
  });
}

class Auth with ChangeNotifier {
  CurrentUser? currentUser;
  bool autoLogout=false;

  void setName(String name) {
    currentUser!.name = name;
    notifyListeners();
  }

  void setAutoLogout(value){
    autoLogout=value;
    notifyListeners();
  }
  

  bool isUserLoggedIn() {
    return true;
    // print('userrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
    // if (currentUser == null) {
    //   print('ffffffffffffffffffffff');
    //   return false;
    // } else {
    //   print('trrrrrrrrrrrrrrrrrrrrue');
    //   return true;
    // }
  }

  // String? _token;
  // DateTime? _expiryDate;
  // String? _userId;
  // Timer? _authTimer;

  // bool get isAuth {
  //   return token != '';
  // }

  String? get userid {
    return currentUser!.id;
  }

  // String? get token {
  //   if (currentUser!.expiryDate.isAfter(DateTime.now()) &&
  //       currentUser!.token != '') {
  //     return currentUser!.token;
  //   }
  //   return '';
  // }

  // Future<bool> isBlocked(String authId) async {
  //   final URL = Uri.parse(
  //       "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents:runQuery");
  //   var res = await http.post(URL,
  //       body: json.encode({
  //         'structuredQuery': {
  //           'from': {'collectionId': 'users'},
  //           'where': {
  //             'fieldFilter': {
  //               "field": {"fieldPath": "authId"},
  //               "op": 'EQUAL',
  //               "value": {'stringValue': authId}
  //             }
  //           }
  //         }
  //       }));

  //   List<dynamic> docsData = json.decode(res.body);

  //   if (docsData[0]["document"] == null) {
  //     return true;
  //   }

  //   return docsData[0]["document"]["fields"]["isBlocked"]["booleanValue"];
  // }

  Future<void> changeUserName(
      {required String name,
      required String userId,
      required String phone,
      required String userToken}) async {
    final url = Uri.parse('${baseUrl}edit_user');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
      body: {
        'user_id': userId,
        'name': name,
        'phone': phone,
      },
    );
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      print(extractedData['data']);
    } else {
      var message = extractedData['message'];
      throw message;
    }
  }

  Future<void> changePassword(
      {required String password,
      required String userId,
      required String userToken}) async {
    final url = Uri.parse('${baseUrl}change_password');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
      body: {
        'user_id': userId,
        'new_password': password,
      },
    );
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      print(extractedData['data']);
    } else {
      var message = extractedData['message'];
      throw message;
    }
  }

  Future<void> resetPassword(String email) async {
    final url = Uri.parse('${baseUrl}send_otp');

    var response = await http.post(url, body: {
      'email': email,
    });
    print(response.body);
  }

  Future<bool> verifyCode({required String email, required String code}) async {
    final url = Uri.parse('${baseUrl}verify_otp_and_change_password');

    var response = await http.post(url, body: {
      'email': email,
      'otp': code,
    });
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> forgetChangePassword(
      {required String code,
      required String email,
      required String password}) async {
    final url = Uri.parse('${baseUrl}verify_otp_and_change_password');

    var response = await http.post(url, body: {
      'email': email,
      'otp': code,
      'password': password,
    });
    print(response.body);
  }

  Future<void> LoginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final url = Uri.parse('${baseUrl}login');
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );
      print(response.body);

      var extractedData = json.decode(response.body);

      if (extractedData['success'] == true) {
        String userRole;
        var userData = extractedData['data'];
        if (userData['role'] == '0') {
          userRole = 'customer';
        } else if (userData['role'] == '1') {
          userRole = 'admin';
        } else {
          userRole = 'seller';
        }
        currentUser = CurrentUser(
            id: userData['id'].toString(),
            email: userData['email'],
            name: userData['name'],
            phone: userData['phone'],
            role: userRole,
            token: userData['token']);

        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData1 = json.encode({
          'token': currentUser!.token,
          'role': currentUser!.role,
          'name': currentUser!.name,
          'userId': currentUser!.id,
          'phone': currentUser!.phone,
          'email': currentUser!.email,
        });
        prefs.setString('userData', userData1);
      } else {
        var message = extractedData['message'];
        throw message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userData')) {
        return false;
      }

      final extractedUserData =
          json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

      currentUser = CurrentUser(
        id: extractedUserData['userId'] as String,
        role: extractedUserData['role'] as String,
        token: extractedUserData['token'] as String,
        name: extractedUserData['name'] as String,
        phone: extractedUserData['phone'] as String,
        email: extractedUserData['email'] as String,
      );
      notifyListeners();
      // autologout();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    currentUser == null;

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }

  // void autologout() {
  //   if (_authTimer != null) {
  //     _authTimer!.cancel();
  //   }
  //   final timeToExpiry =
  //       currentUser!.expiryDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  // }
}
