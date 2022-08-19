import 'dart:developer';

import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Models/activitylogs.dart';
import 'package:anees_costing/Widget/dropdown.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActivityLogWebContent extends StatefulWidget {
  ActivityLogWebContent({Key? key}) : super(key: key);

  @override
  State<ActivityLogWebContent> createState() => _ActivityLogWebContentState();
}

class _ActivityLogWebContentState extends State<ActivityLogWebContent> {
  final activityController = TextEditingController();
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var logs = Provider.of<Logs>(context, listen: false).logs;
    return Column(
      children: [
        buildFilterBar(
          context: context,
          searchConttroller: activityController,
          btnTap: () {},
          btnText: '',
          dropDown: CustomDropDown(
            onChanged: () {},
            items: ['By Date', 'By A-Z'],
          ),
        ),
        SizedBox(
          height: height(context) * 3,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: logs.length,
            itemBuilder: (ctx, index) => Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
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
                            style: TextStyle(color: contentColor, fontSize: 13),
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
