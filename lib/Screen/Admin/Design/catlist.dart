import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Screen/Admin/Design/child_cat.dart';
import 'package:anees_costing/Screen/Admin/Design/prod_list.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Widget/adaptive_indecator.dart';

class CategoryListScreen extends StatefulWidget {
  static const routeName = 'cat-list-screen';
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  bool isFirst = true;
  bool isLoading = false;
  List<Category> categories = [];
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      if (Provider.of<Categories>(context, listen: false).categories.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Categories>(context, listen: false)
            .fetchAndUpdateCat(currentUser!.token);
        setState(() {
          isLoading = false;
        });
      }
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<Categories>(context).parentCategories;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Appbar(
                  title: 'Category',
                  subtitle: 'All Your Categories',
                  svgIcon: 'assets/icons/category.svg',
                  leadingIcon: Icons.arrow_back,
                  leadingTap: () {
                    Navigator.of(context).pop();
                  },
                  tarilingIcon: Icons.filter_list,
                  tarilingTap: () {},
                ),
                SizedBox(
                  height: height(context) * 3,
                ),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: AdaptiveIndecator(color: primaryColor),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              splashColor: primaryColor,
                              onTap: () {
                                List<Category> cats = Provider.of<Categories>(
                                        context,
                                        listen: false)
                                    .getChildCategories(categories[index].id);
                                if (cats.isEmpty) {
                                  Navigator.of(context).pushNamed(
                                      CatProductScreen.routeName,
                                      arguments: categories[index]);
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      CategoryChildListScreen.routeName,
                                      arguments: categories[index]);
                                  print('next cat');
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: btnbgColor.withOpacity(0.6),
                                      width: 1),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 5),
                                      blurRadius: 5,
                                    )
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      color: primaryColor,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: height(context) * 1,
                                    ),
                                    Text(
                                      categories[index].title,
                                      style: TextStyle(
                                          color: headingColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          ),
        ));
  }
}