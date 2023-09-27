import 'dart:io';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Functions/popup.dart';
import '../../../Models/language.dart';
import '../../../Models/pagination.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/paginate.dart';
import '../../../Widget/snakbar.dart';
import '/Models/user.dart';
import 'add_user.dart';
import '/Widget/appbar.dart';
import '/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/userscreen';
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isFirst = true;
  List<AUser> users = [];
  bool isLoading = false;
  bool isFilter = false;
  String selectedFilter = "All";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    users.sort((a, b) => a.name.compareTo(b.name));
    var langProvider = Provider.of<Language>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                btnbgColor.withOpacity(1),
                btnbgColor.withOpacity(1),
              ],
            ),
            shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: btnbgColor.withOpacity(0.4),
          onPressed: () {
            Navigator.of(context).pushNamed(AddUser.routeName, arguments: {
              'action': 'Add',
            });
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Stack(
            children: [
              Column(
                children: [
                  Appbar(
                    title: langProvider.get('User'),
                    subtitle: langProvider.get('all users here'),
                    svgIcon: 'assets/icons/users.svg',
                    leadingIcon: Icons.home,
                    leadingTap: () {
                      Provider.of<Counts>(context, listen: false)
                          .setSelectedIndex(0);
                    },
                    tarilingIcon: Icons.more_vert,
                    tarilingTap: () {
                      showPopupMenu(popups: [
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'All';
                            });
                          },
                          child: Text(
                            langProvider.get('All'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Admin';
                            });
                          },
                          child: Text(
                            langProvider.get('Admin'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Seller';
                            });
                          },
                          child: Text(
                            langProvider.get('Seller'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Customer';
                            });
                          },
                          child: Text(
                            langProvider.get('Customer'),
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ),
                      ], context: context);

                      // setState(() {
                      //   isFilter = true;
                      // });
                    },
                  ),
                  SizedBox(
                    height: height(context) * 2,
                  ),
                  isLoading
                      ? Center(
                          child: AdaptiveIndecator(
                            color: primaryColor,
                          ),
                        )
                      : ShowUsers(
                          isWeb: false,
                          selectedFilter: selectedFilter,
                        ),
                ],
              ),
              if (isFilter)
                Positioned(
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    // height: 300,
                    width: 200,
                    child: Column(children: [
                      filterListItem(
                        langProvider.get('Admin'),
                      ),
                      filterListItem(
                        langProvider.get('Seller'),
                      ),
                      filterListItem(
                        langProvider.get('Customer'),
                      ),
                      filterListItem(
                        langProvider.get('All'),
                      )
                    ]),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget filterListItem(String title) {
    return ListTile(
      onTap: () {
        setState(() {
          selectedFilter = title;
          isFilter = false;
        });
      },
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 20),
      ),
    );
  }
}

class ShowUsers extends StatefulWidget {
  ShowUsers({
    Key? key,
    required this.isWeb,
    required this.selectedFilter,
    this.scaffoldKey,
  }) : super(key: key);
  String selectedFilter;
  final bool isWeb;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;

