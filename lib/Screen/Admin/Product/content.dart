import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/Design/catlist.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/grad_button.dart';
import 'package:anees_costing/contant.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/dailog.dart';
import '../../../Functions/filterbar.dart';
import '../../../Widget/send_button.dart';
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
  CurrentUser? currentUser;
  String selectedFilter = 'By Date';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      //FirestoreMethods().getProductsByCatId();
      currentUser = Provider.of<Auth>(context).currentUser;
      Provider.of<Products>(context, listen: false)
          .setScaffoldKey(widget.scaffoldKey);
      isFirst = false;
      if (Provider.of<Products>(context, listen: false).products.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Products>(context, listen: false)
            .fetchAndUpdateProducts(userToken: currentUser!.token)
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

  _deleteProduct(
      {required imgUrl,
      required Product prod,
      required Language langProvider}) {
    showCustomDialog(
        context: context,
        title: langProvider.get('Delete'),
        btn1: langProvider.get('Yes'),
        content: langProvider.get('Do You want to delete this product?'),
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
        btn2: langProvider.get('No'),
        btn2Pressed: () {
          Navigator.of(context).pop();
        });
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
    Language languageProvider = Provider.of<Language>(context, listen: true);
    var mediaQuery = MediaQuery.of(context).size;
    var height1 = mediaQuery.height / 100;
    var width1 = mediaQuery.width / 100;
    products = Provider.of<Products>(context).products;
    String? token = Provider.of<Products>(context).pageToken;
    List<Category> categories = Provider.of<Categories>(context).categories;
    List<AUser> customers = Provider.of<Users>(context).customers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //Filter bar

        buildFilterBar(
          searchSubmitted: (val) => getSearchedProduct(val, context),
          context: context,
          searchConttroller: _designController,
          CustomWidget: GradientButton(
            onTap: () {
              Navigator.of(context).pushNamed(CategoryListScreen.routeName);
            },
            title: languageProvider.get('By Category'),
          ),
          btnTap: () {
            Provider.of<Products>(context, listen: false).drawerProduct = null;
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: languageProvider.get('Add Product'),
          dropDown: SizedBox(
            // height: height(context),
            width: 250,
            child: Container(),
            // CustomAutoComplete(
            //     onChange: (Category val) {
            //       getProductsByCatId(val.id, context);
            //     },
            //     categories: categories),
          ),
        ),
        //Filter bar

        //main area//
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
                await Provider.of<Products>(context, listen: false)
                    .fetchAndUpdateProducts(userToken: currentUser!.token);
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
                    .setProductByName();
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
        SizedBox(
          height: height(context) * 0.5,
        ),
        Expanded(
          child: isLoading
              ? Center(
                  child: AdaptiveIndecator(
                    color: primaryColor,
                  ),
                )
              : GridView.builder(
                  cacheExtent: 9999,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: width(context) * 100 > 900 ? 4 : 3,
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
                                  Directionality(
                                    textDirection:
                                        languageProvider.currentLang ==
                                                language.Urdu
                                            ? TextDirection.rtl
                                            : TextDirection.ltr,
                                    child: Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Table(
                                          children: [
                                            TableRow(children: [
                                              Text(
                                                  "${languageProvider.get('Title')}: ${products[index].name}"),
                                              Text(
                                                  "${languageProvider.get('Cat')}:  ${products[index].categoryTitle}"),
                                              Text(
                                                  "${languageProvider.get('Unit')}:  ${products[index].unit}")
                                            ]),
                                            TableRow(children: [
                                              Text(
                                                  "${languageProvider.get('Length')}: ${products[index].length}"),
                                              Text(
                                                  "${languageProvider.get('Width')}:  ${products[index].width}"),
                                              Text(
                                                  "${languageProvider.get('Date')}:   ${products[index].dateTime} ")
                                            ])
                                          ],
                                        ),
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
                                color: btnbgColor.withOpacity(0.6), width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: GridTile(
                          footer: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            // height: height(context) * 5,

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
                                  child: Text(
                                    products[index].name,
                                    style: GoogleFonts.righteous(
                                      color: Colors.black54,
                                      fontSize:
                                          width(context) * 100 > 900 ? 18 : 12,
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
                                              text:
                                                  languageProvider.get('Edit'),
                                              onTap: () {
                                                Navigator.of(context).pop();

                                                Provider.of<Products>(context,
                                                        listen: false)
                                                    .setProduct(
                                                        products[index]);
                                                Provider.of<Products>(context,
                                                        listen: false)
                                                    .setScaffoldKey(
                                                        widget.scaffoldKey);

                                                widget.scaffoldKey.currentState!
                                                    .openEndDrawer();
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: PopupItem(
                                              icon: Icons.delete,
                                              text: languageProvider
                                                  .get('Delete'),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                _deleteProduct(
                                                    langProvider:
                                                        languageProvider,
                                                    imgUrl:
                                                        products[index].image,
                                                    prod: products[index]);
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
        if (token != null)
          GradientButton(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Products>(context, listen: false)
                    .fetchAndUpdateProducts(userToken: currentUser!.token)
                    .then((value) {
                  setState(
                    () {
                      isLoading = false;
                    },
                  );
                });
              },
              title: languageProvider.get('Load more'))

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
