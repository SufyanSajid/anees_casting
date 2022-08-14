import 'dart:io';

// import 'package:chiarra_fazzini/Models/auth.dart';
import 'package:anees_costing/Screen/Admin/homepage/mobile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../Models/auth.dart';
import '../../Models/product.dart';
import '../../Widget/adaptiveDialog.dart';
import '../../Widget/adaptive_indecator.dart';
import '../../Widget/input_feild.dart';
import '../../Widget/submitbutton.dart';
import '../../contant.dart';

import 'package:flutter/material.dart';

import '../Admin/homepage/admin_home.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final _firebaseMessaging = FirebaseMessaging.instance;
  final _emailController = TextEditingController();

  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool isSecure = true;
  bool isLoading = false;

  void _submit() async {
    print('sufyan');
    setState(() {
      isLoading = true;
    });
    Provider.of<Auth>(context, listen: false)
        .login(_emailController.text.trim(), _passController.text.trim())
        .then((value) async {
      setState(() {
        isLoading = false;
      });
      CurrentUser currentUser =
          Provider.of<Auth>(context, listen: false).currentUser!;
      Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) => AdaptiveDiaglog(
              ctx: ctx,
              title: '❌',
              content: error.toString(),
              btnYes: 'Okay',
              yesPressed: () {
                Navigator.of(context).pop();
              }));
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: width,
              height: height * 100,
              child: Stack(
                children: [
                  Container(
                      height: height * 50,
                      width: width,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                              'https://cdn.vectorstock.com/i/1000x1000/24/40/blue-dna-medical-and-healthcare-background-vector-37962440.webp',
                            ),
                            fit: BoxFit.cover),
                      )),
                  Container(
                    height: height * 50,
                    width: width,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                  Container(
                    height: height * 60,
                    width: width,
                    child: Center(
                      child: Text(
                        'Anees Casting',
                        style: GoogleFonts.titanOne(
                            fontSize: 54, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ), //logo container
            Positioned(
              top: height * 43,
              width: width,
              left: 0,
              height: height * 57,
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 5,
                        ),
                        Text(
                          'WelCome',
                          style: GoogleFonts.berkshireSwash(
                            fontSize: 54,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          height: height * 4,
                        ),
                        InputFeild(
                          textInputAction: TextInputAction.next,
                          hinntText: 'Enter Email Address',
                          validatior: (String value) {
                            if (value.isEmpty) {
                              return "Enter email address !";
                            }

                            return null;
                          },
                          inputController: _emailController,
                        ),
                        SizedBox(
                          height: height * 2,
                        ),
                        InputFeild(
                          textInputAction: TextInputAction.done,
                          secure: isSecure,
                          hinntText: 'Enter Password',
                          validatior: (String value) {
                            if (value.isEmpty) {
                              return 'Enter your password';
                            }
                            return null;
                          },
                          suffix: isVisible
                              ? Icons.visibility
                              : Icons.visibility_outlined,
                          suffixPress: () {
                            setState(() {
                              //   print('shani');
                              isSecure = !isSecure;
                              isVisible = !isVisible;
                            });
                          },
                          inputController: _passController,
                        ),
                        SizedBox(
                          height: height * 2,
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.of(context)
                              //     .pushNamed(ForgetScreen.routeName);
                            },
                            child: Text(
                              'Forget Password!',
                              style:
                                  TextStyle(color: primaryColor, fontSize: 13),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height * 1,
                        ),
                        isLoading
                            ? Center(
                                child: AdaptiveIndecator(color: primaryColor),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: SubmitButton(
                                    height: height,
                                    width: width,
                                    title: 'Login',
                                    onTap: () {
                                      if (_emailController.text
                                              .trim()
                                              .isEmpty ||
                                          _passController.text.trim().isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Empty Feilds: Please enter required info',
                                            ),
                                          ),
                                        );
                                      } else {
                                        _submit();
                                      }
                                    }),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //feild conatiners
          ],
        ),
      ),
    );
  }
}