  List<AUser> users = [];
  // List<Product> customerProducts = [];
  // bool productLoading = false;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      if (Provider.of<Users>(context, listen: false).users.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Users>(context, listen: false)
            .fetchAndUpdateUser(userToken: currentUser!.token)
            .then((value) {
          setState(() {
            isLoading = false;
          });
        });
      }

      isFirst = false;
    }
    super.didChangeDependencies();
  }

  void _deleteUser({required AUser aUser, required Language lanProvider}) {
    showCustomDialog(
        context: context,
        title: lanProvider.get('Delete User'),
        btn1: lanProvider.get('Yes'),
        content: lanProvider.get('Do you want to delete user?'),
        btn1Pressed: () async {
          Navigator.of(context).pop();
          setState(() {
            isLoading = true;
          });
          // Provider.of<Users>(context, listen: false).updateUserLocally(aUser);
          await Provider.of<Users>(context, listen: false)
              .deleteUser(userId: aUser.id, userToken: currentUser!.token)
              .then((value) async {
            // await Provider.of<Users>(context, listen: false)
            //     .fetchAndUpdateUser(userToken: currentUser!.token);

            showMySnackBar(
                context: context,
                text: lanProvider.get('User has been Deleted'));
            setState(() {
              isLoading = false;
            });
          }).catchError((error) {
            setState(() {
              isLoading = false;
            });
            showCustomDialog(
              context: context,
              title: lanProvider.get('Error'),
              btn1: lanProvider.get('Okay'),
              content: error.toString(),
              btn1Pressed: () {
                Navigator.of(context).pop();
              },
            );
          });
        },
        btn2: lanProvider.get('No'),
        btn2Pressed: () {
          Navigator.of(context).pop();
        });
  }

  // getUserProduct(String userId) async {
  //   await Provider.of<SentProducts>(context, listen: false)
  //       .fetchSentProducts(userId: userId);
  // }

  @override
  Widget build(BuildContext context) {
    users = Provider.of<Users>(context, listen: true)
        .getFilteredUsers(widget.selectedFilter);
    if (currentUser!.role!.toLowerCase() != 'admin') {
      users.removeWhere((element) => element.role.toLowerCase() == 'admin');
    }
    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    var languageProvider = Provider.of<Language>(context);

    return Expanded(
      child: isLoading
          ? Center(
              child: AdaptiveIndecator(
                color: primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (ctx, index) => InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            title: Center(
                              child: Text(
                                users[index].name,
                                style: TextStyle(color: primaryColor),
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed(AddUser.routeName, arguments: {
                                    'action': 'edit',
                                    'data': users[index],
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor),
                                child: Text(languageProvider.get('Edit User')),
                              ),
                            ],
                            content: Container(
                              height: height(context) * 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  UserDetail(
                                    title: languageProvider.get('Email'),
                                    value: users[index].email,
                                  ),
                                  SizedBox(
                                    height: height(context) * 1,
                                  ),
                                  UserDetail(
                                    title: languageProvider.get('Phone'),
                                    value: users[index].phone,
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: btnbgColor.withOpacity(0.6), width: 1),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              offset: const Offset(0, 5),
                              blurRadius: 10,
                            ),
                          ]),
                      margin: const EdgeInsets.only(bottom: 20),
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
                                        color: btnbgColor.withOpacity(1)),
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
                                width: width(context) * 4,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    users[index].name,
                                    style: TextStyle(
                                      color: headingColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height(context) * 0.5,
                                  ),
                                  Text(
                                    users[index].email,
                                    style: TextStyle(
                                        color: contentColor, fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (users[index].role != 'Admin')
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (users[index].role.toLowerCase() ==
                                        'customer' &&
                                    (Platform.isMacOS || Platform.isWindows))
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: primaryColor,
                                          // maximumSize: Size(130, 130),
                                          minimumSize: Size(100, 35)),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (ctx) => StatefulBuilder(
                                                builder: ((context, setState) =>
                                                    AlertDialog(
                                                      title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            users[index].name,
                                                            style: GoogleFonts
                                                                .righteous(
                                                                    color:
                                                                        headingColor,
                                                                    fontSize:
                                                                        22),
                                                          ),
                                                          IconButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              icon: const Icon(
                                                                Icons.cancel,
                                                                color:
                                                                    Colors.red,
                                                              ))
                                                        ],
                                                      ),
                                                      content: Container(
                                                          width:
                                                              width(context) *
                                                                  100,
                                                          height:
                                                              height(context) *
                                                                  60,
                                                          child:
                                                              CustomerProducts(
                                                            userId:
                                                                users[index].id,
                                                            scaffoldKey: widget
                                                                .scaffoldKey!,
                                                          )),
                                                    ))));
                                      },
                                      child: Text(languageProvider
                                          .get('View Products'))),
                                SizedBox(
                                  width: width(context) * 1,
                                ),
                                if (users[index].role.toLowerCase() != 'admin')
                                  IconButton(
                                    onPressed: () {
                                      _deleteUser(
                                          aUser: users[index],
                                          lanProvider: languageProvider);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
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
                        height: height(context) * 2.5,
                        width: width(context) * 20,
                        decoration: BoxDecoration(
                            color: btnbgColor.withOpacity(1),
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10))),
                        child: Center(
                          child: FittedBox(
                            child: Text(
                              languageProvider.get(users[index].role),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class UserDetail extends StatelessWidget {
  UserDetail({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: headingColor, fontSize: 16),
        ),
        SizedBox(
          height: height(context) * 0.3,
        ),
        Text(
          value,
          style: TextStyle(color: primaryColor, fontSize: 14),
        )
      ],
    );
  }
}

