import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _CurrentPassword = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  bool isLoading = false;

  void _nameChange() {}

  void _passwordChange() {
    print('password');
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Appbar(
                    title: 'Profile',
                    subtitle: 'Edit Your Profile',
                    svgIcon: 'assets/icons/profile.svg',
                    leadingIcon: Icons.arrow_back,
                    leadingTap: () {},
                    tarilingIcon: Icons.filter_list,
                    tarilingTap: () {
                      print('shano');
                      _scaffoldKey.currentState!.openDrawer();
                    }),
              ),
              SizedBox(
                height: height * 2,
              ),
              Stack(
                children: [
                  Container(
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
                      child: Image.network(
                        'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
                        height: height * 13,
                        width: height * 13,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Positioned(
                  //     right: 0,
                  //     bottom: -10,
                  //     child: IconButton(
                  //         onPressed: () {},
                  //         icon: Icon(
                  //           Icons.add_a_photo_outlined,
                  //           color: primaryColor,
                  //           size: 30,
                  //         )))
                ],
              ),
              SizedBox(
                height: height * 1.5,
              ),
              Text(
                'Sufyan Sajid',
                style: GoogleFonts.righteous(
                  color: headingColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: height * 5,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 60),
                height: height * 5,
                width: width * 70,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: primaryColor, width: 0, style: BorderStyle.solid),
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              gradient: index == 0
                                  ? customGradient
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(94, 89, 89, 0.11),
                                    offset: Offset(0, 10),
                                    blurRadius: 20),
                              ]),
                          child: Center(
                            child: Text(
                              'Change Name',
                              style: TextStyle(
                                  color:
                                      index == 0 ? Colors.white : headingColor,
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
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              gradient: index == 1
                                  ? customGradient
                                  : LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent
                                    ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                  color:
                                      index == 1 ? Colors.white : headingColor,
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
                                onTap: () {},
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
                            hinntText: 'Current Password',
                            validatior: (String value) {
                              if (value.isEmpty) {
                                return '';
                              }
                            },
                            inputController: _CurrentPassword),
                        SizedBox(
                          height: height * 2,
                        ),
                        InputFeild(
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
                            hinntText: 'Confirm New Password',
                            validatior: (String value) {
                              if (value.isEmpty) {
                                return 'password didnot match';
                              }
                              if (value != _newPasswordController.text.trim()) {
                                return 'password didnot match';
                              }
                            },
                            inputController: _confirmPasswordController),
                        SizedBox(
                          height: height * 5,
                        ),
                        isLoading
                            ? Center(
                                child: AdaptiveIndecator(color: primaryColor),
                              )
                            : SubmitButton(
                                onTap: () {},
                                height: height,
                                width: width,
                                title: 'Change Password'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ));
  }
}
