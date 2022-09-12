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
  String email;
  DateTime expiryDate;
  CurrentUser({
    required this.id,
    required this.token,
    required this.expiryDate,
    this.name,
    this.role,
    required this.email,
  });
}

class Auth with ChangeNotifier {
  CurrentUser? currentUser;

  // String? _token;
  // DateTime? _expiryDate;
  // String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != '';
  }

  String? get userid {
    return currentUser!.id;
  }

  String? get token {
    if (currentUser!.expiryDate.isAfter(DateTime.now()) &&
        currentUser!.token != '') {
      return currentUser!.token;
    }
    return '';
  }

  Future<bool> isBlocked(String authId) async {
    final URL = Uri.parse(
        "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents:runQuery");
    var res = await http.post(URL,
        body: json.encode({
          'structuredQuery': {
            'from': {'collectionId': 'users'},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": "authId"},
                "op": 'EQUAL',
                "value": {'stringValue': authId}
              }
            }
          }
        }));

    List<dynamic> docsData = json.decode(res.body);

    if (docsData[0]["document"] == null) {
      return true;
    }

    return docsData[0]["document"]["fields"]["isBlocked"]["booleanValue"];
  }

  Future<void> changeUserName(String name, String userId) async {
    var body = jsonEncode({
      "fields": {
        "name": {"stringValue": name},
      }
    });
    var response = await FirestoreMethods().updateSingleField(
        collection: 'users',
        documentId: userId,
        fieldName: 'name',
        bodyData: body);
    print(response.body);
  }

  Future<void> _authentication(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$APIkey');
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('error in login model');
        // throw HttpException(responseData['error']['message']);
      }
      var userResponse = await FirestoreMethods().searchDocumnent(
          collection: 'users',
          field: 'authId',
          fieldValue: responseData['localId']);
      // print(userResponse.body);
      var extractedUser = json.decode(userResponse.body) as List<dynamic>;
      String? userRole;
      String? userName;
      print(extractedUser);
      extractedUser.forEach((element) {
        userRole = element['document']['fields']['role']['stringValue'];
        userName = element['document']['fields']['name']['stringValue'];
      });

      currentUser = CurrentUser(
          id: responseData['localId'],
          token: responseData['idToken'],
          name: userName,
          role: userRole,
          email: responseData['email'],
          expiryDate: DateTime.now().add(
            Duration(seconds: int.parse(responseData['expiresIn'])),
          ));

      autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': currentUser!.token,
        'role': currentUser!.role,
        'name': currentUser!.name,
        'userId': currentUser!.id,
        'expiryDate': currentUser!.expiryDate.toIso8601String(),
        'email': currentUser!.email,
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  // Future<void> signUp(String email, String password) async {
  //   return _authentication(email, password, 'signUp');
  // }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    currentUser = CurrentUser(
        id: extractedUserData['userId'] as String,
        role: extractedUserData['role'] as String,
        token: extractedUserData['token'] as String,
        name: extractedUserData['name'] as String,
        expiryDate: expiryDate,
        email: extractedUserData['email']);
    // _token = extractedUserData['token'] as String;
    // _userId = extractedUserData['userId'] as String;
    // _expiryDate = expiryDate;
    notifyListeners();
    autologout();
    return true;
  }

  Future<void> logout() async {
    currentUser == null;
    // _token = '';
    // _userId = '';
    // _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    notifyListeners();
  }

  void autologout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry =
        currentUser!.expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
