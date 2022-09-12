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

  Future<http.Response> getRecords(
      {required String collection, String? pageToken}) async {
    String ur = '';
    if (collection == 'products') {
      ur = "$baseUrl$collection?pageSize=2";

      if (pageToken != null) {
        ur += "&pageToken=$pageToken";
      }
    } else {
      ur = baseUrl + collection;
    }

    final url = Uri.parse(ur);

    var res = await http.get(url);

    return res;
  }

  // For pagination

  Future<http.Response> getChunkRecords({required String collection}) async {
    var url = Uri.parse("$baseUrl$collection?pageSize=2&pageToken=");
    http.Response res = await http.get(url);
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

  Future<http.Response> getCustomerProducts(String cusId) async {
    final URL = Uri.parse("${filterUrl}:runQuery");
    var res = await http.post(URL,
        body: json.encode({
          'structuredQuery': {
            'from': {'collectionId': 'products'},
            'where': {
              'fieldFilter': {
                "field": {"fieldPath": 'customers'},
                "op": 'ARRAY_CONTAINS',
                "value": {'stringValue': cusId}
              }
            }
          }
        }));

    return res;
  }

  Future<http.Response> searchProduct(String title, String field) async {
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

    return res;
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
