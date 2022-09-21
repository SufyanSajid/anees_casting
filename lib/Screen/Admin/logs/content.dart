import 'dart:developer';

import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Models/activitylogs.dart';
import 'package:anees_costing/Widget/adaptiveDialog.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/dropdown.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/auth.dart';

class ActivityLogWebContent extends StatefulWidget {
  ActivityLogWebContent({Key? key}) : super(key: key);

  @override
  State<ActivityLogWebContent> createState() => _ActivityLogWebContentState();
}

class _ActivityLogWebContentState extends State<ActivityLogWebContent> {
  final activityController = TextEditingController();
  bool isFirst = true;
  List<Log>? logs;
  bool isLoading = false;
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      setState(() {
        isLoading = true;
      });
      await Provider.of<Logs>(context, listen: false)
          .fetchAndSetLogs(userToken: currentUser!.token);
      setState(() {
        isLoading = false;
      });
      isFirst = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context, listen: false).logs;
    return Column(
      children: [
        // buildFilterBar(
        //   searchSubmitted: () {},
        //   context: context,
        //   searchConttroller: activityController,
        //   btnTap: () {},
        //   btnText: '',
        //   dropDown: CustomDropDown(
        //     onChanged: () {},
        //     items: ['By Date', 'By A-Z'],
        //   ),
        // ),
        // SizedBox(
        //   height: height(context) * 3,
        // ),
        Expanded(
          child: isLoading
              ? Center(
                  child: AdaptiveIndecator(color: primaryColor),
                )
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (ctx, index) => Container(
                    margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
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
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.campaign_outlined,
                                  color: btnbgColor.withOpacity(1),
                                )),
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
                                    color: primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) * 0.5,
                                ),
                                Text(
                                  logs[index].content,
                                  style: TextStyle(
                                      color: contentColor, fontSize: 13),
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
    );
  }
}
