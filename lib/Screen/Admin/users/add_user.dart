import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/firebase_auth.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:provider/provider.dart';
import '/Helpers/show_snackbar.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/Widget/dropDown.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  static const routeName = '/adduser';

  AddUser({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Appbar(
                title: 'User',
                subtitle: 'Add New User',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: height(context) * 2,
                    ),
                    const AddUserFeilds(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddUserFeilds extends StatefulWidget {
  const AddUserFeilds({Key? key}) : super(key: key);

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

  void _sigUpUser() async {
    setState(() {
      isLoading = true;
    });
    Provider.of<Users>(context, listen: false)
        .createUser(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text.trim())
        .then((value) async {
      print('yeh h userId $value');
      await Provider.of<Users>(context, listen: false).updateUserRole(
          userId: value.toString(),
          userRole: role,
          userToken: currentUser!.token);
      await Provider.of<Users>(context, listen: false)
          .fetchAndUpdateUser(userToken: currentUser!.token);
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
        title: 'Error',
        btn1: 'Okay',
        content: error.toString(),
        btn1Pressed: () {
          _nameController.clear();
          _emailController.clear();
          _phoneController.clear();
          _passwordController.clear();
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
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
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
                  hinntText: 'Name',
                  validatior: () {},
                  inputController: _nameController),
            ),
            SizedBox(
              width: width(context) * 3,
            ),
            Expanded(
                flex: 5,
                child: CustomDropDown(
                  items: const [
                    'Customer',
                    'Seller',
                    'Admin',
                  ],
                  onChanged: (value) {
                    role = value;
                  },
                ))
          ],
        ),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
            suffix: Icons.email_outlined,
            hinntText: 'Email',
            validatior: () {},
            inputController: _emailController),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
            suffix: Icons.phone_outlined,
            hinntText: 'Phone',
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
            hinntText: 'Password',
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
                    onTap: () {
                      _sigUpUser();
                    },
                    title: 'Add User'),
              )
      ],
    );
  }
}
