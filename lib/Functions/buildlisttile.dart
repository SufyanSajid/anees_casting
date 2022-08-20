import 'package:flutter/material.dart';

Widget buildListTile(
    {required IconData leadingIcon,
    IconData? trailing,
    required String title,
    required String subTitle,
    required Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: ListTile(
      leading: Icon(
        leadingIcon,
        color: Colors.white,
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 13),
      ),
      subtitle: Text(subTitle,
          style: TextStyle(
              color: Colors.white.withOpacity(
                0.5,
              ),
              fontSize: 10)),
      trailing: Icon(
        trailing,
        size: 20,
        color: Colors.white,
      ),
    ),
  );
}
