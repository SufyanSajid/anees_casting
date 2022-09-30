import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../../Models/sent_products.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';
import '../../../Widget/snakbar.dart';

class AdminSideCustomerProductScreen extends StatefulWidget {
  static const routeName = '/customers-products-details';
  const AdminSideCustomerProductScreen({super.key});

  @override
  State<AdminSideCustomerProductScreen> createState() =>
      _AdminSideCustomerProductScreenState();
}

class _AdminSideCustomerProductScreenState
    extends State<AdminSideCustomerProductScreen> {
  List<Product>? products;
  bool isFirst = true;
  bool isLoading = false;
  AUser? customer;
  CurrentUser? currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      currentUser = Provider.of<Auth>(context).currentUser;
      setState(() {
        isLoading = true;
      });

      customer = ModalRoute.of(context)!.settings.arguments as AUser;

      await Provider.of<Products>(context, listen: false)
          .getCustomerProducts(customer!.id, currentUser!.token);
      setState(() {
        isLoading = false;
      });
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void deleteCustomerProduct(Product prod, String cusId, Language langProvider) {
    showCustomDialog(
        context: context,
        title: langProvider.get('Delete') ,
        btn1: langProvider.get('Yes') ,
        content: langProvider.get('Product will be deleted from the list permamently') ,
        btn2: langProvider.get('No') ,
        btn1Pressed: () async {
          Navigator.of(context).pop();
          setState(() {
            isLoading = true;
          });
          Provider.of<Products>(context, listen: false)
              .deleteCustomerProduct(
                  prodId: prod.id, userId: cusId, userToken: currentUser!.token)
              .then((value) async {
            showMySnackBar(
                context: context, text: langProvider.get("Product has been deleted") );
            Provider.of<Products>(context, listen: false)
                .removeCustomer(cusId, prod.id);
            await Provider.of<Products>(context, listen: false)
                .getCustomerProducts(customer!.id, currentUser!.token);
            setState(() {
              isLoading = false;
            });
          }).catchError((error) {
            showCustomDialog(
                context: context,
                title: langProvider.get('Error') ,
                btn1: langProvider.get('Okay') ,
                content: error.toString(),
                btn1Pressed: () {
                  Navigator.of(context).pop();
                });
          });
        },
        btn2Pressed: () {
          Navigator.of(context).pop();
        });
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<Products>(context).customerProducts;
    Language languageProvider = Provider.of<Language>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Appbar(
                title: languageProvider.get('Customer') ,
                subtitle: customer!.name,
                svgIcon: 'assets/icons/users.svg',
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
              Expanded(
                child: isLoading
                    ? Center(
                        child: AdaptiveIndecator(
                          color: primaryColor,
                        ),
                      )
                    : products!.isEmpty
                        ? Center(
                            child: Text(languageProvider.get('No Products to show') ),
                          )
                        : GridView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 15.0,
                            ),
                            itemCount: products!.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          ProductDetailScreen.routeName,
                                          arguments: products![index]);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              offset: const Offset(0, 5),
                                              blurRadius: 15),
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              offset: -Offset(5, 0),
                                              blurRadius: 5)
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ExtendedImage.network(
                                            products![index].image,
                                            cache: true,
                                            fit: BoxFit.contain,
                                            height: height(context) * 12,
                                            width: width(context) * 100,
                                          ),
                                          SizedBox(
                                            height: height(context) * 0.5,
                                          ),
                                          Text(
                                            products![index].name,
                                            style: GoogleFonts.righteous(
                                              color: headingColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Material(
                                      child: IconButton(
                                        onPressed: () {
                                          deleteCustomerProduct(
                                              products![index], customer!.id, languageProvider);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          size: 30,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
