import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/activitylogs.dart';
import '../../../Widget/appbar.dart';

class ActivityLogScreen extends StatelessWidget {
  static const routeName = 'activity-log';
  ActivityLogScreen({super.key});
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context, listen: false).logs;
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Appbar(
                title: 'Log',
                subtitle: 'Users Activities',
                svgIcon: 'assets/icons/recycle.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (ctx, index) => Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: btnbgColor.withOpacity(0.6), width: 1),
                      color: Colors.white,
                      boxShadow: shadow,
                      borderRadius: customRadius,
                    ),
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
                                      color: btnbgColor.withOpacity(0.6),
                                      width: 2),
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
                              width: width(context) * 2,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  logs[index].userName,
                                  style: TextStyle(
                                    color: headingColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) * 0.5,
                                ),
                                Text(
                                  logs[index].content,
                                  style: TextStyle(
                                      color: contentColor, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              logs[index].logType,
                              style: GoogleFonts.righteous(
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
