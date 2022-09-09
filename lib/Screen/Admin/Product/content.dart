import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/desk_autocomplete.dart';
import 'package:anees_costing/Widget/grad_button.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/filterbar.dart';
import '../../../Helpers/storage_methods.dart';
import '../../../Widget/send_button.dart';
import 'functions/getproductbycatid.dart';
import 'functions/getsearchedproducts.dart';

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
  bool isSending = false;
  bool isSended = false;
  String? receiverId;

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

  // getSearchedProduct(String search) {
  //   if (search.isEmpty) {
  //     Provider.of<Products>(context, listen: false).fetchAndUpdateProducts();
  //   } else {
  //     Provider.of<Products>(context, listen: false)
  //         .searchProduct(search, 'productName');
  //   }
  // }

  // getProductsByCatId(String catId) async {
  //   await Provider.of<Products>(context, listen: false)
  //       .searchProduct(catId, 'catId');
  // }

  @override
  Widget build(BuildContext context) {
    var width1 = MediaQuery.of(context).size.width;
    products = Provider.of<Products>(context).products;
    String? token = Provider.of<Products>(context).pageToken;
    List<Category> categories = Provider.of<Categories>(context).categories;
    List<AUser> customers = Provider.of<Users>(context).customers;
    var currentUser = Provider.of<Auth>(context).currentUser;

    return Column(
      children: [
        //Filter bar

        buildFilterBar(
          searchSubmitted: (val) => getSearchedProduct(val, context),
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
                  getProductsByCatId(val.id, context);
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
                  child: AdaptiveIndecator(
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
                                  SendProductButton(prod: products[index])
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
                  },
                ),
        ),
        if (token != null)
          GradientButton(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Products>(context, listen: false)
                    .fetchAndUpdateProducts()
                    .then((value) {
                  setState(
                    () {
                      isLoading = false;
                    },
                  );
                });
              },
              title: 'Load more')

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
