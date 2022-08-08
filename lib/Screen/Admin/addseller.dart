import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/dropDown.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget {
  static const routeName = '/adduser';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  AddUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'User',
                subtitle: 'Add New User',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 2,
              ),
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
                        'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
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
                        items: [
                          'Customer',
                          'Seller',
                          'Admin',
                        ],
                        onChanged: (value) {},
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
                  suffix: Icons.password_outlined,
                  hinntText: 'Password',
                  validatior: () {},
                  inputController: _passwordController),
              SizedBox(
                height: height(context) * 5,
              ),
              SubmitButton(
                  height: height(context),
                  width: width(context),
                  onTap: () {},
                  title: 'Add User')
            ],
          ),
        ),
      ),
    );
  }
}
