import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/activitylogs.dart';
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
  @override
  void didChangeDependencies() async {
    setState(() {
      isLoading = true;
    });
    // TODO: implement didChangeDependencies
    await Provider.of<Logs>(context, listen: false).fetchAndSetLogs();
    setState(() {
      isLoading = false;
    });
    super.didChangeDependencies();
  }

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
                                      logs[index].logType,
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
        ),
      ),
    );
  }
}
