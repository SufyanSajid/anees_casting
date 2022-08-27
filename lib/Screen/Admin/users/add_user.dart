import 'package:anees_costing/Helpers/firebase_auth.dart';
import 'package:anees_costing/Models/user.dart';
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

  const AddUser({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              AddUserFeilds(),
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

  String role = "Customer";
  bool isLoading = false;
  _sigUpUser() async {
    setState(() {
      isLoading = true;
    });
    BuildContext ctx = context;
    await FirebaseAuth().createNewUser(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: role,
        image:
            "https://images.unsplash.com/photo-1659976057522-817791f9bf3f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwyfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim());

    //clear controllers
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _passwordController.clear();
    role = "Customer";
    showSnackBar(ctx, "User is added");
    setState(() {
      isLoading = false;
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
    // TODO: implement didChangeDependencies
    if (isFirst) {
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
    return Column(
      children: [
        Stack(
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
                child: Image.network(
                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png',
                  height: height(context) * 12,
                  width: height(context) * 12,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
                right: 0,
                bottom: -10,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      color: primaryColor,
                      size: 30,
                    ))),
          ],
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
            secure: true,
            suffix: Icons.password_outlined,
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
