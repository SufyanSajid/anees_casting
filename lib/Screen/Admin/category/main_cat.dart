import 'package:anees_costing/Responsive/responsive.dart';
import 'package:anees_costing/Screen/Admin/category/category.dart';
import 'package:anees_costing/Screen/Admin/category/content.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileLayout: MobileCategoryScreen(), webLayout: CategoryWebContent());
  }
}
