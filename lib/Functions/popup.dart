import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

void showPopupMenu(
    {required List<PopupMenuEntry<String>> popups,
    required BuildContext context}) async {
  await showMenu(
    color: btnbgColor.withOpacity(01),

    // color: Color(0x3E5F7E).withOpacity(0.8),

    context: context,
    // constraints: BoxConstraints(minWidth: 300,maxWidth:380 ),
    position: const RelativeRect.fromLTRB(100, 75, 70, 100),
    items: popups,
    elevation: 8.0,
  );
}
