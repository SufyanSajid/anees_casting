import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/category.dart';

class CategoryWebContent extends StatefulWidget {
  const CategoryWebContent({Key? key}) : super(key: key);

  @override
  State<CategoryWebContent> createState() => _CategoryWebContentState();
}

class _CategoryWebContentState extends State<CategoryWebContent> {
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      Provider.of<Categories>(context).fetchAndUpdateCat();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Categories'),
      ),
    );
  }
}
