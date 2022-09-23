import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  SideBar({
    Key? key,
    required this.selectedIndex,
    required this.onChanged,
  }) : super(key: key);

  int selectedIndex;

  Function onChanged;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Widget lightDivider() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.grey.withOpacity(0.5),
        height: 1,
      );
  int select = 0;
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Auth>(
      context,
    ).currentUser;
    print('role ${currentUser!.role}');
    select = widget.selectedIndex;
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: height(context) * 3),
                  child: Center(child: Image.asset('assets/images/logo.png')),
                ),
                lightDivider(),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.onChanged(0);
                      select = 0;
                    });
                  },
                  child: SideBarItem(
                    title: 'Home',
                    icon: Icons.home_outlined,
                    isSelected: select == 0,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.onChanged(1);
                      select = 1;
                    });
                  },
                  child: SideBarItem(
                    title: 'Design',
                    icon: Icons.diamond_outlined,
                    isSelected: select == 1,
                  ),
                ),
                if (currentUser.role!.toLowerCase() == 'admin')
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.onChanged(2);
                        select = 2;
                      });
                    },
                    child: SideBarItem(
                      title: 'Users',
                      icon: Icons.groups_outlined,
                      isSelected: select == 2,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.onChanged(3);
                      select = 3;
                    });
                  },
                  child: SideBarItem(
                    title: 'Cat List',
                    icon: Icons.interests_outlined,
                    isSelected: select == 3,
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      widget.onChanged(4);
                      select = 4;
                    });
                  },
                  child: SideBarItem(
                    title: 'Category',
                    icon: Icons.interests_outlined,
                    isSelected: select == 4,
                  ),
                ),
                if (currentUser.role!.toLowerCase() == 'admin')
                  InkWell(
                    onTap: () {
                      setState(() {
                        widget.onChanged(5);
                        select = 5;
                      });
                    },
                    child: SideBarItem(
                      title: 'Logs',
                      icon: Icons.recycling,
                      isSelected: select == 5,
                    ),
                  ),
              ],
            ),
            Column(
              children: [
                lightDivider(),
                Container(
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  child: FittedBox(
                    child: Text(
                      'Developed By Rapidev Tech',
                      style: TextStyle(
                        color: contentColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SideBarItem extends StatelessWidget {
  SideBarItem({
    required this.title,
    required this.icon,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  IconData icon;
  String title;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: width(context) * 100,
      height: height(context) * 12,
      decoration: BoxDecoration(
        color: Colors.white,
        border: isSelected
            ? Border(
                left: BorderSide(
                  width: width(context) * 0.4,
                  color: primaryColor,
                ),
              )
            : Border(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: width(context) * 3,
            color: isSelected ? primaryColor : contentColor,
          ),
          SizedBox(
            height: height(context) * 0.5,
          ),
          Text(
            title,
            style: GoogleFonts.righteous(
                color: isSelected ? primaryColor : contentColor),
          )
        ],
      ),
    );
  }
}
