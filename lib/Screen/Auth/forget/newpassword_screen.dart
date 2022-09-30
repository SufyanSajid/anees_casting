import 'dart:io';

import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/auth.dart';
import '../../../Widget/adaptiveDialog.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/input_feild.dart';
import '../Login/login.dart';

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

  var data;
  bool isFirst = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
          .forgetChangePassword(
              email: data['email'],
              code: data['code'],
              password: _newPassController.text)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        showDialog(
            context: context,
            builder: (ctx) => AdaptiveDiaglog(
                ctx: ctx,
                title: '✅',
                content: langProvider.get('Password Changed Try Login'),
                btnYes: langProvider.get('OK'),
                yesPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                }));
      }).catchError((error) {
        showDialog(
            context: context,
            builder: (ctx) => AdaptiveDiaglog(
                ctx: ctx,
                title: '❌',
                content: error.toString(),
                btnYes: langProvider.get('OK'),
                yesPressed: () {
                  Navigator.of(context).pop();
                }));
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
          backgroundColor: Colors.black.withOpacity(0.8),
          appBar: AppBar(backgroundColor: Colors.transparent),
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
                        child: Image.asset('assets/images/logo.png'),
                      ),
                      SizedBox(
                        height: height * 30,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InputFeild(
                            secure: false,
                            hinntText:languageProvider.get('New Password') ,
                            validatior: (String value) {
                              if (value.isEmpty) {
                                return '';
                              }
                              if (value.length < 6) {
                                return languageProvider.get('Must contains 6 character') ;
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
                            hinntText: languageProvider.get('Confirm Password') ,
                            validatior: (String value) {
                              if (value.isEmpty) {
                                return '';
                              }
                              if (value.toString() != _newPassController.text) {
                                return languageProvider.get('Password is not matched') ;
                              }
                            },
                            inputController: _confirmPassController),
                      ),
                      SizedBox(
                        height: height * 2,
                      ),
                      GestureDetector(
                        onTap:()=> _submit(languageProvider),
                        child: Container(
                          alignment: Alignment.center,
                          height: currentOrientation == Orientation.landscape
                              ? height * 5
                              : height * 5,
                          width: currentOrientation == Orientation.landscape
                              ? width * 15
                              : width * 60,
                          margin: const EdgeInsets.only(top: 15),
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                              : FittedBox(
                                  child: Text(
                                   languageProvider.get('Change Password') ,
                                    style: TextStyle(

                                        fontFamily: languageProvider.currentLang == language.English?'Poppins':null,
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
        ),
      ),
    );
  }
}
