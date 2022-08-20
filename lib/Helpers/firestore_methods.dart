import 'package:http/http.dart' as http;
import 'dart:convert';

class FirestoreMethods {
  final String baseUrl =
      "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/";

  final String filterUrl =
      "https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents";

  Future<http.Response> createRecord(
      {required String collection, required var data}) async {
    final URL = Uri.parse(baseUrl + collection);

    var res = await http.post(URL, body: json.encode(data));
    return res;
  }

  Future<http.Response> getRecords({required String collection}) async {
    final URL = Uri.parse(baseUrl + collection
        // +
        // '?pageSize=&pageToken=AFTOeJw4lsJ0Zqy1YIqSMtWmRduefCa_e8noRIKBDOwZ03n1LJm2cFM1A_E7Z40j_El08Of9oDIvV7cu8n6jkxe6u4WbqjnVuroeFJ1p_u9YJ-iyC2eNFnTEwLPVIBFfrRlX'
        );

    var res = await http.get(URL);
    print(json.decode(res.body));
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

  //firebase filters

  Future<String> getProductsByCatId() async {
    final URL = Uri.parse("${filterUrl}:runQuery");
    var res = await http.post(URL,
        body: json.encode({
          'structuredQuery': {
            'from': {'collectionId': 'products'},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": 'catId'},
                "op": 'EQUAL',
                "value": {'stringValue': '3i3fCjKHWRD4RAipYYiW'}
              }
            }
          }
        }));
    // print(res.body);

    return '';
  }
}
