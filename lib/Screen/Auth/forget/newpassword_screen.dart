import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/input_feild.dart';

class NewPassScreen extends StatefulWidget {
  static const routeName = '/new-pass';
  const NewPassScreen({super.key});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  void _submit() {}
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var height = mediaQuery.height / 100;
    var width = mediaQuery.width / 100;

    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(
            'assets/images/poster.jpeg',
          ),
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.8),
          appBar: AppBar(backgroundColor: Colors.transparent),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  //   child: Appbar(
                  //     height: height,
                  //     width: width,
                  //     leading: ArrowBack(),
                  //     center: Container(),
                  //     trailing: Container(),
                  //   ),
                  // ),
                  SizedBox(
                    height: height * 10,
                  ),
                  Center(
                    child: Image.asset('assets/images/logo.png'),
                  ),
                  SizedBox(
                    height: height * 30,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputFeild(
                        secure: false,
                        hinntText: 'New Password',
                        validatior: (String value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          if (value.length < 6) {
                            return 'Must contain 6 character';
                          }
                        },
                        inputController: _newPassController),
                  ),
                  SizedBox(
                    height: height * 1,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: InputFeild(
                        secure: false,
                        hinntText: 'Confirm Password',
                        validatior: (String value) {
                          if (value.isEmpty) {
                            return '';
                          }
                          if (value.toString() != _newPassController.text) {
                            return 'Password didnot match';
                          }
                        },
                        inputController: _confirmPassController),
                  ),
                  SizedBox(
                    height: height * 2,
                  ),
                  GestureDetector(
                    onTap: _submit,
                    child: Container(
                      height: currentOrientation == Orientation.landscape
                          ? height * 10
                          : height * 5,
                      width: currentOrientation == Orientation.landscape
                          ? width * 40
                          : width * 60,
                      margin: const EdgeInsets.only(top: 15),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      // padding: const EdgeInsets.symmetric(
                      //     horizontal: 60, vertical: 16),
                      child: isLoading
                          ? AdaptiveIndecator(
                              color: Colors.white,
                            )
                          : const Center(
                              child: Text(
                                'Change Password',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              ),
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
