import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/users/users.dart';
import 'package:anees_costing/Widget/dropdown.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              Provider.of<Users>(context, listen: false).drawerUser = null;
              scaffoldKey.currentState!.openEndDrawer();
            },
            btnText: 'Add New User',
            dropDown: CustomDropDown(
              onChanged: (val) {
                print(val);
              },
              items: ["Hi", "bye"],
            )),
        SizedBox(
          height: height(context) * 4,
        ),
        ShowUsers(
          isWeb: true,
          scaffoldKey: scaffoldKey,
        ),
      ],
    );
  }
}
