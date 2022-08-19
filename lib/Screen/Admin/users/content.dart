import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Screen/Admin/users/users.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

import '../../../Widget/dropDown.dart';

class UserWebContent extends StatelessWidget {
  UserWebContent({Key? key, required this.scaffoldKey}) : super(key: key);
  final _usersController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFilterBar(
          context: context,
          searchConttroller: _usersController,
          btnTap: () {
            scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: 'Add New User',
          dropDown: CustomDropDown(
            onChanged: (value) {
              print(value);
            },
            items: const [
              'Asc',
              'Dec',
            ],
          ),
        ),
        SizedBox(
          height: height(context) * 4,
        ),
        ShowUsers(
          isWeb: true,
        ),
      ],
    );
  }
}
