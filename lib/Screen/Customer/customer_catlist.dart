import 'dart:io';

import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Screen/Admin/Design/child_cat.dart';
import 'package:anees_costing/Screen/Admin/Design/prod_list.dart';
import 'package:anees_costing/Screen/Customer/customer_catchild.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Widget/adaptive_indecator.dart';
import '../../Widget/drawer.dart';
import '../Admin/Design/desktop/desk_prod.dart';
import 'cust_cat_prod.dart';

class CustomerCatList extends StatefulWidget {
  static const routeName = 'csutomer-cat-list';
  const CustomerCatList({super.key});

  @override
  State<CustomerCatList> createState() => _CustomerCatListState();
}

class _CustomerCatListState extends State<CustomerCatList> {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var parent = Provider.of<Categories>(context).parentCategories;
    categories = Provider.of<Categories>(context, listen: false)
        .getCategoresForCustomerSide(cats: parent);

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        appBar: Platform.isAndroid || Platform.isIOS
            ? null
            : AppBar(
                backgroundColor: primaryColor,
              ),
        drawer: AppDrawer(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                if (Platform.isIOS || Platform.isAndroid)
                  Appbar(
                    title: 'Category',
                    subtitle: 'All Your Categories',
                    svgIcon: 'assets/icons/category.svg',
                    leadingIcon: Icons.arrow_back,
                    leadingTap: () {
                      Navigator.of(context).pop();
                    },
                    tarilingIcon: Icons.filter_list,
                    tarilingTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
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
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                Platform.isAndroid || Platform.isIOS ? 2 : 5,
                            crossAxisSpacing:
                                Platform.isAndroid || Platform.isIOS
                                    ? 10.0
                                    : 20,
                            mainAxisSpacing:
                                Platform.isAndroid || Platform.isIOS
                                    ? 10.0
                                    : 20,
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
                                      CustomerCatProductScreen.routeName,
                                      arguments: categories[index]);
                                  //  Navigator.of(context).pushNamed(
                                  //      CatProductScreen.routeName,
                                  //     arguments: categories[index]);
                                } else {
                                  Navigator.of(context).pushReplacementNamed(
                                      CustomerCatChild.routeName,
                                      arguments: categories[index]);
                                  print('next cat1');
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
