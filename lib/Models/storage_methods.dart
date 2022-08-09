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
    print(res);
    Map resDate = jsonDecode(res.body);
    String name = resDate["name"];
    String token = resDate["downloadTokens"];
    String downloadUrl = url2file + "?alt=media&token=${token}";
    print(downloadUrl);
    return downloadUrl;
  }

  Future<String> deleteImage() async {
    http.Response res = await http.delete(Uri.parse(
        "https://firebasestorage.googleapis.com/v0/b/aneescasting-ec184.appspot.com/o/products%2Fyour_pic.png?alt=media&token=2171982c-f239-462c-9bc4-7ff7553b89f4"));
    return res.toString();
  }
}