class CustomerProducts extends StatefulWidget {
  CustomerProducts(
      {required this.userId, required this.scaffoldKey, super.key});
  String userId;
  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<CustomerProducts> createState() => _CustomerProductsState();
}

class _CustomerProductsState extends State<CustomerProducts> {
  bool productLoading = false;
  bool isFirst = true;
  List<Product> customerProducts = [];
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    // TODO: implement didChangeDependencies
    if (isFirst) {
      setState(() {
        productLoading = true;
      });
      await Provider.of<Products>(context, listen: false).getCustomerProducts(
        userId: widget.userId,
        userToken: currentUser!.token,
      );
      setState(() {
        productLoading = false;
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    customerProducts = Provider.of<Products>(context).customerProducts;
    //  List<CustomPage> pages =
    //     Provider.of<Products>(context,).pages;

    // void _onPageChange(CustomPage page) {
    //   // print(p.url);
    //   setState(() {
    //     productLoading = true;
    //   });
    //   Provider.of<Products>(context, listen: false)
    //       .getCustomerProducts(
    //           page: page.url.split('=').last, userId: widget.userId, userToken: currentUser!.token)
    //       .then((value) {
    //     setState(() {
    //       productLoading = false;
    //     });
    //   });
    // }
    return productLoading
        ? Center(
            child: AdaptiveIndecator(
              color: primaryColor,
            ),
          )
        : customerProducts.isEmpty
            ? Center(
                child: Text('No Products assigned to this customer'),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        // crossAxisCount: width1 < 900 ? 3 : 4,
                        crossAxisCount: 3,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                      ),
                      itemCount: customerProducts.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: btnbgColor.withOpacity(0.6),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: GridTile(
                                footer: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  height: height(context) * 5,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.white24,
                                          Colors.black38
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          customerProducts[index].name,
                                          style: GoogleFonts.righteous(
                                            color: Colors.black54,
                                            fontSize: 25,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                            0.4,
                                          ),
                                          offset: const Offset(0, 5),
                                          blurRadius: 20,
                                          spreadRadius: 1,
                                        ),
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                            0.5,
                                          ),
                                          offset: -Offset(5, 0),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                      borderRadius: customRadius),
                                  child: Hero(
                                    tag: customerProducts[index].id,
                                    child: ExtendedImage.network(
                                      cache: true,
                                      key: ValueKey(customerProducts[index].id),
                                      customerProducts[index].image,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              top: 0,
                              child: IconButton(
                                  onPressed: () async {
                                    showCustomDialog(
                                        context:
                                            widget.scaffoldKey.currentContext!,
                                        title: 'Delete',
                                        btn1: 'Yes',
                                        content:
                                            'Product will be deleted from the list permamently',
                                        btn2: 'No',
                                        btn1Pressed: () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            productLoading = true;
                                          });
                                          await Provider.of<Products>(context,
                                                  listen: false)
                                              .deleteCustomerProduct(
                                                  prodId:
                                                      customerProducts[index]
                                                          .id,
                                                  userId: widget.userId,
                                                  userToken:
                                                      currentUser!.token);
                                          Provider.of<Products>(
                                                  widget.scaffoldKey
                                                      .currentContext!,
                                                  listen: false)
                                              .removeCustomer(widget.userId,
                                                  customerProducts[index].id);
                                          await Provider.of<Products>(
                                                  widget.scaffoldKey
                                                      .currentContext!,
                                                  listen: false)
                                              .getCustomerProducts(
                                                  userId: widget.userId,
                                                  userToken:
                                                      currentUser!.token);

                                          setState(() {
                                            productLoading = false;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        btn2Pressed: () {
                                          Navigator.of(context).pop();
                                        });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.red,
                                  )),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  //   Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       ...pages.map(
                  //         (page) => Paginate(
                  //           page: page,
                  //           onTap: page.url.isEmpty
                  //               ? () {}
                  //               : () => _onPageChange(page),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              );
  }
}
