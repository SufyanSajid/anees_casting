import 'dart:io';

import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/Design/catlist.dart';
import 'package:anees_costing/Screen/Admin/category/category.dart';
import 'package:anees_costing/Screen/Admin/Product/product.dart';
import 'package:anees_costing/Screen/Admin/logs/activitylog.dart';
import 'package:anees_costing/Screen/Admin/users/customers.dart';
import 'package:anees_costing/Screen/Admin/users/users.dart';
import 'package:anees_costing/Screen/Common/profile.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/bottombar.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../contant.dart';

class MobileAdminHomePage extends StatefulWidget {
  const MobileAdminHomePage({Key? key}) : super(key: key);

  @override
  State<MobileAdminHomePage> createState() => _MobileAdminHomePageState();
}

class _MobileAdminHomePageState extends State<MobileAdminHomePage> {
  //bottomNavigationBar: CustomBottomBar(selectedIndex: 1, onTap: (){}),
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? selectIndex;
  bool isFirst = true;
  bool isLoading = false;
  Count? count;
  List<AUser>? users;
  CurrentUser? currentUser;
  @override
  void didChangeDependencies() async {
    if (isFirst) {
      setState(() {
        isLoading = true;
      });
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      await Provider.of<Users>(context, listen: false)
          .fetchAndUpdateUser(userToken: currentUser!.token);
      setState(() {
        isLoading = false;
      });
      Provider.of<Categories>(context, listen: false)
          .fetchAndUpdateCat(currentUser!.token);
     await Provider.of<Products>(context, listen: false)
          .fetchAndUpdateProducts(page: '1',userToken: currentUser!.token);
      isFirst = false;
    }

    super.didChangeDependencies();
  }

