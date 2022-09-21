import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Log {
  String id;
  String userid;
  String userName;
  String content;
  String logType;

  Log({
    required this.id,
    required this.userid,
    required this.userName,
    required this.content,
    required this.logType,
  });
}

class Logs with ChangeNotifier {
  List<Log> _logs = [];

  List<Log> get logs {
    return [..._logs];
  }

  Future<void> fetchAndSetLogs({
    required String userToken,
  }) async {
    List<Log> tempLogs = [];
    final url = Uri.parse('${baseUrl}logs');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    print(response.body);
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      var data = extractedData['data'] as List<dynamic>;
      data.forEach((log) {
        tempLogs.add(
          Log(
            id: log['id'].toString(),
            userid: log['user_id'],
            userName: log['user_name'],
            content: log['content'],
            logType: log['type'],
          ),
        );
      });
      _logs = tempLogs;
      notifyListeners();
    } else {
      print('error in fetching logs');
    }
  }

  Future<void> addLog({required Log log, required String userToken}) async {
    print(log.logType);
    final url = Uri.parse('${baseUrl}logs');
    print(url);

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'type': log.logType.toString(),
      'content': log.content,
      'user_id': log.userid,
    });

    print(response.body);

    _logs.add(log);
    notifyListeners();
  }
}
