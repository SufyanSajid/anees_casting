import 'dart:io';

import 'package:http/http.dart' as http;

class StorageMethods {
  final String baseUrl = "https://firebasestorage.googleapis.com/v1beta/";

  Future<String> uploadImage(var file) async {
    var url2file =
        'https://firebasestorage.googleapis.com/v0/b/aneescasting-ec184.appspot.com/o/products%2Fyour_pic.png';
    // headers = {"Content-Type": "image/png"}

    // r = requests.post(url2file, data=file_binary, headers=headers)

    //var binary = await file.readAsBytes();

    var res = await http.post(Uri.parse(url2file),
        body: file, headers: {"Content-Type": "image/png"});

    print(res.body);
    return '';
  }
}
