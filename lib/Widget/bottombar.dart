import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../contant.dart';

class CustomBottomBar extends StatefulWidget {
  CustomBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);
  int selectedIndex;
  Function onTap;

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
    var currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      height: height * 6,
      decoration: BoxDecoration(
          gradient: customGradient, borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavbarItem(
            onTap: () {
              setState(() {
                widget.onTap(0);
                widget.selectedIndex = 0;
              });
            },
            icon: Icons.grid_view_outlined,
            fillIcon: Icons.grid_view,
            isActive: widget.selectedIndex == 0,
          ),
          if (currentUser!.role!.toLowerCase() == 'admin')
            NavbarItem(
              onTap: () {
                setState(() {
                  widget.onTap(1);
                  widget.selectedIndex = 1;
                });
              },
              icon: Icons.analytics_outlined,
              fillIcon: Icons.analytics,
              isActive: widget.selectedIndex == 1,
            ),
          if (currentUser.role!.toLowerCase() == 'admin')
            NavbarItem(
              onTap: () {
                setState(() {
                  widget.onTap(2);
                  widget.selectedIndex = 2;
                });
              },
              icon: Icons.recycling_outlined,
              fillIcon: Icons.recycling,
              isActive: widget.selectedIndex == 2,
            ),
          NavbarItem(
            onTap: () {
              setState(() {
                widget.onTap(3);
                widget.selectedIndex = 3;
              });
            },
            icon: Icons.account_box_outlined,
            fillIcon: Icons.account_box,
            isActive: widget.selectedIndex == 3,
          ),
        ],
      ),
    );
  }
}

class NavbarItem extends StatelessWidget {
  NavbarItem({
    Key? key,
    required this.onTap,
    required this.isActive,
    required this.icon,
    required this.fillIcon,
  }) : super(key: key);

  Function()? onTap;
  bool isActive;
  IconData icon;
  IconData fillIcon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        isActive ? fillIcon : icon,
        color: isActive
            ? Colors.white
            : Colors.white.withOpacity(
                0.5,
              ),
      ),
    );
  }
}
