import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';

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

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      setState(() {
        isLoading = true;
      });

      customer = ModalRoute.of(context)!.settings.arguments as AUser;

      products = await Provider.of<Products>(context, listen: false)
          .getCustomerProducts(customer!.id);
      setState(() {
        isLoading = false;
      });
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            children: [
              Appbar(
                title: 'Customer',
                subtitle: 'Customer Name',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
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
                                    Image.network(
                                      products![index].image,
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
      ),
    );
  }
}
