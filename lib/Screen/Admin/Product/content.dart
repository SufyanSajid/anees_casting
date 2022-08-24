import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/filterbar.dart';
import '../../../Helpers/storage_methods.dart';
import '../../../Widget/dropDown.dart';

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
      Provider.of<Products>(context).fetchAndUpdateProducts().then((value) {
        setState(
          () {
            isLoading = false;
          },
        );
      });
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
                    var provider =
                        Provider.of<Products>(context, listen: false);
                    await StorageMethods().deleteImage(imgUrl: imgUrl);

                    await provider.deleteProduct(prodId);
                    await provider.fetchAndUpdateProducts();

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var width1 = MediaQuery.of(context).size.width;
    products = Provider.of<Products>(context).products;
    return Column(
      children: [
        //Filter bar
        buildFilterBar(
          context: context,
          searchConttroller: _designController,
          btnTap: () {
            Provider.of<Products>(context, listen: false).drawerProduct = null;
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: 'Add New Design',
          dropDown: CustomDropDown(
            onChanged: (value) {
              print(value);
            },
            items: const [
              'By Date',
              'By Article',
            ],
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
                    crossAxisCount: width1 < 1300 ? 4 : 4,
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                            content: Hero(
                                              tag: products[index].id,
                                              child: Image.network(
                                                products[index].image,
                                              ),
                                            ),
                                          ));
                                },
                                child: Container(
                                  decoration: const BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius: customRadius,
                                    child: Hero(
                                      tag: products[index].id,
                                      child: Image.network(
                                        products[index].image,
                                        fit: BoxFit.cover,
                                        height: height(context) * 25,
                                        width: double.infinity,
                                      ),
                                    ),
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
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FittedBox(
                                        child: Text(
                                          products[index].name,
                                          style: GoogleFonts.righteous(
                                            color: primaryColor,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height(context) * 0.5,
                                      ),
                                      FittedBox(
                                        child: Row(
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
                                              products[index].name,
                                            ),
                                          ],
                                        ),
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
