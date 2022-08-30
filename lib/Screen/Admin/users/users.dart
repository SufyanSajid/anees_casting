import 'package:anees_costing/Functions/dailog.dart';
import 'package:flutter/foundation.dart';

import '/Models/user.dart';
import 'add_user.dart';
import '/Widget/appbar.dart';
import '/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/userscreen';
  const UserScreen({Key? key}) : super(key: key);

  // _deleteUser({required String authId, required String docId}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.of(context).pushNamed(AddUser.routeName);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              const ShowUsers(
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
    this.scaffoldKey,
  }) : super(key: key);
  final bool isWeb;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  bool isFirst = true;
  bool isLoading = false;
  List<AUser>? users;
  bool isDeleting = false;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      if (Provider.of<Users>(context, listen: false).users.isEmpty) {
        setState(() {
          isLoading = true;
        });
        Provider.of<Users>(context, listen: false)
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

  _deletUser({required AUser user}) {
    isDeleting
        ? CircularProgressIndicator(
            color: primaryColor,
          )
        : showCustomDialog(
            context: context,
            title: "Delet",
            btn1: "No",
            content: "Do you wanna delete \"${user.name}\" user",
            btn2: "Yes",
            btn1Pressed: () => Navigator.of(context).pop(),
            btn2Pressed: () async {
              setState(() {
                isDeleting = true;
              });
              BuildContext ctx = context;
              await Provider.of<Users>(context, listen: false).deleteUser(user);
              await Provider.of<Users>(ctx, listen: false).fetchAndUpdateUser();
              setState(() {
                isDeleting = false;
              });
              Navigator.of(ctx).pop();
            });
  }

  @override
  Widget build(BuildContext context) {
    List<AUser> users = Provider.of<Users>(context, listen: false).users;
    return Expanded(
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white,
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
                                  color: primaryColor),
                              borderRadius: BorderRadius.circular(50)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
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
                              users[index].name,
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
                              users[index].phone,
                              style:
                                  TextStyle(color: contentColor, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 5),
                                    blurRadius: 5),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            color: contentColor,
                            onPressed: () {
                              Provider.of<Users>(context, listen: false)
                                  .setUser(users[index]);

                              widget.scaffoldKey!.currentState!.openEndDrawer();
                            },
                          ),
                        ),
                        SizedBox(
                          width: width(context) * 6,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 5),
                                    blurRadius: 5),
                              ]),
                          padding: const EdgeInsets.all(8),
                          child: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            color: contentColor,
                            onPressed: () {
                              _deletUser(user: users[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
