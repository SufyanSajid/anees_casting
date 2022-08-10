import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreMethods {
  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/";

  Future<http.Response> createRecord(
      {required String collection, required var data}) async {
    final URL = Uri.parse(baseUrl + collection);

    var res = await http.post(URL, body: json.encode(data));
    return res;
  }

  Future<http.Response> getRecords({required String collection}) async {
    final URL = Uri.parse(baseUrl + collection);

    var res = await http.get(URL);
    return res;
  }

  Future<http.Response> updateRecords(
      {required String collection,
      required var data,
      required String prodId}) async {
    final URL = Uri.parse("$baseUrl$collection/$prodId");

    var res = await http.patch(URL, body: json.encode(data));

    return res;
  }

  Future<http.Response> deleteRecord(
      {required String collection, required String prodId}) async {
    final URL = Uri.parse("$baseUrl$collection/$prodId");
    var res = await http.delete(URL);

    return res;
  }
}
