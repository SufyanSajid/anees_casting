import 'dart:io';

import 'package:anees_costing/Widget/drawer/web_drawer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Models/auth.dart';
import '../../../../Models/category.dart';
import '../../../../Models/product.dart';
import '../../../../Widget/adaptive_indecator.dart';
import '../../../../Widget/send_button.dart';
import '../../../../contant.dart';
import '../../Product/content.dart';

class DesktopCategoryProduct extends StatefulWidget {
  static const routeName = 'desktop-product';
  const DesktopCategoryProduct({super.key});

  @override
  State<DesktopCategoryProduct> createState() => _DesktopCategoryProductState();
}

class _DesktopCategoryProductState extends State<DesktopCategoryProduct> {
  final _productController = TextEditingController();
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;
  Category? cat;
  GlobalKey<ScaffoldState> _ScaffoldKey123 = GlobalKey();

  @override
  void didChangeDependencies() {
    print(123);
    // TODO: implement didChangeDependencies
    if (isFirst) {
      print(456);
      cat = ModalRoute.of(context)!.settings.arguments as Category;
      currentUser = Provider.of<Auth>(context).currentUser;

      print(789);
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false).catProducts != [];
      Provider.of<Products>(context, listen: false)
          .getCatProducts(userToken: currentUser!.token, catId: cat!.id)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isFirst = false;

    super.didChangeDependencies();
  }

  _deleteProduct({required imgUrl, required prodId}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: btnbgColor.withOpacity(0.8),
              title: const Text(
                'Are Your sure ?',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Design will be deleted Permanently',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // if (isLoading) {
                    //   setState(() {
                    //     showLoaderDialog(context, 'Loading..');
                    //   });
                    // }
                    setState(() {
                      isLoading = true;
                    });
                    var provider =
                        Provider.of<Products>(context, listen: false);

                    await provider.deleteProduct(prodId, currentUser!.token);

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).catProducts;
    return Scaffold(
      key: _ScaffoldKey123,
      endDrawer: WebDrawer(selectedIndex: 1),
      appBar: Platform.isAndroid || Platform.isIOS
          ? null
          : AppBar(
              backgroundColor: primaryColor,
            ),
      body: Column(
        children: [
          SizedBox(
            height: height(context) * 2,
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: AdaptiveIndecator(
                      color: primaryColor,
                    ),
                  )
                : products.isEmpty
                    ? Center(
                        child: Text('No Designs to show'),
                      )
                    : GridView.builder(
                        cacheExtent: 9999,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 20.0,
                          mainAxisSpacing: 20.0,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            key: ValueKey(products[index].id),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  content: Hero(
                                    tag: products[index].id,
                                    child: Column(
                                      // alignment: Alignment.topCenter,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: ExtendedImage.network(
                                            products[index].image,
                                            cache: true,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.bottomRight,
                                            child: Table(
                                              children: [
                                                TableRow(children: [
                                                  Text(
                                                      "Title: ${products[index].name}"),
                                                  Text(
                                                      "Cat:  ${products[index].categoryTitle}"),
                                                  Text(
                                                      "Unit:   ${products[index].unit}")
                                                ]),
                                                TableRow(children: [
                                                  Text(
                                                      "Length: ${products[index].length}"),
                                                  Text(
                                                      "Width:  ${products[index].width}"),
                                                  Text(
                                                      "Date:   ${products[index].dateTime} ")
                                                ])
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
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
                                          products[index].name,
                                          style: GoogleFonts.righteous(
                                            color: Colors.black54,
                                            fontSize: 25,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          if (currentUser!.role!
                                                  .toLowerCase() ==
                                              'admin')
                                            PopupMenuButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: primaryColor
                                                    .withOpacity(0.8),
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) =>
                                                      <PopupMenuEntry>[
                                                PopupMenuItem(
                                                  child: PopupItem(
                                                    icon: Icons.edit_outlined,
                                                    text: 'Edit',
                                                    onTap: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      Provider.of<Products>(
                                                              context,
                                                              listen: false)
                                                          .setProduct(
                                                              products[index]);

                                                      _ScaffoldKey123
                                                          .currentState!
                                                          .openEndDrawer();
                                                    },
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  child: PopupItem(
                                                    icon: Icons.delete,
                                                    text: 'Delete',
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      _deleteProduct(
                                                          imgUrl:
                                                              products[index]
                                                                  .image,
                                                          prodId:
                                                              products[index]
                                                                  .id);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          SendProductButton(
                                              prod: products[index])
                                        ],
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
                                      tag: products[index].id,
                                      child: ExtendedImage.network(
                                        products[index].image,
                                        cache: true,
                                      )),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
