import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  // onTap: () {
                  //   setState(() {
                  //     showPopupMenu(context: context, popups: [
                  //       PopupMenuItem(
                  //         child: buildListTile(
                  //           leadingIcon: Icons.person_outline,
                  //           title: 'Plan Details',
                  //           subTitle: 'View Your Plan and Account Details',
                  //           onTap: () {},
                  //         ),
                  //       ),
                  //       PopupMenuItem(
                  //         child: buildListTile(
                  //           leadingIcon: Icons.desktop_windows,
                  //           title: 'Manage Devices',
                  //           subTitle: 'Manage your connected devices',
                  //           trailing: Icons.launch,
                  //           onTap: () {},
                  //         ),
                  //       ),
                  //       PopupMenuItem(
                  //         child: buildListTile(
                  //             leadingIcon: Icons.logout_outlined,
                  //             title: 'Logout',
                  //             subTitle: 'Logout from Minecloud',
                  //             onTap: () {
                  //               showLogoutDialog(
                  //                   context: context, title: 'Logout');
                  //             }),
                  //       ),
                  //     ]);
                  //   });
                  // },
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
                                "tallme20@gmail.com",
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
