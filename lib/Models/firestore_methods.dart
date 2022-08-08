import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreMethods {
  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/";

  Future<String> createRecord(
      {required String collection, required var data}) async {
    final URL = Uri.parse(baseUrl + collection);

    var res = await http.post(URL, body: json.encode(data));
    return res.body.toString();
  }

  Future<http.Response> getRecords({required String collection}) async {
    final URL = Uri.parse(baseUrl + collection);

    var res = await http.get(URL);
    return res;
  }
}
