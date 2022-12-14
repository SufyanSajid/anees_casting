import 'dart:io';

import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Auth/forget/verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Functions/dailog.dart';
import '../../../Models/auth.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';
import '../../../Widget/input_feild.dart';
import '../../../contant.dart';

class ForgetScreen extends StatefulWidget {
  static const routeName = '/forget-screen';

  ForgetScreen({Key? key}) : super(key: key);

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isFirst = true;
  var data;

  void _submit(Language langProvider) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .resetPassword(_emailController.text.trim())
          .then((value) {
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pushNamed(VerificationScreen.routeName,
            arguments: _emailController.text);
        _emailController.clear();
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        showCustomDialog(
            context: context,
            title: langProvider.get('Error'),
            btn1: langProvider.get('OK'),
            content: error.toString(),
            btn1Pressed: () {
              Navigator.of(context).pop();
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context, listen: true);
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.black.withOpacity(0.8),
          body: Center(
            child: Container(
              width: Platform.isAndroid || Platform.isIOS
                  ? double.infinity
                  : width * 50,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    SizedBox(
                      height: height * 10,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/log0_final.png',
                        fit: BoxFit.cover,
                        height: height * 17,
                      ),
                    ),
                    SizedBox(
                      height: height * 30,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: InputFeild(
                                hinntText: languageProvider.get('Enter Your Email'),
                                validatior: (String value) {
                                  if (value.isEmpty) {
                                    return '';
                                  }
                                },
                                inputController: _emailController),
                          ),
                          SizedBox(
                            height: height * 2,
                          ),
                          GestureDetector(
                            onTap:()=> _submit(languageProvider),
                            child: Container(
                              height:
                                  currentOrientation == Orientation.landscape
                                      ? height * 5
                                      : height * 5,
                              width: currentOrientation == Orientation.landscape
                                  ? width * 15
                                  : width * 60,
                              margin: const EdgeInsets.only(top: 15),
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: primaryColor),
                              // padding:isLoading?EdgeInsets.symmetric(horizontal: 0,vertical: 16): const EdgeInsets.symmetric(
                              //     horizontal: 60, vertical: 16),
                              child: isLoading
                                  ? AdaptiveIndecator(
                                      color: Colors.white,
                                    )
                                  : Center(
                                      child: FittedBox(
                                        child: Text(
                                          languageProvider.get('Forget Password') ,
                                          style: TextStyle(
                                        fontFamily: languageProvider.currentLang == language.English?'Poppins':null,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
