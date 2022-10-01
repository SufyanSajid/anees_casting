import 'dart:io';

import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Auth/forget/newpassword_screen.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Functions/dailog.dart';
import '../../../Models/auth.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/input_feild.dart';

class VerificationScreen extends StatefulWidget {
  static const routeName = '/verify-screen';

  VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFirst = true;
  bool isLoading = false;
  String email = '';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      email = ModalRoute.of(context)!.settings.arguments as String;
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _submit(Language langProvider) {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .verifyCode(email: email, code: _codeController.text.trim())
          .then((value) {
        print(value);
        print(email);
        if (value == true) {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context)
              .pushReplacementNamed(NewPassScreen.routeName, arguments: {
            'email': email,
            'code': _codeController.text,
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showCustomDialog(
              context: context,
              title: langProvider.get('Code'),
              btn1: langProvider.get('OK'),
              content: langProvider.get("Icorrect Code"),
              btn1Pressed: () {
                Navigator.of(context).pop();
              });
        }
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
          body: Form(
            key: _formKey,
            child: Center(
              child: Container(
                width: Platform.isAndroid || Platform.isIOS
                    ? double.infinity
                    : width * 50,
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
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: height * 17,
                        ),
                      ),
                      SizedBox(
                        height: height * 26,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            languageProvider.get(
                                'Enter the 6-digit code that is sent to your email address'),
                            style: TextStyle(
                                color: btnbgColor.withOpacity(1), fontSize: 14),
                          )),
                      SizedBox(
                        height: height * 2,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InputFeild(
                            hinntText: languageProvider.get('Code here'),
                            validatior: (String value) {
                              if (value.isEmpty) {
                                languageProvider.get(
                                    'Enter the 6-digit code that is sent to your email address');
                              }
                              if (value.length > 6) {
                                return languageProvider.get('Invalid Code');
                              
                              }
                            },
                            inputController: _codeController),
                      ),
                      SizedBox(
                        height: height * 2,
                      ),
                      GestureDetector(
                        onTap:()=> _submit(languageProvider),
                        child: Container(
                          height: currentOrientation == Orientation.landscape
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
                          child: isLoading
                              ? AdaptiveIndecator(
                                  color: Colors.white,
                                )
                              : Center(
                                  child: FittedBox(
                                    child: Text(
                                     languageProvider.get('Verify Code') ,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: languageProvider.currentLang == language.English? 'Poppins': null,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
