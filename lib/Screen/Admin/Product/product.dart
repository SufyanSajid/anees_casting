import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Functions/showloader.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Screen/Admin/Product/content.dart';
import 'package:anees_costing/Screen/Admin/Product/functions/getproductbycatid.dart';
import 'package:anees_costing/Screen/Admin/Product/functions/getsearchedproducts.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/Widget/send_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Widget/adaptive_indecator.dart';
import '/Helpers/storage_methods.dart';
import 'addproduct.dart';

import '/Models/product.dart';
import '/Widget/appbar.dart';
import '/Widget/customautocomplete.dart';
import '/Widget/dropDown.dart';
import '/Widget/input_feild.dart';
import '/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/category.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/productscreen';

  ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productController = TextEditingController();
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;
  String selectedFilter = 'By Date';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context).currentUser;
      if (Provider.of<Products>(context, listen: false).products.isEmpty) {
        setState(() {
          isLoading = true;
        });
        Provider.of<Products>(context, listen: false)
            .fetchAndUpdateProducts(userToken: currentUser!.token)
            .then(
          (value) {
            setState(
              () {
                isLoading = false;
              },
            );
          },
        );
      }
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  _deleteProduct(
      {required imgUrl, required prodId, required Language langProvider}) {
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

          await provider.deleteProduct(prodId, currentUser!.token);

          setState(() {
            isLoading = false;
          });
        },
        btn2: langProvider.get('No'),
        btn2Pressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  void dispose() {
    _productController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).products;
    List<Category> categories =
        Provider.of<Categories>(context, listen: false).categories;

    String? token = Provider.of<Products>(context).pageToken;
    Language languageProvider = Provider.of<Language>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Appbar(
                title: languageProvider.get('Product'),
                subtitle: languageProvider.get('List of Products'),
                svgIcon: 'assets/icons/daimond.svg',
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
                height: height(context) * 2,
              ),
              // CustomAutoComplete(
              //   categories: categories,
              //   onChange: (Category category) {
              //     getProductsByCatId(category.id, context);
              //   },
              // ),
              // SizedBox(
              //   height: height(context) * 1,
              // ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: InputFeild(
                      hinntText: languageProvider.get('Search Product'),
                      validatior: () {},
                      inputController: _productController,
                      submitted: (value) {
                        getSearchedProduct(value, context);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PopupMenuButton(
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
                                .fetchAndUpdateProducts(
                                    userToken: currentUser!.token);
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
                  ),
                ],
              ),
              SizedBox(
                height: height(context) * 3,
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: AdaptiveIndecator(
                          color: primaryColor,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () async {
                          // setState(() {
                          //   isLoading=true;
                          // });
                          await Provider.of<Products>(context, listen: false)
                              .fetchAndUpdateProducts(
                                  userToken: currentUser!.token);
                        },
                        child: GridView.builder(
                          cacheExtent: 9999,
                          // physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 15.0,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return Container(
                              key: ValueKey(products[index].id),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      offset: const Offset(0, 5),
                                      blurRadius: 15),
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      offset: -Offset(5, 0),
                                      blurRadius: 5)
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ProductDetailScreen.routeName,
                                              arguments: products[index]);
                                        },
                                        child: ExtendedImage.network(
                                          products[index].image,
                                          // height: height(context) * 10,
                                          fit: BoxFit.cover,
                                          cache: true,
                                        )
                                        // Image.network(
                                        //   products[index].image,
                                        //   fit: BoxFit.contain,
                                        //   height: height(context) * 12,
                                        //   width: width(context) * 100,
                                        // ),
                                        ),
                                  ),
                                  SizedBox(
                                    height: height(context) * 0.5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              products[index].name,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.righteous(
                                                color: headingColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 6,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
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
                                                        icon:
                                                            Icons.edit_outlined,
                                                        text: languageProvider
                                                            .get('Edit'),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Navigator.pushNamed(
                                                              context,
                                                              AddProduct
                                                                  .routeName,
                                                              arguments: {
                                                                "action":
                                                                    "edit",
                                                                "product":
                                                                    products[
                                                                        index]
                                                              });
                                                        },
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      child: PopupItem(
                                                        icon: Icons.delete,
                                                        text: languageProvider
                                                            .get('Delete'),
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          _deleteProduct(
                                                              langProvider:
                                                                  languageProvider,
                                                              imgUrl: products[
                                                                      index]
                                                                  .image,
                                                              prodId: products[
                                                                      index]
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: currentUser!.role!.toLowerCase() == 'admin'
          ? Row(
              mainAxisAlignment: token != null
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30),
                  decoration: BoxDecoration(
                      gradient: customGradient, shape: BoxShape.circle),
                  child: FloatingActionButton(
                    heroTag: DateTime.now().microsecond,
                    backgroundColor: Colors.transparent,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(AddProduct.routeName, arguments: {
                        "action": "add",
                      });
                    },
                  ),
                ),
                if (token != null)
                  Container(
                    decoration: BoxDecoration(
                        gradient: customGradient, shape: BoxShape.circle),
                    child: FloatingActionButton(
                      backgroundColor: Colors.transparent,
                      child: Text(languageProvider.get('Load More')),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Provider.of<Products>(context, listen: false)
                            .fetchAndUpdateProducts(
                                userToken: currentUser!.token)
                            .then((value) {
                          setState(() {
                            isLoading = false;
                          });
                        });
                      },
                    ),
                  ),
              ],
            )
          : null,
    );
  }
}
