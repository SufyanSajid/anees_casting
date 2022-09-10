import '/Models/user.dart';
import '/contant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FirebaseAuth {
  final signUpUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$APIkey';

  Future<void> createNewUser({
    required String name,
    required String email,
    required String role,
    required String image,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse(signUpUrl);
    var body = jsonEncode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });
    final response = await http.post(url, body: body);
    var extractedData = json.decode(response.body);
    print(extractedData["localId"]);
    await Users().createUser(
        authId: extractedData["localId"],
        name: name,
        email: email,
        role: role,
        image: image,
        phone: phone);
  }

  Future<void> changePassword(
      {required String password, required String userId}) async {
    try {
      print(userId);
      final url = Uri.parse(
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=$APIkey');

      var response = await http.post(url, body: {
        'idToken': userId,
        'password': password,
        'returnSecureToken': 'true',
      });
      // print(response.body);
      var responseBody = json.decode(response.body);
      var error;
      if (responseBody['error'] != null) {
        error = responseBody['error']['message'];
        throw error;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<http.Response> deletUser(authId) async {
    print("delete");
    var URL = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts/$authId/:delete?key=$APIkey');
    http.Response delRes = await http.post(URL);
    print("Delete auth ${delRes.body}");

    return delRes;
  }
}
