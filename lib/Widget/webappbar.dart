import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Screen/Auth/Login/login.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Functions/buildlisttile.dart';
import '../Functions/dailog.dart';
import '../Functions/popup.dart';

class WebAppbar extends StatefulWidget {
  WebAppbar({
    required this.title,
    required this.subTitle,
    required this.onChanged,
    Key? key,
  }) : super(key: key);
  String title;
  String subTitle;
  Function onChanged;

  @override
  State<WebAppbar> createState() => _WebAppbarState();
}

class _WebAppbarState extends State<WebAppbar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 9,
              child: Text(
                widget.title,
                style: GoogleFonts.righteous(fontSize: 32, color: primaryColor),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      showPopupMenu(context: context, popups: [
                        PopupMenuItem(
                          child: buildListTile(
                              leadingIcon: Icons.badge_outlined,
                              title: 'Name',
                              subTitle: 'Change your name',
                              onTap: () {}),
                        ),
                        PopupMenuItem(
                          child: buildListTile(
                              leadingIcon: Icons.lock_reset_outlined,
                              title: 'Password',
                              subTitle: 'Change your password',
                              onTap: () {}),
                        ),
                        PopupMenuItem(
                          child: buildListTile(
                              leadingIcon: Icons.logout_outlined,
                              title: 'Logout',
                              subTitle: 'Logout from Aness casting',
                              onTap: () {
                                showCustomDialog(
                                    context: context,
                                    title: 'Logout',
                                    content:
                                        'Click on the logout button to proceed',
                                    btn1: 'Cancel',
                                    btn1Pressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    btn2: 'Logout',
                                    btn2Pressed: () {
                                      Provider.of<Auth>(context, listen: false)
                                          .logout();
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              LoginScreen.routeName);
                                    });
                              }),
                        ),
                      ]);
                    });
                  },
                  child: Container(
                      height: 43,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                          // gradient: primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                blurRadius: 20,
                                spreadRadius: 5,
                                offset: Offset(0, 1)),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: btnbgColor.withOpacity(1),
                                radius: 16,
                                child: const Text(
                                  'T',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                Provider.of<Auth>(context, listen: false)
                                    .currentUser!
                                    .email,
                                style: TextStyle(color: contentColor),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(
                                Icons.expand_more,
                                color: primaryColor,
                                size: 25,
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
                Container(
                  width: width(context) * 2,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        Text(
          widget.subTitle,
          style: TextStyle(color: contentColor),
        ),
      ],
    );
  }
}
