// import 'package:chiarra_fazzini/Models/auth.dart';
import 'dart:convert';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Customer/customer_home.dart';
import 'package:anees_costing/Screen/Customer/all_cat_prod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Models/activitylogs.dart';
import '../../../Models/auth.dart';
import '../../../Widget/adaptiveDialog.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/input_feild.dart';
import '../../../Widget/submitbutton.dart';
import '../../../contant.dart';

import 'package:flutter/material.dart';

import '../../Admin/homepage/admin_home.dart';
import '../forget/forget_screen.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({Key? key}) : super(key: key);

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  final _formKey = GlobalKey<FormState>();

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
                            image: AssetImage(
                              'assets/images/poster.jpeg',
                            ),
                            fit: BoxFit.cover),
                      )),
                  Container(
                    height: height * 50,
                    width: width,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.8)),
                  ),
                  Positioned(
                      left: 100,
                      top: 100,
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: height * 20,
                        fit: BoxFit.contain,
                      )),
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
                        const LoginFeilds(),
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

class LoginFeilds extends StatefulWidget {
  const LoginFeilds({Key? key}) : super(key: key);

  @override
  State<LoginFeilds> createState() => _LoginFeildsState();
}

class _LoginFeildsState extends State<LoginFeilds> {
  // final _firebaseMessaging = FirebaseMessaging.instance;
  final _emailController = TextEditingController();

  final _passController = TextEditingController();

  bool isVisible = false;

  bool isSecure = true;

  bool isLoading = false;

  void _submit(Language languageProvider) async {
    setState(() {
      isLoading = true;
    });
    await Provider.of<Auth>(context, listen: false)
        .LoginWithEmailAndPassword(
            _emailController.text.trim(), _passController.text.trim())
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }).then((value) async {
      final DateTime now = DateTime.now();
      final DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
      final DateFormat timeFormatter = DateFormat('h:mm a');
      final String day = dayFormatter.format(now);
      final String time = timeFormatter.format(now);

      CurrentUser currentUser =
          Provider.of<Auth>(context, listen: false).currentUser!;
      Provider.of<Logs>(context, listen: false).addLog(
          log: Log(
              id: DateTime.now().microsecond.toString(),
              userid: currentUser.id,
              userName: currentUser.name!,
              content: '${currentUser.name} Loged in at ${time} on ${day}',
              logType: 'Activity'),
          userToken: currentUser.token);

      if (currentUser.role!.toLowerCase() == 'customer') {
        Navigator.of(context)
            .pushReplacementNamed(CustomerHomeScreen.routeName);
      } else {
        Navigator.of(context).pushReplacementNamed(AdminHomePage.routeName);
      }
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      showCustomDialog(
          context: context,
          title: languageProvider.get('Error'),
          btn1: languageProvider.get('OK'),
          content: error.toString(),
          btn1Pressed: () {
            Navigator.of(context).pop();
          });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context, listen: true);
    return Column(
      children: [
        InputFeild(
          textInputAction: TextInputAction.next,
          hinntText: languageProvider.get('Enter Your Email'),
          validatior: (String value) {
            if (value.isEmpty) {
              return languageProvider.get('Enter Your Email');
            }

            return null;
          },
          inputController: _emailController,
        ),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
          textInputAction: TextInputAction.done,
          secure: isSecure,
          hinntText: languageProvider.get('Enter Password'),
          validatior: (String value) {
            if (value.isEmpty) {
              return languageProvider.get('Enter Password');
            }
            return null;
          },
          suffix: isVisible ? Icons.visibility : Icons.visibility_outlined,
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
          height: height(context) * 2,
        ),
        Container(
          alignment: Alignment.bottomRight,
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                ForgetScreen.routeName,
              );
            },
            child: Text(
              languageProvider.get('Forget Password'),
              style: TextStyle(color: primaryColor, fontSize: 13),
            ),
          ),
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        isLoading
            ? Center(
                child: AdaptiveIndecator(color: primaryColor),
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: SubmitButton(
                    height: height(context),
                    width: width(context),
                    title: languageProvider.get('Login'),
                    onTap: () {
                      if (_emailController.text.trim().isEmpty ||
                          _passController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              languageProvider.get("please fill all fields"),
                            ),
                          ),
                        );
                      } else {
                        _submit(languageProvider);
                      }
                    }),
              ),
      ],
    );
  }
}
