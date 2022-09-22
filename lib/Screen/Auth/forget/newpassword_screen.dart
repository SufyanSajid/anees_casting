import 'package:flutter/material.dart';

import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/input_feild.dart';

class NewPassScreen extends StatefulWidget {
  static const routeName = 'new-password-screem';
  NewPassScreen({Key? key}) : super(key: key);

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
    // TODO: implement didChangeDependencies
    data = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    super.didChangeDependencies();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      //   setState(() {
      //     isLoading = true;
      //   });
      //   Provider.of<Auth>(context, listen: false)
      //       .forgetChangePassword(
      //           data['email'], data['code'], _newPassController.text)
      //       .then((value) {
      //     setState(() {
      //       isLoading = false;
      //     });
      //     showDialog(
      //         context: context,
      //         builder: (ctx) => AdaptiveDiaglog(
      //             ctx: ctx,
      //             title: '✅',
      //             content: 'Password modificata Prova ad accedere con successo',
      //             btnYes: 'OK',
      //             yesPressed: () {
      //               Navigator.of(context)
      //                   .pushReplacementNamed(LoginScreen.routeName);
      //             }));
      //   }).catchError((error) {
      //     showDialog(
      //         context: context,
      //         builder: (ctx) => AdaptiveDiaglog(
      //             ctx: ctx,
      //             title: '❌',
      //             content: error.toString(),
      //             btnYes: 'OK',
      //             yesPressed: () {
      //               Navigator.of(context).pop();
      //             }));
      //   });
      // }
    }

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
              'assets/images/background.png',
            ),
          ),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
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
                          hinntText: 'Inserire una nuova password',
                          validatior: (String value) {
                            if (value.isEmpty) {
                              return 'Per favore, inserisci la password';
                            }
                            if (value.length < 6) {
                              return 'La password deve contenere 6 caratteri';
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
                          hinntText: 'Conferma password',
                          validatior: (String value) {
                            if (value.isEmpty) {
                              return 'Per favore, inserisci la password';
                            }
                            if (value.toString() != _newPassController.text) {
                              return 'La password non corrisponde';
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
                                  'Cambia la password',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
