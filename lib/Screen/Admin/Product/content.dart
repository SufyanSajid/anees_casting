import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/filterbar.dart';

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
  List<Product> products = [];
  bool isFirst = true;
  bool isLoading = false;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchAndUpdateProducts();
      setState(
        () {
          isLoading = false;
        },
      );
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    products = Provider.of<Products>(context).products;
    return Column(
      children: [
        //Filter bar
        buildFilterBar(
          context: context,
          searchConttroller: _designController,
          btnTap: () {
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: 'Add New Design',
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                        padding: EdgeInsets.all(8),
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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(),
                                height: height(context) * 25,
                                width: width(context) * 20,
                                child: ClipRRect(
                                  borderRadius: customRadius,
                                  child: Image.network(
                                    products[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height(context) * 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        products[index].name,
                                        style: GoogleFonts.righteous(
                                          color: primaryColor,
                                          fontSize: 25,
                                        ),
                                      ),
                                      SizedBox(
                                        height: height(context) * 0.5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Article No :',
                                            style: TextStyle(
                                                color: headingColor,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            width: width(context) * 0.5,
                                          ),
                                          Text(
                                            products[index].id,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  PopupMenuButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: headingColor,
                                    ),
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child: PopupItem(
                                          icon: Icons.edit_outlined,
                                          text: 'Edit',
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: PopupItem(
                                            icon: Icons.delete, text: 'Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ]));
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
  }) : super(key: key);
  String text;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
