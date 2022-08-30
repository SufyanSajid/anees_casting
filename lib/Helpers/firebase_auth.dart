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
    print('yeh ha response new user ka ${response.body}');
    var extractedData = json.decode(response.body);

    await Users().createUser(
        authId: extractedData["localId"],
        name: name,
        email: email,
        role: role,
        image: image,
        phone: phone);
  }

  Future<http.Response> deletUser(authId) async {
    var URL = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts/$authId/:delete?key=$APIkey');
    http.Response delRes = await http.delete(URL);

    return delRes;
  }
}
