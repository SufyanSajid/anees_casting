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
  final List<Log> _logs = [
    Log(
      id: '1',
      userid: '2',
      userName: 'Sufyan Sajid',
      content: 'Active for 2 hours',
      logType: 'Activity',
    ),
    Log(
      id: '2',
      userid: '2',
      userName: 'Affan Sajid',
      content: 'Shared Article #123',
      logType: 'Share',
    ),
    Log(
      id: '3',
      userid: '2',
      userName: 'Noman Sajid',
      content: 'Active for 2 hours',
      logType: 'Activity',
    ),
    Log(
      id: '4',
      userid: '2',
      userName: 'Ayyan Sufyan',
      content: 'Shared Article #123',
      logType: 'Share',
    ),
    Log(
      id: '11',
      userid: '2',
      userName: 'Sufyan Sajid',
      content: 'Active for 2 hours',
      logType: 'Activity',
    ),
    Log(
      id: '22',
      userid: '2',
      userName: 'Affan Sajid',
      content: 'Shared Article #123',
      logType: 'Share',
    ),
    Log(
      id: '33',
      userid: '2',
      userName: 'Noman Sajid',
      content: 'Active for 2 hours',
      logType: 'Activity',
    ),
    Log(
      id: '43',
      userid: '2',
      userName: 'Ayyan Sufyan',
      content: 'Shared Article #123',
      logType: 'Share',
    ),
  ];

  List<Log> get logs {
    return [..._logs];
  }
}
