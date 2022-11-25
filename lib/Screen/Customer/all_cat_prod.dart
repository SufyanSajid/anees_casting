import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/pagination.dart';
import '../../Widget/adaptive_indecator.dart';
import '../../Widget/appbar.dart';
import '../../Widget/input_feild.dart';
import '../../Widget/paginate.dart';

class CustomerProductScreen extends StatefulWidget {
  static const routeName = '/customer-products';
  const CustomerProductScreen({super.key});

  @override
  State<CustomerProductScreen> createState() => _CustomerProductScreenState();
}

class _CustomerProductScreenState extends State<CustomerProductScreen> {
  final _productController = TextEditingController();
  CurrentUser? currentUser;
  List<Product>? products;
  String search = "";
  bool isLoading = false;
  bool isFirst = true;
  @override
  void didChangeDependencies() async {
    if (isFirst) {
      setState(() {
        isLoading = true;
      });
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      await Provider.of<Products>(context, listen: false).getCustomerProducts(
          page: '1', userId: currentUser!.id, userToken: currentUser!.token);
      setState(() {
        isLoading = false;
      });

      isFirst = false;
    }

    super.didChangeDependencies();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context, listen: true);
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
              userId: currentUser!.id,
              userToken: currentUser!.token)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }

    if (search.isEmpty) {
      products = Provider.of<Products>(context).customerProducts;
    }

    print(search);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Appbar(
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
              ),
              SizedBox(
                height: height(context) * 2.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InputFeild(
                  hinntText: languageProvider.get('Search Product'),
                  validatior: () {},
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        search = value;
                      });
                    } else {
                      setState(
                        () {
                          search = value;
                          products =
                              Provider.of<Products>(context, listen: false)
                                  .customerProducts
                                  .where((element) => element.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                        },
                      );
                    }
                  },
                  inputController: _productController,
                  // submitted: (value) {
                  //   if (value.isEmpty) {
                  //     // Provider.of<Products>(context, listen: false)
                  //     //     .getCustomerProducts(currentUser!.id)
                  //     //     .then((value) {
                  //     //   setState(() {
                  //     //     products = value;
                  //     //   });
                  //     // });
                  //   } else {
                  //     setState(
                  //       () {
                  //         products = products!
                  //             .where((element) =>
                  //                 element.name.toLowerCase() ==
                  //                 value.toLowerCase())
                  //             .toList();
                  //       },
                  //     );
                  // }
                  // },
                ),
              ),
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
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await Provider.of<Products>(context, listen: false)
                                .getCustomerProducts(
                                    userId: currentUser!.id,
                                    userToken: currentUser!.token);
                          },
                          child: GridView.builder(
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 15.0,
                            ),
                            itemCount: products!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProductDetailScreen.routeName,
                                      arguments: products![index]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
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
                              );
                            },
                          ),
                        ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
