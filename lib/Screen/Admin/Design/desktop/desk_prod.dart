import 'dart:io';

import 'package:anees_costing/Widget/drawer/web_drawer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../Functions/dailog.dart';
import '../../../../Models/auth.dart';
import '../../../../Models/category.dart';
import '../../../../Models/language.dart';
import '../../../../Models/pagination.dart';
import '../../../../Models/product.dart';
import '../../../../Widget/adaptive_indecator.dart';
import '../../../../Widget/paginate.dart';
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
  String selectedFilter = 'By Date';
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
          .getCatProducts(
              page: '1', userToken: currentUser!.token, catId: cat!.id)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isFirst = false;

    super.didChangeDependencies();
  }

  _deleteProduct({required imgUrl, required Product prod}) {
    showCustomDialog(
        context: context,
        title: 'Delete',
        btn1: 'Yes',
        content: 'Do You want to delete this product',
        btn1Pressed: () async {
          Navigator.of(context).pop();
          setState(() {
            isLoading = true;
          });
          var provider = Provider.of<Products>(context, listen: false);

          await provider.deleteProduct(prod.id, currentUser!.token);

          setState(() {
            isLoading = false;
          });
        },
        btn2: 'No',
        btn2Pressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context);

    List<Product> products = Provider.of<Products>(context).catProducts;

    List<CustomPage> pages = Provider.of<Products>(
      context,
    ).pages;

    void _onPageChange(CustomPage page) {
      // print(p.url);
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .getCustomerProducts(
              page: page.url.split('=').last,
              userId: currentUser!.token,
              userToken: currentUser!.token)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    return Scaffold(
      key: _ScaffoldKey123,

      endDrawer: WebDrawer(selectedIndex: 1),
      // appBar: Platform.isAndroid || Platform.isIOS
      //     ? null
      //     : AppBar(
      //         backgroundColor: primaryColor,
      //       ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
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
                      Icons.arrow_back,
                      color: btnbgColor.withOpacity(1),
                    ),
                  ),
                ),
                PopupMenuButton(
                  tooltip: languageProvider.get('Filters'),
                  icon: Icon(
                    Icons.more_vert,
                    color: primaryColor,
                  ),
                  color: btnbgColor.withOpacity(1),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      onTap: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Provider.of<Products>(context, listen: false)
                            .getCatProdByDate();
                        setState(() {
                          isLoading = false;
                        });
                        setState(() {
                          selectedFilter = 'By Date';
                        });
                      },
                      child: Text(
                        languageProvider.get('by date'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        Provider.of<Products>(context, listen: false)
                            .setCatProductByName();
                        setState(
                          () {
                            selectedFilter = 'By Name';
                          },
                        );
                      },
                      child: Text(
                        languageProvider.get('by name'),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                                                products[
                                                                    index]);

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
                                                            prod: products[
                                                                index]);
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
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ...pages.map(
                        (page) => Paginate(
                          page: page,
                          onTap: page.url.isEmpty
                              ? () {}
                              : () => _onPageChange(page),
                        ),
                      )
                    ]))
          ],
        ),
      ),
    );
  }
}
