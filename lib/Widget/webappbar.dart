import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Auth/Login/login.dart';
import 'package:anees_costing/Screen/Common/profile.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/snakbar.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Functions/buildlisttile.dart';
import '../Functions/dailog.dart';
import '../Functions/popup.dart';

class WebAppbar extends StatefulWidget {
  WebAppbar({
    required this.title,
    required this.subTitle,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  String title;
  String subTitle;
  Function onChanged;

  @override
  State<WebAppbar> createState() => _WebAppbarState();
}

class _WebAppbarState extends State<WebAppbar> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  int index = 0;
  bool isLoading = false;
  CurrentUser? currentUser;
  @override
  void initState() {
    super.initState();
  }

  void _nameChange() {
    setState(() {
      isLoading = true;
    });
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      setState(() {
        isLoading = false;
      });
      showMySnackBar(context: context, text: 'Error : Empty Feilds');
    } else {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .changeUserName(
              name: '${_firstNameController.text} ${_lastNameController.text}',
              userId: currentUser!.id,
              phone: currentUser!.phone,
              userToken: currentUser!.token)
          .then((value) {
        showMySnackBar(context: context, text: 'User : Username Changed');
        Provider.of<Auth>(context, listen: false).setName(
            '${_firstNameController.text} ${_lastNameController.text}');
        ;
        _firstNameController.clear();

        _lastNameController.clear();
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        showCustomDialog(
            context: context,
            title: 'Error',
            btn1: 'Okay',
            content: error.toString(),
            btn1Pressed: () {
              Navigator.of(context).pop();
            });
      });
    }
  }