  Future<bool> _promptExit() async {
    bool returnvalue = false;
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit app'),
              actions: [
                TextButton(
                  onPressed: () {
                    returnvalue = true;
                    Navigator.of(context).pop();
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    exit(0);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    returnvalue = false;
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));

    return returnvalue;
  }

  @override
  Widget build(BuildContext context) {
    var langProvider = Provider.of<Language>(context);

    selectIndex = Provider.of<Counts>(context).selectedIndex;

    count = Provider.of<Counts>(context, listen: false).getCount;
    users = Provider.of<Users>(context, listen: false).users;
    var products = Provider.of<Products>(context, listen: true).total;
    var categories = Provider.of<Categories>(context, listen: false).categories;

    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
    var homePage = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                Platform.isAndroid ? EdgeInsets.only(top: 10) : EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: height * 7.5,
                      width: height * 7.5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid,
                              width: 2,
                              color: btnbgColor.withOpacity(1)),
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/images/person22.jpeg',
                          height: height * 10,
                          width: height * 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langProvider.get('welcome'),
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          langProvider.get(currentUser!.role!),
                          style: GoogleFonts.righteous(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 5),
                              blurRadius: 5),
                        ]),
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.filter_list,
                      color: btnbgColor.withOpacity(1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            decoration: BoxDecoration(
              gradient: customGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(94, 89, 89, 0.11),
                    offset: Offset(0, 10),
                    blurRadius: 20),
              ],
            ),

            //width: double.infinity,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DisplayBox(
                  height: height,
                  title: langProvider.get('designs'),
                  value: isLoading ? '...' : products.toString(),
                ),
                Container(
                  height: height * 5,
                  width: width * 0.2,
                  color: secondaryColor.withOpacity(0.5),
                ),
                DisplayBox(
                  height: height,
                  title: langProvider.get('categories'),
                  value: isLoading
                      ? '...'
                      : Provider.of<Categories>(context)
                          .categories
                          .length
                          .toString(),
                ),
                Container(
                  height: height * 5,
                  width: width * 0.2,
                  color: secondaryColor.withOpacity(0.5),
                ),
                DisplayBox(
                  height: height,
                  title: langProvider.get('customers'),
                  value: isLoading
                      ? '...'
                      : Provider.of<Users>(context, listen: true)
                          .customers
                          .length
                          .toString(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              langProvider.get('quick_links'),
              style: GoogleFonts.righteous(fontSize: 18, color: primaryColor),
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: height * 18,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                QuickChecks(
                  width: width,
                  height: height,
                  title: langProvider.get('designs'),
                  subtitle: 'Click to view',
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, ProductScreen.routeName);
                  },
                ),
                QuickChecks(
                  width: width,
                  height: height,
                  title: langProvider.get('categories'),
                  subtitle: 'Click to view',
                  icon: Icons.document_scanner_sharp,
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(CategoryListScreen.routeName);
                  },
                ),
                if (currentUser!.role!.toLowerCase() == 'admin')
                  QuickChecks(
                    width: width,
                    height: height,
                    title: langProvider.get('categories_list'),
                    subtitle: 'Click to view',
                    icon: Icons.list,
                    onTap: () {
                      Navigator.of(context).pushNamed(CategoryScreen.routeName);
                    },
                  ),
                QuickChecks(
                  width: width,
                  height: height,
                  title: langProvider.get('customers'),
                  subtitle: 'Click to view',
                  icon: Icons.person_pin_circle_outlined,
                  onTap: () {
                    Navigator.of(context).pushNamed(CustomerScreen.routeName);
                  },
                ),
              ],
            ),
          ),
          if (currentUser!.role!.toLowerCase() == 'admin')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langProvider.get('app_user'),
                    style: GoogleFonts.righteous(
                        fontSize: 18, color: primaryColor),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<Counts>(context, listen: false)
                          .setSelectedIndex(1);
                    },
                    child: Text(
                      langProvider.get('view_all'),
                      style: GoogleFonts.ubuntu(
                          fontSize: 15, color: secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: height * 1,
          ),
          if (currentUser!.role!.toLowerCase() == 'admin')
            Expanded(
              child: isLoading
                  ? Center(
                      child: AdaptiveIndecator(color: primaryColor),
                    )
                  : ListView.builder(
                      itemCount: 4,
                      itemBuilder: (ctx, index) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: btnbgColor.withOpacity(0.6),
                                      width: 1),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(0, 5),
                                      blurRadius: 10,
                                    ),
                                  ]),
                              // margin: const EdgeInsets.only(
                              //     bottom: 20, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: height * 6,
                                        width: height * 6,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                style: BorderStyle.solid,
                                                width: 2,
                                                color:
                                                    btnbgColor.withOpacity(1)),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.asset(
                                            'assets/images/person22.jpeg',
                                            height: height * 10,
                                            width: height * 10,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 4,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            users![index].name,
                                            style: TextStyle(
                                              color: headingColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.5,
                                          ),
                                          Text(
                                            users![index].phone,
                                            style: TextStyle(
                                                color: contentColor,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                height: height * 2,
                                width: width * 20,
                                decoration: BoxDecoration(
                                    color: btnbgColor.withOpacity(1),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10))),
                                child: Center(
                                  child: Text(
                                    langProvider.get(
                                      users![index].role,
                                    ),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: primaryColor),
                                  ),
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
    );
    List<Widget> _tabs = [
      homePage,
      const UserScreen(),
      ActivityLogScreen(),
      const ProfileScreen(),
    ];

    return WillPopScope(
      onWillPop: _promptExit,
      child: Scaffold(
          key: _scaffoldKey,
          drawer: const AppDrawer(),
          bottomNavigationBar: currentUser!.role!.toLowerCase() == 'admin'
              ? CustomBottomBar(
                  onTap: (value) {
                    // setState(() {
                    //   selectIndex = value;
                    // });
                  },
                  selectedIndex: selectIndex!,
                )
              : null,
          body: _tabs[selectIndex!]),
    );
  }
}

class DisplayBox extends StatelessWidget {
  const DisplayBox({
    Key? key,
    required this.height,
    required this.title,
    required this.value,
  }) : super(key: key);

  final double height;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: height * 1,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class QuickChecks extends StatelessWidget {
  QuickChecks({
    Key? key,
    required this.width,
    required this.height,
    required this.icon,
    required this.subtitle,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
        width: width * 40,
        decoration: BoxDecoration(
          border: Border.all(color: btnbgColor.withOpacity(0.6), width: 1),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 1),
                blurRadius: 20),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 28,
              ),
              SizedBox(
                height: height * 2,
              ),
              Text(
                title,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
