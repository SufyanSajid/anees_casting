import 'package:flutter/material.dart';

class AUser {
  int id;
  String name;
  String email;
  String role;
  String phone;
  String image;

  AUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.role,
      required this.image});
}

class Users with ChangeNotifier{
  List<AUser> _users = [
    AUser(
      id: 1,
      name: 'Sufyan Sajid',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Customer',
      image: 'assets/images/sufyan1.jpeg',
    ),
      AUser(
      id: 12,
      name: 'Abdul Wahab',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Seller',
      image: 'assets/images/sufyan1.jpeg',
    ),
      AUser(
      id: 13,
      name: 'Awais Haleem',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Customer',
      image: 'assets/images/sufyan1.jpeg',
    ),
      AUser(
      id: 31,
      name: 'Affan Sajid',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Customer',
      image: 'assets/images/sufyan1.jpeg',
    ),
      AUser(
      id: 122,
      name: 'Abdul Sami',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Seller',
      image: 'assets/images/sufyan1.jpeg',
    ),
      AUser(
      id: 313,
      name: 'Ali Imran',
      email: 'themssk@gmail.com',
      phone: '+923075309167',
      role: 'Customer',
      image: 'assets/images/sufyan1.jpeg',
    ),
    
  ];

  List<AUser> get users {
    return [..._users];
  }
}
