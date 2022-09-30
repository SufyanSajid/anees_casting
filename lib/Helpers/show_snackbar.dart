import 'package:anees_costing/Models/language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Directionality(
          textDirection:
              Provider.of<Language>(context, listen: true).currentLang ==
                      language.Urdu
                  ? TextDirection.rtl
                  : TextDirection.ltr,
          child: Text(content))));
}
