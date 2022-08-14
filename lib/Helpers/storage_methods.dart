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

  Future<String> updateImage(
      {required var file, required String imageURl}) async {
    var url2file = imageURl;

    http.Response res = await http.post(Uri.parse(url2file),
        body: file, headers: {"Content-Type": "image/png"});
    Map resDate = jsonDecode(res.body);
    // String name = resDate["name"];
    String token = resDate["downloadTokens"];
    String downloadUrl = "$url2file?alt=media&token=$token";
    return downloadUrl;
  }
}
