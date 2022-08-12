import 'dart:convert';

import 'package:http/http.dart' as http;

class StorageMethods {
  final String baseUrl =
      "https://firebasestorage.googleapis.com/v0/b/aneescasting-ec184.appspot.com/o/";

  Future<String> uploadImage(
      {required var file, required String collection}) async {
    var url2file =
        "$baseUrl$collection%2F${DateTime.now().millisecondsSinceEpoch}.png";

// headers = {"Content-Type": "image/png"}
    // r = requests.post(url2file, data=file_binary, headers=headers)
//var binary = await file.readAsBytes();

    http.Response res = await http.post(Uri.parse(url2file),
        body: file, headers: {"Content-Type": "image/png"});
    Map resDate = jsonDecode(res.body);
    // String name = resDate["name"];
    String token = resDate["downloadTokens"];
    String downloadUrl = "$url2file?alt=media&token=$token";
    return downloadUrl;
  }

  Future<String> deleteImage({required String imgUrl}) async {
    var URL = Uri.parse(imgUrl);
    http.Response res = await http.delete(URL);

    return res.toString();
  }

  // Future<http.Response> updateImage(
  //     {required String imgUrl, required var file}) async {
  //   String url =
  //       // "https://firebasestorage.googleapis.com/v0/b/aneescasting-ec184.appspot.com/o/products%2F1660200981231.png";
  //       // "${baseUrl}products%2F1660200981231.png";

  //       //  "https://storage.googleapis.com/storage/v1/b/gs:/aneescasting-ec184.appspot.com/acl/products/1660200981231.png?&token=47e92d3e-c3cf-4b3c-bff8-106c5169c0e1";
  //       "${baseUrl}aneescasting-ec184.appspot.com/products/1660200981231.png";
  //   var URL = Uri.parse(url);
  //   var body = json.encode(file);
  //   http.Response res = await http.post(URL, body: body);
  //   print(res.statusCode.toString());
  //   print(res.body.toString());
  //   return res;
  // }
  Future<String> updateImage(
      {required var file, required String imageURl}) async {
    var url2file = imageURl;

// headers = {"Content-Type": "image/png"}
    // r = requests.post(url2file, data=file_binary, headers=headers)
//var binary = await file.readAsBytes();

    http.Response res = await http.post(Uri.parse(url2file),
        body: file, headers: {"Content-Type": "image/png"});
    Map resDate = jsonDecode(res.body);
    // String name = resDate["name"];
    String token = resDate["downloadTokens"];
    String downloadUrl = "$url2file?alt=media&token=$token";
    return downloadUrl;
  }
}
