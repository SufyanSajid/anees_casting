import 'package:anees_costing/Screen/Admin/Product/customerproducts.dart';
import 'package:anees_costing/Screen/Customer/customer_products.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/user.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';

class CustomerScreen extends StatefulWidget {
  static const routeName = '/customers';
  CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<AUser>? customers;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    customers = Provider.of<Users>(context, listen: false).customers;
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
                title: 'Customer',
                subtitle: 'Customer Details',
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
                    : ListView.builder(
                        itemCount: customers!.length,
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                AdminSideCustomerProductScreen.routeName,
                                arguments: customers![index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: btnbgColor.withOpacity(0.6),
                                    width: 1),
                                color: customers![index].isBlocked
                                    ? Colors.grey[200]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    offset: const Offset(0, 5),
                                    blurRadius: 10,
                                  ),
                                ]),
                            margin: const EdgeInsets.only(bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: height(context) * 6,
                                      width: height(context) * 6,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              style: BorderStyle.solid,
                                              width: 2,
                                              color: btnbgColor.withOpacity(1)),
                                          borderRadius:
                                              BorderRadius.circular(50)),
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
                                      width: width(context) * 4,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          customers![index].name,
                                          style: TextStyle(
                                            color: headingColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: height(context) * 0.5,
                                        ),
                                        Text(
                                          customers![index].phone,
                                          style: TextStyle(
                                              color: contentColor,
                                              fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      customers![index].isBlocked
                                          ? 'Blocked'
                                          : 'Active',
                                      style: TextStyle(
                                          color: customers![index].isBlocked
                                              ? Colors.red
                                              : Colors.green),
                                    ),
                                    SizedBox(
                                      width: width(context) * 3,
                                    ),
                                    Switch(
                                      value: customers![index].isBlocked,
                                      activeColor: Colors.red,
                                      inactiveTrackColor: Colors.green,
                                      thumbColor: MaterialStateProperty.all(
                                          Colors.white),
                                      onChanged: (value) async {
                                        print(value);
                                        var provider = Provider.of<Users>(ctx,
                                            listen: false);

                                        await provider.blockUser(
                                            user: customers![index],
                                            block: value);

                                        setState(() {
                                          customers![index].isBlocked =
                                              !customers![index].isBlocked;
                                        });
                                        await provider.fetchAndUpdateUser();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
