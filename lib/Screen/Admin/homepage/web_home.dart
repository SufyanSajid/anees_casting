import 'package:anees_costing/Widget/webappbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

import '../../../Widget/sidebar.dart';

class WebHome extends StatefulWidget {
  WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          //side bar area
          Expanded(
            flex: 2,
            child: Container(
              child: SideBar(
                selectedIndex: selectedIndex,
                onChanged: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          //sidebar area end

          //apbar and main area
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  WebAppbar(
                      title: 'Dashboard',
                      subTitle: 'Contains all data',
                      onChanged: () {}),
                ],
              ),
            ),
          ),
          //appbar and main area end
        ],
      ),
    );
  }
}
