import 'dart:convert';
import 'dart:io';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/firebase_auth.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/Widget/snakbar.dart';
import 'package:provider/provider.dart';
import '../../../Models/language.dart';
import '/Helpers/show_snackbar.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/Widget/dropDown.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  static const routeName = '/adduser';

  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFirst = true;
  String action = '';
  AUser? user;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      var routeData =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      action = routeData['action'];
      if (action == 'edit') {
        user = routeData['data'];
      }
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
            width: (Platform.isMacOS || Platform.isWindows)
                ? width(context) * 50
                : width(context) * 100,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appbar(
                //   title: 'User',
                //   subtitle: 'Add New User',
                //   svgIcon: 'assets/icons/users.svg',
                //   leadingIcon: Icons.arrow_back,
                //   leadingTap: () {
                //     Navigator.of(context).pop();
                //   },
                //   tarilingIcon: Icons.filter_list,
                //   tarilingTap: () {
                //     _scaffoldKey.currentState!.openDrawer();
                //   },
                // ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 5),
                              blurRadius: 5),
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back,
                      color: btnbgColor.withOpacity(1),
                    ),
                  ),
                ),
                SizedBox(
                  height: height(context) * 2,
                ),
                Expanded(
                  child: ListView(
                    children: [
                      SizedBox(
                        height: height(context) * 2,
                      ),
                      AddUserFeilds(
                        action: action,
                        user: user,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddUserFeilds extends StatefulWidget {
  AddUserFeilds({
    Key? key,
    this.action,
    this.user,
  }) : super(key: key);

  AUser? user;
  String? action;
  @override
  State<AddUserFeilds> createState() => _AddUserFeildsState();
}

class _AddUserFeildsState extends State<AddUserFeilds> {
  AUser? drawerUser;
  bool isFirst = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  CurrentUser? currentUser;

  String role = "Customer";
  bool isLoading = false;
  bool isPassSecure = true;

  void _editUser(Language langProvider) async {
    setState(() {
      isLoading = true;
    });

    if (role.toLowerCase() != widget.user!.role.toLowerCase()) {
      Provider.of<Users>(context, listen: false).updateUserRole(
        userId: widget.user!.id,
        userToken: currentUser!.token,
        userRole: role,
      );
    }
    if (_passwordController.text.isNotEmpty) {
      Provider.of<Auth>(context, listen: false).changePassword(
        password: _passwordController.text.trim(),
        userId: widget.user!.id,
        userToken: currentUser!.token,
      );
    }
    await Provider.of<Users>(context, listen: false)
        .editrUser(
      userId: widget.user!.id,
      userName: _nameController.text.trim(),
      userPhone: _phoneController.text.trim(),
      userToken: currentUser!.token,
    )
        .then((value) {
      AUser newUser = AUser(
        id: widget.user!.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        role: role,
      );
      showMySnackBar(
          context: context,
          text: langProvider.get('User Data has been Updated'));
      Provider.of<Users>(context, listen: false).updateUserLocally(newUser);
      Provider.of<Users>(context, listen: false)
          .fetchAndUpdateUser(userToken: currentUser!.token);

      setState(() {
        isLoading = false;
      });
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
        },
      );
    });
  }

  void _sigUpUser(Language langProvider) async {
    setState(() {
      isLoading = true;
    });
    var userId;
    Provider.of<Users>(context, listen: false)
        .createUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim())
        .then((value) async {
      userId = value;
      await Provider.of<Users>(context, listen: false).updateUserRole(
          userId: value.toString(),
          userRole: role,
          userToken: currentUser!.token);

      AUser newUser = AUser(
        id: userId,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        role: role,
      );
      showMySnackBar(
          context: context, text: langProvider.get('User has been Added'));
      // Provider.of<Users>(context, listen: false)
      //     .fetchAndUpdateUser(userToken: currentUser!.token);
      Provider.of<Users>(context, listen: false).updateUserLocally(newUser);
      setState(() {
        isLoading = false;
      });
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _passwordController.clear();
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
        },
      );
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    // TODO: implement initState
    if (widget.action == 'edit') {
      _nameController.text = widget.user!.name;
      print(_nameController.text);
      _emailController.text = widget.user!.email;
      _phoneController.text = widget.user!.phone;
      setState(() {});
    } else {
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst && widget.user == null) {
      isFirst = false;

      drawerUser = Provider.of<Users>(context, listen: false).drawerUser;

      if (drawerUser != null) {
        _nameController.text = drawerUser!.name;
        _emailController.text = drawerUser!.email;
        _phoneController.text = drawerUser!.phone;
      } else {
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _phoneController.clear();
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.5),
                width: 2,
                style: BorderStyle.solid,
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              'assets/images/person22.jpeg',
              height: height(context) * 12,
              width: height(context) * 12,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: height(context) * 5,
        ),
        Row(
          children: [
            Expanded(
              flex: 7,
              child: InputFeild(
                  hinntText: languageProvider.get('Name'),
                  validatior: () {},
                  inputController: _nameController),
            ),
            SizedBox(
              width: width(context) * 3,
            ),
            Expanded(
              flex: 5,
              child: CustomDropDown(
                items: [
                  'Customer',
                  'Admin',
                  'Seller',
                ],
                firstSelect: widget.action == 'edit'
                    ? widget.user!.role
                    : '',
                onChanged: (value) {
                  print(value);
                  role = value;
                },
              ),
            )
          ],
        ),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
            suffix: Icons.email_outlined,
            hinntText: languageProvider.get('Email'),
            readOnly: widget.action == 'edit' ? true : false,
            validatior: () {},
            inputController: _emailController),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
            suffix: Icons.phone_outlined,
            hinntText: languageProvider.get('Phone'),
            validatior: () {},
            inputController: _phoneController),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
            secure: isPassSecure ? true : false,
            suffix: isPassSecure ? Icons.visibility_outlined : Icons.visibility,
            suffixPress: () {
              setState(() {
                isPassSecure = !isPassSecure;
              });
            },
            hinntText: languageProvider.get('Password'),
            validatior: () {},
            inputController: _passwordController),
        SizedBox(
          height: height(context) * 5,
        ),
        isLoading
            ? AdaptiveIndecator(
                color: primaryColor,
              )
            : Container(
                child: SubmitButton(
                    height: height(context),
                    width: width(context),
                    onTap: () => widget.action == 'edit'
                        ? _editUser(languageProvider)
                        : _sigUpUser(languageProvider),
                    title: widget.action == 'edit'
                        ? languageProvider.get('Edit User')
                        : languageProvider.get('Add User')),
              )
      ],
    );
  }
}
