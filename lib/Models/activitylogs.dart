import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';

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

  Future<void> fetchAndSetLogs() async {
    List<Log> tempLogs = [];
    var prodRes = await FirestoreMethods().getRecords(
      collection: "logs",
    );

    var data = json.decode(prodRes.body);
    List<dynamic> docsData = data["documents"];
    for (var element in docsData) {
      Map fields = element["fields"];
      String userId = fields["userId"]["stringValue"];
      String userName = fields["userName"]["stringValue"];
      String content = fields["content"]["stringValue"];
      String logType = fields["logType"]["stringValue"];

      String id = (element["name"] as String).split("logs/").last;
      String time = element["updateTime"];

      tempLogs.add(
        Log(
          id: id,
          userid: userId,
          userName: userName,
          content: content,
          logType: logType,
        ),
      );
      _logs = tempLogs;
      notifyListeners();
    }
  }

  Future<void> addLog(Log log) async {
    var payLoad = {
      "fields": {
        "userId": {"stringValue": log.userid},
        "userName": {"stringValue": log.userName},
        "content": {"stringValue": log.content},
        "logType": {"stringValue": log.logType},
      }
    };

    var response = await FirestoreMethods()
        .createRecord(collection: 'logs', data: payLoad);

    _logs.add(log);
    notifyListeners();
  }
}