  void _passwordChange() {
    print(123);
    if (_newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Empty Feilds'),
      ));
    } else if (_newPasswordController.text.toLowerCase() !=
        _confirmPasswordController.text.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Password didnot match'),
      ));
    } else {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .changePassword(
        userId: currentUser!.id,
        password: _newPasswordController.text.trim(),
        userToken: currentUser!.token,
      )
          .then((value) {
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        showMySnackBar(context: context, text: 'User : Password Changed');
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        showCustomDialog(
            context: context,
            title: 'Error',
            btn1: 'Okay',
            content: error.toString(),
            btn1Pressed: () {
              Navigator.of(context).pop();
            });
      });
    }
  }

  void showChangeDailog() {
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
    _emailController.text = currentUser!.email;
    showDialog(
      context: context,
      builder: ((ctx) => StatefulBuilder(
            builder: ((context, setState) => AlertDialog(
                  content: Container(
                    width: width * 50,
                    height: height * 70,
                    child: ListView(
                      children: [
                        SizedBox(
                          height: height * 2,
                        ),
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: btnbgColor.withOpacity(1),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  )),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.asset(
                                  'assets/images/person22.jpeg',
                                  height: height * 13,
                                  width: height * 13,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 1.5,
                        ),
                        Text(
                          Provider.of<Auth>(context, listen: true)
                              .currentUser!
                              .name!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.righteous(
                            color: headingColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.2,
                        ),
                        Text(
                          '( ${currentUser!.role} )',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: contentColor, fontSize: 12),
                        ),
                        SizedBox(
                          height: height * 4,
                        ),
                        Container(
                          // margin: EdgeInsets.symmetric(horizontal: width * 15),
                          height: height * 5,
                          //  width: width * 70,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: primaryColor,
                                width: 0,
                                style: BorderStyle.solid),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                  });
                                },
                                child: Container(
                                    width: width * 25,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                        gradient: index == 0
                                            ? customGradient
                                            : const LinearGradient(colors: [
                                                Colors.transparent,
                                                Colors.transparent
                                              ]),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  94, 89, 89, 0.11),
                                              offset: Offset(0, 10),
                                              blurRadius: 20),
                                        ]),
                                    child: Center(
                                      child: Text(
                                        'Change Name',
                                        style: TextStyle(
                                            color: index == 0
                                                ? Colors.white
                                                : headingColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    index = 1;
                                  });
                                },
                                child: Container(
                                    width: width * 25,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                        gradient: index == 1
                                            ? customGradient
                                            : const LinearGradient(colors: [
                                                Colors.transparent,
                                                Colors.transparent
                                              ]),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        'Change Password',
                                        style: TextStyle(
                                            color: index == 1
                                                ? Colors.white
                                                : headingColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 3,
                        ),
                        if (index == 0)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _nameFormKey,
                              child: Column(
                                children: [
                                  InputFeild(
                                      readOnly: true,
                                      hinntText: 'Email here',
                                      validatior: (String value) {
                                        if (value.isEmpty) {
                                          return '';
                                        }
                                      },
                                      inputController: _emailController),
                                  SizedBox(
                                    height: height * 2,
                                  ),
                                  SizedBox(
                                    child: InputFeild(
                                        textInputAction: TextInputAction.next,
                                        hinntText: 'First Name',
                                        validatior: (String value) {
                                          if (value.isEmpty) {
                                            return '';
                                          }
                                        },
                                        inputController: _firstNameController),
                                  ),
                                  SizedBox(
                                    height: height * 2,
                                  ),
                                  InputFeild(
                                      textInputAction: TextInputAction.done,
                                      hinntText: 'Last Name',
                                      validatior: (String value) {
                                        if (value.isEmpty) {
                                          return '';
                                        }
                                      },
                                      inputController: _lastNameController),
                                  SizedBox(
                                    height: height * 5,
                                  ),
                                  isLoading
                                      ? Center(
                                          child: AdaptiveIndecator(
                                            color: primaryColor,
                                          ),
                                        )
                                      : SubmitButton(
                                          onTap: _nameChange,
                                          height: height,
                                          width: width,
                                          title: 'Change Name'),
                                ],
                              ),
                            ),
                          ),
                        if (index == 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Form(
                              key: _passwordFormKey,
                              child: Column(
                                children: [
                                  InputFeild(
                                      textInputAction: TextInputAction.next,
                                      hinntText: 'New Password',
                                      validatior: (String value) {
                                        if (value.isEmpty) {
                                          return '';
                                        }
                                        if (value.length < 6) {
                                          return 'Must contain 6 characters';
                                        }
                                      },
                                      inputController: _newPasswordController),
                                  SizedBox(
                                    height: height * 2,
                                  ),
                                  InputFeild(
                                      textInputAction: TextInputAction.done,
                                      hinntText: 'Confirm New Password',
                                      validatior: (String value) {
                                        if (value.isEmpty) {
                                          return 'password didnot match';
                                        }
                                        if (value !=
                                            _newPasswordController.text
                                                .trim()) {
                                          return 'password didnot match';
                                        }
                                      },
                                      inputController:
                                          _confirmPasswordController),
                                  SizedBox(
                                    height: height * 5,
                                  ),
                                  isLoading
                                      ? Center(
                                          child: AdaptiveIndecator(
                                              color: primaryColor),
                                        )
                                      : SubmitButton(
                                          onTap: _passwordChange,
                                          height: height,
                                          width: width,
                                          title: 'Change Password'),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<Auth>(context, listen: true).currentUser;
    var languageProvider = Provider.of<Language>(context, listen: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 9,
              child: Text(
                widget.title,
                style: GoogleFonts.righteous(fontSize: 32, color: primaryColor),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          showPopupMenu(context: context, popups: [
                            PopupMenuItem(
                              child: buildListTile(
                                  leadingIcon: Icons.badge_outlined,
                                  title: languageProvider.get('Profile'),
                                  subTitle: languageProvider
                                      .get('Change your name and Password'),
                                  onTap: showChangeDailog),
                            ),
                            PopupMenuItem(
                              child: buildListTile(
                                  leadingIcon: Icons.logout_outlined,
                                  title: languageProvider.get('Logout'),
                                  subTitle: languageProvider
                                      .get('Logout from Aness casting'),
                                  onTap: () {
                                    showCustomDialog(
                                        context: context,
                                        title: languageProvider.get('Logout'),
                                        content: languageProvider.get(
                                          'Click on the logout button to proceed',
                                        ),
                                        btn1: languageProvider.get('Logout'),
                                        btn1Pressed: () {
                                          Provider.of<Auth>(context,
                                                  listen: false)
                                              .logout();
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  LoginScreen.routeName);
                                        },
                                        btn2: languageProvider.get('Cancel'),
                                        btn2Pressed: () {
                                          Navigator.of(context).pop();
                                        });
                                  }),
                            ),
                          ]);
                        });
                      },
                      child: Container(
                          height: 43,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          decoration: BoxDecoration(
                              // gradient: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                    offset: Offset(0, 1)),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: btnbgColor.withOpacity(1),
                                    radius: 16,
                                    child: const Text(
                                      'T',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    Provider.of<Auth>(context, listen: false)
                                        .currentUser!
                                        .email,
                                    style: TextStyle(color: contentColor),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Icon(
                                    Icons.expand_more,
                                    color: primaryColor,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
                    Container(
                      width: width(context) * 2,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        languageProvider.setLang(language.English);
                      },
                      child: Text(
                        "abc",
                        style: TextStyle(
                            color:
                                languageProvider.currentLang == language.English
                                    ? primaryColor
                                    : contentColor),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        languageProvider.setLang(language.Urdu);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: Text(
                          "اردو",
                          style: TextStyle(
                              color:
                                  languageProvider.currentLang == language.Urdu
                                      ? primaryColor
                                      : contentColor),
                        ),
                      ),
                    ),
                    Container(
                      width: width(context) * 2,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        Text(
          widget.subTitle,
          style: TextStyle(color: contentColor),
        ),
      ],
    );
  }
}
