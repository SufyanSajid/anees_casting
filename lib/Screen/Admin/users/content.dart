import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/users/users.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/desk_autocomplete.dart';
import '../../../Widget/grad_button.dart';

class UserWebContent extends StatefulWidget {
  const UserWebContent({Key? key, required this.scaffoldKey}) : super(key: key);
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<UserWebContent> createState() => _UserWebContentState();
}

class _UserWebContentState extends State<UserWebContent> {
  List<AUser> users = [];
  List<AUser> searchedUsers = [];
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;

  refreshSearchedUsers(AUser user) {
    Provider.of<Users>(context, listen: false).getUsersByUser(user);
    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      if (Provider.of<Users>(context, listen: false).users.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Users>(context, listen: false)
            .fetchAndUpdateUser(userToken: currentUser!.token)
            .then((value) {
          setState(() {
            isLoading = false;
          });
        });
      }

      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("main build");
    users = Provider.of<Users>(context, listen: true).users;
    searchedUsers = Provider.of<Users>(context, listen: false).searchedUsers;

    if (searchedUsers.isNotEmpty) {
      users = searchedUsers;
      Provider.of<Users>(context, listen: false).resetSearchedUser();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: btnbgColor.withOpacity(0.6), width: 1),
            color: Colors.white,
            boxShadow: shadow,
            borderRadius: customRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WebAutoComplete(
                    onRefresh: () {
                      setState(() {});
                    },
                    onChange: (val) {
                      refreshSearchedUsers(val);
                    },
                    categories: null,
                    users: users,
                  ),
                ],
              ),
              GradientButton(
                onTap: () {
                  Provider.of<Users>(context, listen: false).drawerUser = null;
                  widget.scaffoldKey.currentState!.openEndDrawer();
                },
                title: "Add New User",
              ),
            ],
          ),
        ),
        SizedBox(
          height: height(context) * 4,
        ),
        isLoading
            ? Center(
                child: AdaptiveIndecator(
                  color: primaryColor,
                ),
              )
            : ShowUsers(
                isWeb: true,
                users: users,
                scaffoldKey: widget.scaffoldKey,
              ),
      ],
    );
  }
}
