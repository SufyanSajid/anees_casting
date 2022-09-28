import 'package:anees_costing/Functions/popup.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/activitylogs.dart';
import '../../../Models/counts.dart';
import '../../../Widget/appbar.dart';

class ActivityLogScreen extends StatefulWidget {
  static const routeName = 'activity-log';
  ActivityLogScreen({super.key});

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  CurrentUser? currentUser;
  String selectedFilter = "All";
  bool isFilter = false;
  List<Log> logs = [];

  @override
  void didChangeDependencies() async {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    setState(() {
      isLoading = true;
    });
    // TODO: implement didChangeDependencies
    await Provider.of<Logs>(context, listen: false)
        .fetchAndSetLogs(userToken: currentUser!.token);
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    logs = Provider.of<Logs>(context, listen: false)
        .getFilteredLog(selectedFilter);
    var langProvider = Provider.of<Language>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Appbar(
                    title: langProvider.get('Log'),
                    subtitle: langProvider.get('Users Activities'),
                    svgIcon: 'assets/icons/recycle.svg',
                    leadingIcon: Icons.home,
                    leadingTap: () {
                      Provider.of<Counts>(context, listen: false)
                          .setSelectedIndex(0);
                    },
                    tarilingIcon: Icons.more_vert,
                    tarilingTap: () {
                      showPopupMenu(popups: [
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'All';
                            });
                          },
                          child: Text(
                            langProvider.get('All'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Share';
                            });
                          },
                          child: Text(
                            langProvider.get('Share'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Activity';
                            });
                          },
                          child: Text(
                            langProvider.get('Activity'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                      ], context: context);

                      // setState(() {
                      //   isFilter = true;
                      // });
                    },
                  ),
                  SizedBox(
                    height: height(context) * 2,
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: AdaptiveIndecator(
                              color: primaryColor,
                            ),
                          )
                        : logs.isEmpty
                            ? Center(
                                child: Text('No Logs Yet'),
                              )
                            : ListView.builder(
                                itemCount: logs.length,
                                itemBuilder: (ctx, index) => Container(
                                  margin: const EdgeInsets.only(bottom: 15),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: btnbgColor.withOpacity(0.6),
                                        width: 1),
                                    color: Colors.white,
                                    boxShadow: shadow,
                                    borderRadius: customRadius,
                                  ),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.campaign_outlined,
                                              color: btnbgColor.withOpacity(1),
                                            )),
                                      ),
                                      SizedBox(
                                        width: width(context) * 2,
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                                  color: contentColor,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          langProvider.get(logs[index].logType),
                                          textAlign: TextAlign.right,
                                          style: GoogleFonts.righteous(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                  ),
                ],
              ),
              if (isFilter)
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    // height: 300,
                    width: 200,
                    child: Column(children: [
                      filterListItem("Activity"),
                      filterListItem("Share"),
                      filterListItem("All")
                    ]),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget filterListItem(String title) {
    return ListTile(
      onTap: () {
        setState(() {
          selectedFilter = title;
          isFilter = false;
        });
      },
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 20),
      ),
    );
  }
}
