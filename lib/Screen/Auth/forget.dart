import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  static const routeName = 'forget-screen';
  ForgetScreen({super.key});
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/poster.jpeg',
              ),
              fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            height: height(context) * 20,
            decoration: BoxDecoration(color: Colors.white),
          ),
        ));
  }
}
