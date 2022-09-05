import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/desk_autocomplete.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/filterbar.dart';
import '../../../Helpers/storage_methods.dart';

class ProductWebContent extends StatefulWidget {
  ProductWebContent({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  State<ProductWebContent> createState() => _ProductWebContentState();
}

class _ProductWebContentState extends State<ProductWebContent> {
  final _designController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();
  List<Product> products = [];
  List<AUser> filteredUser = [];

  bool isFirst = true;
  bool isLoading = false;
  String? catId;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      //FirestoreMethods().getProductsByCatId();

      isFirst = false;
      if (Provider.of<Products>(context).products.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Products>(context)
            .fetchAndUpdateProducts()
            .then((value) {
          setState(
            () {
              isLoading = false;
            },
          );
        });
      }
    }

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
                    var productProvider =
                        Provider.of<Products>(context, listen: false);
                    var countProvider =
                        Provider.of<Counts>(context, listen: false);

                    await StorageMethods().deleteImage(imgUrl: imgUrl);

                    await productProvider.deleteProduct(prodId);
                    countProvider.decreaseCount(product: 1);
                    await productProvider.fetchAndUpdateProducts();

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No'),
                ),
              ],
            ));
  }

  getSearchedProduct(String search) {
    if (search.isEmpty) {
      Provider.of<Products>(context, listen: false).fetchAndUpdateProducts();
    } else {
      Provider.of<Products>(context, listen: false)
          .searchProduct(search, 'productName');
    }
  }

  getProductsByCatId(String catId) async {
    await Provider.of<Products>(context, listen: false)
        .searchProduct(catId, 'catId');
  }

  @override
  Widget build(BuildContext context) {
    var width1 = MediaQuery.of(context).size.width;
    products = Provider.of<Products>(context).products;
    List<Category> categories = Provider.of<Categories>(context).categories;
    List<AUser> customers = Provider.of<Users>(context).customers;
    var currentUser = Provider.of<Auth>(context).currentUser;

    return Column(
      children: [
        //Filter bar

        buildFilterBar(
          searchSubmitted: (val) => getSearchedProduct(val),
          context: context,
          searchConttroller: _designController,
          btnTap: () {
            Provider.of<Products>(context, listen: false).drawerProduct = null;
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: 'Add Product',
          dropDown: SizedBox(
            // height: height(context),
            width: 250,
            child: CustomAutoComplete(
                onChange: (Category val) {
                  getProductsByCatId(val.id);
                },
                categories: categories),
          ),
        ),
        //Filter bar

        //main area//
        SizedBox(
          height: height(context) * 4,
        ),
        Expanded(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width1 < 900 ? 3 : 4,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            content: Hero(
                              tag: products[index].id,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Image.network(
                                    products[index].image,
                                  ),
                                  Align(
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
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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
                                  if (currentUser!.role!.toLowerCase() ==
                                      'admin')
                                    PopupMenuButton(
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: primaryColor.withOpacity(0.8),
                                      ),
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: PopupItem(
                                            icon: Icons.edit_outlined,
                                            text: 'Edit',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Provider.of<Products>(context,
                                                      listen: false)
                                                  .setProduct(products[index]);

                                              widget.scaffoldKey.currentState!
                                                  .openEndDrawer();
                                            },
                                          ),
                                        ),
                                        PopupMenuItem(
                                          child: PopupItem(
                                            icon: Icons.delete,
                                            text: 'Delete',
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              _deleteProduct(
                                                  imgUrl: products[index].image,
                                                  prodId: products[index].id);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              Product productToSend =
                                                  products[index];
                                              return AlertDialog(
                                                title: Center(
                                                  child: Text(
                                                    'Select Users',
                                                    style:
                                                        GoogleFonts.righteous(
                                                      color: headingColor,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                ),
                                                content: StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                  return Container(
                                                    height:
                                                        height(context) * 50,
                                                    width: width(context) * 50,
                                                    child: Column(
                                                      children: [
                                                        TextField(
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      'Search User',
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color:
                                                                          primaryColor,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid,
                                                                    ),
                                                                  ),
                                                                  border:
                                                                      const OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 1,
                                                                      style: BorderStyle
                                                                          .solid,
                                                                    ),
                                                                  ),
                                                                  focusColor:
                                                                      primaryColor,
                                                                  fillColor:
                                                                      primaryColor,
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color:
                                                                        primaryColor,
                                                                  )),
                                                          onChanged: (val) {
                                                            setState(() {
                                                              filteredUser =
                                                                  customers
                                                                      .where(
                                                                        (element) => element
                                                                            .name
                                                                            .toLowerCase()
                                                                            .contains(val.toLowerCase()),
                                                                      )
                                                                      .toList();
                                                            });
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height(context) *
                                                                  2,
                                                        ),
                                                        Expanded(
                                                          child:
                                                              ListView.builder(
                                                                  itemCount: filteredUser.isEmpty
                                                                      ? customers
                                                                          .length
                                                                      : filteredUser
                                                                          .length,
                                                                  itemBuilder:
                                                                      (ctx,
                                                                          index) {
                                                                    return Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          color: primaryColor.withOpacity(
                                                                              0.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(5)),
                                                                      child:
                                                                          ListTile(
                                                                        title:
                                                                            Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.person_outline,
                                                                              color: primaryColor,
                                                                            ),
                                                                            SizedBox(
                                                                              width: width(context) * 1,
                                                                            ),
                                                                            Text(
                                                                              filteredUser.isEmpty ? customers[index].name : filteredUser[index].name,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        trailing: IconButton(
                                                                            onPressed: () {
                                                                              Provider.of<SentProducts>(ctx, listen: false).addProduct(product: productToSend, userId: customers[index].id);
                                                                              Navigator.of(ctx).pop();
                                                                            },
                                                                            icon: Icon(
                                                                              Icons.send_outlined,
                                                                              color: primaryColor,
                                                                            )),
                                                                      ),
                                                                    );
                                                                  }),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.send,
                                        color: primaryColor,
                                      ))
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
                            child: Image.network(
                              key: ValueKey(products[index].id),
                              products[index].image,
                            ),
                          ),
                        ),
                      ),
                    );

                    // Container(
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(
                    //               0.4,
                    //             ),
                    //             offset: const Offset(0, 5),
                    //             blurRadius: 20,
                    //             spreadRadius: 1,
                    //           ),
                    //           BoxShadow(
                    //             color: Colors.grey.withOpacity(
                    //               0.5,
                    //             ),
                    //             offset: -Offset(5, 0),
                    //             blurRadius: 5,
                    //             spreadRadius: 1,
                    //           ),
                    //         ],
                    //         borderRadius: customRadius),
                    //     child: Column(
                    //         mainAxisSize: MainAxisSize.min,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           InkWell(
                    //             onTap: () {
                    //               showDialog(
                    //                   context: context,
                    //                   builder: (ctx) => AlertDialog(
                    //                         content: Hero(
                    //                           tag: products[index].id,
                    //                           child: Image.network(
                    //                             products[index].image,
                    //                           ),
                    //                         ),
                    //                       ));
                    //             },
                    //             child: Container(
                    //               decoration: const BoxDecoration(),
                    //               child: ClipRRect(
                    //                 borderRadius: customRadius,
                    //                 child: Hero(
                    //                   tag: products[index].id,
                    //                   child: Image.network(
                    //                     products[index].image,
                    //                     fit: BoxFit.cover,
                    //                     height: height(context) * 25,
                    //                     width: double.infinity,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: height(context) * 1,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Column(
                    //                 mainAxisSize: MainAxisSize.min,
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   FittedBox(
                    //                     child: Text(
                    //                       products[index].name,
                    //                       style: GoogleFonts.righteous(
                    //                         color: primaryColor,
                    //                         fontSize: 25,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   SizedBox(
                    //                     height: height(context) * 0.5,
                    //                   ),
                    //                   FittedBox(
                    //                     child: Row(
                    //                       children: [
                    //                         Text(
                    //                           'Article No :',
                    //                           style: TextStyle(
                    //                               color: headingColor,
                    //                               fontSize: 16),
                    //                         ),
                    //                         SizedBox(
                    //                           width: width(context) * 0.5,
                    //                         ),
                    //                         Text(
                    //                           products[index].name,
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   )
                    //                 ],
                    //               ),
                    //               PopupMenuButton(
                    //                 icon: Icon(
                    //                   Icons.more_vert,
                    //                   color: headingColor,
                    //                 ),
                    //                 itemBuilder: (BuildContext context) =>
                    //                     <PopupMenuEntry>[
                    //                   PopupMenuItem(
                    //                     child: PopupItem(
                    //                       icon: Icons.edit_outlined,
                    //                       text: 'Edit',
                    //                       onTap: () {
                    //                         Navigator.of(context).pop();
                    //                         Provider.of<Products>(context,
                    //                                 listen: false)
                    //                             .setProduct(products[index]);

                    //                         widget.scaffoldKey.currentState!
                    //                             .openEndDrawer();
                    //                       },
                    //                     ),
                    //                   ),
                    //                   PopupMenuItem(
                    //                     child: PopupItem(
                    //                       icon: Icons.delete,
                    //                       text: 'Delete',
                    //                       onTap: () {
                    //                         Navigator.of(context).pop();
                    //                         _deleteProduct(
                    //                             imgUrl: products[index].image,
                    //                             prodId: products[index].id);
                    //                       },
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ],
                    //           ),
                    //         ]));
                  },
                ),
        )
        //main area end
      ],
    );
  }
}

class PopupItem extends StatelessWidget {
  PopupItem({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
  }) : super(key: key);
  String text;
  IconData icon;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: primaryColor),
          ),
          Icon(
            icon,
            color: primaryColor,
          )
        ],
      ),
    );
  }
}
