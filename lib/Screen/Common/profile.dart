import 'package:anees_costing/Helpers/firebase_auth.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/counts.dart';
import '../../Widget/adaptive_indecator.dart';
import '../../Widget/drawer.dart';
import '../../Widget/input_feild.dart';
import '../../Widget/submitbutton.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profileScreen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  bool isLoading = false;
  var currentUser;
  @override
  void initState() {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;

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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error: Empty Feilds'),
      ));
    } else {
      setState(() {
        isLoading = true;
      });
      Provider.of<Auth>(context, listen: false)
          .changeUserName(
              name: '${_firstNameController.text} ${_lastNameController.text}',
              userId: currentUser.id,
              phone: currentUser.phone,
              userToken: currentUser!.token)
          .then((value) {
        Provider.of<Auth>(context, listen: false).currentUser!.name =
            '${_firstNameController.text} ${_lastNameController.text}';
        _firstNameController.clear();

        _lastNameController.clear();
        setState(() {
          isLoading = false;
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
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;

    _emailController.text = currentUser.email;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Appbar(
                    title: 'Profile',
                    subtitle: 'Edit Your Profile',
                    svgIcon: 'assets/icons/profile.svg',
                    leadingIcon: Icons.home,
                    leadingTap: () {
                      Provider.of<Counts>(context, listen: false)
                          .setSelectedIndex(0);
                    },
                    tarilingIcon: Icons.filter_list,
                    tarilingTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    }),
              ),
              Expanded(
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
                      currentUser.name!,
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
                      '( ${currentUser.role} )',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: contentColor, fontSize: 12),
                    ),
                    SizedBox(
                      height: height * 4,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 15),
                      height: height * 5,
                      width: width * 70,
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
                                width: width * 35,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                          color:
                                              Color.fromRGBO(94, 89, 89, 0.11),
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
                                width: width * 35,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    gradient: index == 1
                                        ? customGradient
                                        : const LinearGradient(colors: [
                                            Colors.transparent,
                                            Colors.transparent
                                          ]),
                                    borderRadius: BorderRadius.circular(30)),
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
                                        _newPasswordController.text.trim()) {
                                      return 'password didnot match';
                                    }
                                  },
                                  inputController: _confirmPasswordController),
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
            ],
          ),
        ));
  }
}
