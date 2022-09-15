import 'dart:io';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widget/adaptive_indecator.dart';
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    users = Provider.of<Users>(context, listen: true).users;

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
            Navigator.of(context).pushNamed(AddUser.routeName);
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Appbar(
                title: 'User',
                subtitle: 'All users here',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.home,
                leadingTap: () {
                  Provider.of<Counts>(context, listen: false)
                      .setSelectedIndex(0);
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
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
                      users: users,
                      isWeb: false,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShowUsers extends StatefulWidget {
  const ShowUsers({
    Key? key,
    required this.isWeb,
    required this.users,
    this.scaffoldKey,
  }) : super(key: key);
  final bool isWeb;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final List<AUser> users;

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;
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

  // Future<void> getCustomerProducts(String userId) async {
  //   setState(() {
  //     productLoading = true;
  //   });
  //   customerProducts = await Provider.of<Products>(context, listen: false)
  //       .getCustomerProducts(userId);
  //   setState(() {
  //     productLoading = false;
  //   });
  // }

  _blockUser(
      {required AUser user, required BuildContext ctx, required bool block}) {
    String blockMsg = block ? "Block" : "UnBlock";
    showCustomDialog(
        context: ctx,
        title: blockMsg,
        btn1: "No",
        content: "Do you wanna $blockMsg \"${user.name}\" user",
        btn2: "Yes",
        btn1Pressed: () => Navigator.of(context).pop(),
        btn2Pressed: () async {
          var provider = Provider.of<Users>(ctx, listen: false);
          var navigator = Navigator.of(ctx);
          await provider.blockUser(user: user, block: block ? true : false);
          await provider.fetchAndUpdateUser(userToken: currentUser!.token);

          navigator.pop();
        });
  }

  // getUserProduct(String userId) async {
  //   await Provider.of<SentProducts>(context, listen: false)
  //       .fetchSentProducts(userId: userId);
  // }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? Center(
              child: AdaptiveIndecator(
                color: primaryColor,
              ),
            )
          : ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (ctx, index) => Stack(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                  widget.users[index].name,
                                  style: TextStyle(
                                    color: headingColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: height(context) * 0.5,
                                ),
                                Text(
                                  widget.users[index].phone,
                                  style: TextStyle(
                                      color: contentColor, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (widget.users[index].role != 'Admin')
                          Row(
                            children: [
                              if (widget.users[index].role.toLowerCase() ==
                                      'customer' &&
                                  Platform.isMacOS)
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
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
                                                          widget.users[index]
                                                              .name,
                                                          style: GoogleFonts
                                                              .righteous(
                                                                  color:
                                                                      headingColor,
                                                                  fontSize: 22),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                              Icons.cancel,
                                                              color: Colors.red,
                                                            ))
                                                      ],
                                                    ),
                                                    content: Container(
                                                        width: width(context) *
                                                            100,
                                                        height:
                                                            height(context) *
                                                                60,
                                                        child: CustomerProducts(
                                                          userId: widget
                                                              .users[index].id,
                                                          scaffoldKey: widget
                                                              .scaffoldKey!,
                                                        )),
                                                  ))));
                                    },
                                    child: Text('View Products')),
                              SizedBox(
                                width: width(context) * 1,
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
                      height: height(context) * 2,
                      width: width(context) * 20,
                      decoration: BoxDecoration(
                          color: btnbgColor.withOpacity(1),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10))),
                      child: Center(
                        child: Text(
                          widget.users[index].role,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (isFirst) {
      setState(() {
        productLoading = true;
      });
      customerProducts = await Provider.of<Products>(context, listen: false)
          .getCustomerProducts(widget.userId);
      setState(() {
        productLoading = false;
      });
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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
            : GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: btnbgColor.withOpacity(0.6), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: GridTile(
                          footer: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            height: height(context) * 5,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              gradient: LinearGradient(
                                  colors: [Colors.white24, Colors.black38],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              child: Image.network(
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
                                  context: widget.scaffoldKey.currentContext!,
                                  title: 'Delete',
                                  btn1: 'Yes',
                                  content: 'Delete this product from this list',
                                  btn2: 'No',
                                  btn1Pressed: () async {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      productLoading = true;
                                    });
                                    await Provider.of<SentProducts>(context,
                                            listen: false)
                                        .deleteSentProduct(
                                            product: customerProducts[index],
                                            userId: widget.userId);

                                    Provider.of<Products>(
                                            widget.scaffoldKey.currentContext!,
                                            listen: false)
                                        .removeCustomer(widget.userId,
                                            customerProducts[index].id);
                                    customerProducts = await Provider.of<
                                                Products>(
                                            widget.scaffoldKey.currentContext!,
                                            listen: false)
                                        .getCustomerProducts(widget.userId);

                                    setState(() {
                                      productLoading = false;
                                    });
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
              );
  }
}
