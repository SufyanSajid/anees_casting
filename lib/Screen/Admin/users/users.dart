import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Widget/drawer.dart';

import '../../../Widget/adaptive_indecator.dart';
import '/Models/user.dart';
import 'add_user.dart';
import '/Widget/appbar.dart';
import '/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/userscreen';
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isFirst = true;
  List<AUser> users = [];
  bool isLoading = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    users = Provider.of<Users>(context, listen: true).users;

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                btnbgColor.withOpacity(1),
                btnbgColor.withOpacity(1),
              ],
            ),
            shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: btnbgColor.withOpacity(0.4),
          onPressed: () {
            Navigator.of(context).pushNamed(AddUser.routeName);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'User',
                subtitle: 'All users here',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.home,
                leadingTap: () {
                  Provider.of<Counts>(context, listen: false)
                      .setSelectedIndex(0);
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              isLoading
                  ? Center(
                      child: AdaptiveIndecator(
                        color: primaryColor,
                      ),
                    )
                  : ShowUsers(
                      users: users,
                      isWeb: false,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowUsers extends StatefulWidget {
  const ShowUsers({
    Key? key,
    required this.isWeb,
    required this.users,
    this.scaffoldKey,
  }) : super(key: key);
  final bool isWeb;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final List<AUser> users;

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  bool isFirst = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      if (Provider.of<Users>(context, listen: false).users.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Users>(context, listen: false)
            .fetchAndUpdateUser()
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

  _blockUser(
      {required AUser user, required BuildContext ctx, required bool block}) {
    String blockMsg = block ? "Block" : "UnBlock";
    showCustomDialog(
        context: ctx,
        title: blockMsg,
        btn1: "No",
        content: "Do you wanna $blockMsg \"${user.name}\" user",
        btn2: "Yes",
        btn1Pressed: () => Navigator.of(context).pop(),
        btn2Pressed: () async {
          var provider = Provider.of<Users>(ctx, listen: false);
          var navigator = Navigator.of(ctx);
          await provider.blockUser(user: user, block: block ? true : false);
          await provider.fetchAndUpdateUser();

          navigator.pop();
        });
  }

  // getUserProduct(String userId) async {
  //   await Provider.of<SentProducts>(context, listen: false)
  //       .fetchSentProducts(userId: userId);
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? Center(
              child: AdaptiveIndecator(
                color: primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (ctx, index) => Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: btnbgColor.withOpacity(0.6), width: 1),
                        color: widget.users[index].isBlocked
                            ? Colors.grey[200]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.6),
                            offset: const Offset(0, 5),
                            blurRadius: 10,
                          ),
                        ]),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: height(context) * 6,
                              width: height(context) * 6,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      style: BorderStyle.solid,
                                      width: 2,
                                      color: btnbgColor.withOpacity(1)),
                                  borderRadius: BorderRadius.circular(50)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  'assets/images/person22.jpeg',
                                  height: height(context) * 10,
                                  width: height(context) * 10,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width(context) * 4,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.users[index].name,
                                  style: TextStyle(
                                    color: headingColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) * 0.5,
                                ),
                                Text(
                                  widget.users[index].phone,
                                  style: TextStyle(
                                      color: contentColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.users[index].role != 'Admin')
                          Row(
                            children: [
                              Text(
                                widget.users[index].isBlocked
                                    ? 'Blocked'
                                    : 'Active',
                                style: TextStyle(
                                  color: widget.users[index].isBlocked
                                      ? Colors.red
                                      : Colors.green,
                                ),
                              ),
                              SizedBox(
                                width: width(context) * 3,
                              ),
                              Switch(
                                value: widget.users[index].isBlocked,
                                activeColor: Colors.red,
                                inactiveTrackColor: Colors.green,
                                thumbColor:
                                    MaterialStateProperty.all(Colors.white),
                                onChanged: (value) async {
                                  print(value);
                                  var provider =
                                      Provider.of<Users>(ctx, listen: false);

                                  await provider.blockUser(
                                      user: widget.users[index], block: value);

                                  setState(() {
                                    widget.users[index].isBlocked =
                                        !widget.users[index].isBlocked;
                                  });
                                  await provider.fetchAndUpdateUser();
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: height(context) * 2,
                      width: width(context) * 20,
                      decoration: BoxDecoration(
                          color: btnbgColor.withOpacity(1),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          widget.users[index].role,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
