import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Widget/adaptive_indecator.dart';
import '../../Widget/input_feild.dart';

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
      await Provider.of<Products>(context, listen: false)
          .getCustomerProducts(currentUser!.id, currentUser!.token);
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
    if (search.isEmpty) {
      products = Provider.of<Products>(context).customerProducts;
    }

    print(search);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppDrawer(),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: height(context) * 7.5,
                        width: height(context) * 7.5,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(style: BorderStyle.solid, width: 2),
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
                        width: width(context) * 2,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                                color: secondaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Dear Customer',
                            style: GoogleFonts.righteous(
                              color: primaryColor,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(
                      Icons.filter_list,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height(context) * 2.5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InputFeild(
                hinntText: 'Search Product',
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
                        products = Provider.of<Products>(context, listen: false)
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
            )
          ],
        ),
      ),
    );
  }
}
