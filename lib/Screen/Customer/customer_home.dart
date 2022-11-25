import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Screen/Customer/customer_catlist.dart';
import 'package:anees_costing/Screen/Customer/all_cat_prod.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/auth.dart';
import '../../Models/language.dart';

import '../../Models/product.dart';

import '../Admin/homepage/mobile.dart';

class CustomerHomeScreen extends StatefulWidget {
  static const routeName = 'customer-home';
  CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CurrentUser? currentUser;
  List<Product>? products;
  bool isLoading = false;
  bool isFirst = true;
  @override
  void didChangeDependencies() async {
    if (isFirst) {
      setState(() {
        isLoading = true;
      });
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      await Provider.of<Categories>(context, listen: false)
          .fetchAndUpdateCat(currentUser!.token);
      await Provider.of<Products>(context, listen: false).getCustomerProducts(
          page: '1', userId: currentUser!.id, userToken: currentUser!.token);
      await Provider.of<Categories>(context, listen: false)
          .getCustomerCategoriesIds(
              userToken: currentUser!.token, custId: currentUser!.id);

      Provider.of<Categories>(context, listen: false).getCustomerCategories();
      setState(() {
        isLoading = false;
      });

      isFirst = false;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<Products>(context, listen: false).customerProducts;
    var langProvider = Provider.of<Language>(context);

    Language languageProvider = Provider.of<Language>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: height(context) * 7.5,
                        width: height(context) * 7.5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(style: BorderStyle.solid, width: 2),
                            borderRadius: BorderRadius.circular(50)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'assets/images/person22.jpeg',
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
                        children: [
                          Text(
                            languageProvider.get('welcome'),
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            languageProvider.get('Dear Customer'),
                            style: GoogleFonts.righteous(
                              color: primaryColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height(context) * 2.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                langProvider.get('quick_links'),
                style: GoogleFonts.righteous(fontSize: 18, color: primaryColor),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: height(context) * 18,
              alignment: Alignment.center,
              child: Row(
                // scrollDirection: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  QuickChecks(
                    width: width(context),
                    height: height(context),
                    title: langProvider.get('designs'),
                    subtitle: 'View All Designs',
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      Navigator.pushNamed(
                          context, CustomerProductScreen.routeName);
                    },
                  ),
                  QuickChecks(
                    width: width(context),
                    height: height(context),
                    title: langProvider.get('categories'),
                    subtitle: 'View All designs by Category',
                    icon: Icons.document_scanner_sharp,
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(CustomerCatList.routeName);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height(context) * 2.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                langProvider.get('designs'),
                style: GoogleFonts.righteous(fontSize: 18, color: primaryColor),
              ),
            ),
            SizedBox(
              height: height(context) * 3,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: height(context) * 30,
              child: isLoading
                  ? Center(
                      child: AdaptiveIndecator(
                        color: primaryColor,
                      ),
                    )
                  : ListView.builder(
                      itemCount: products!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                ProductDetailScreen.routeName,
                                arguments: products![index],
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 20),
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2, color: primaryColor)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ExtendedImage.network(
                                  products![index].image,
                                  cache: true,
                                  height: height(context) * 25,
                                  width: width(context) * 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Text(
                                products![index].name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
