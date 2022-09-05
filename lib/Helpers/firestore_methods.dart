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
            'from': {'collectionId': 'categories'},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": 'title'},
                "op": 'LESS_THAN',
                "value": {'stringValue': 'onz'}
              }
            }
          }
        }));
    print(res.body);

    return '';
  }

  Future<http.Response> searchDocumnent(
      {required String collection,
      required String field,
      required String fieldValue}) async {
    final URL = Uri.parse("${filterUrl}:runQuery");
    var res = await http.post(URL,
        body: json.encode({
          'structuredQuery': {
            'from': {'collectionId': collection},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": field},
                "op": 'EQUAL',
                "value": {'stringValue': fieldValue}
              }
            }
          }
        }));

    return res;
  }

  Future<String> searchProduct(String title, String field) async {
    final URL = Uri.parse("${filterUrl}:runQuery");
    var res = await http.post(URL,
        body: json.encode({
          'structuredQuery': {
            'from': {'collectionId': 'products'},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": field},
                "op": 'EQUAL',
                "value": {'stringValue': title}
              }
            }
          }
        }));

    return res.body;
  }

  getCatById({required String collection, required String catId}) async {
    final URL = Uri.parse("${filterUrl}:runQuery");
    var res = await http.post(
      URL,
      body: json.encode({
        'structuredQuery': {
          'from': {'collectionId': collection},
          'where': {
            'fieldFilter': {
              "field": {"fieldPath": String},
              "op": 'EQUAL',
              "value": {'stringValue': catId}
            }
          }
        }
      }),
    );
    print(res.body);
    // var resData = jsonDecode(res.body);
    // for (var element in resData) {
    //   print(element.runtimeType);
    // }
  }

  Future<http.Response> updateSingleField(
      {required String collection,
      required String documentId,
      required String fieldName,
      required var bodyData}) async {
// http.patch(`https://firestore.googleapis.com/v1/projects/aneescasting-ec184/databases/(default)/documents/sentproductsrecord/<DOCID>?updateMask.fieldPaths=catId&updateMask.fieldPaths=catTitle`,

    var url = Uri.parse(
        "$baseUrl$collection/$documentId?updateMask.fieldPaths=$fieldName");
    // var body = jsonEncode({
    //   "fields": {
    //     "catId": {"stringValue": "newcatId"},
    //     "catTitle": {"stringValue": "newnewn"},
    //   }
    // });
    http.Response res = await http.patch(url, body: bodyData);
    return res;
  }
}
