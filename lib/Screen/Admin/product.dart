import '/Helpers/storage_methods.dart';
import '/Screen/Admin/addproduct.dart';

import '/Models/product.dart';
import '/Widget/appbar.dart';
import '/Widget/customautocomplete.dart';
import '/Widget/dropDown.dart';
import '/Widget/input_feild.dart';
import '/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/category.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/productscreen';

  ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _productController = TextEditingController();
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      Provider.of<Products>(context).fetchAndUpdateProducts();
    }
    super.didChangeDependencies();
  }

  _deleteProduct({required imgUrl, required prodId}) async {
    var provider = Provider.of<Products>(context, listen: false);
    await StorageMethods().deleteImage(imgUrl: imgUrl);

    await provider.deleteProduct(prodId);
  }

  @override
  void dispose() {
    _productController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Product> products = Provider.of<Products>(context).products;
    List<Category> categories =
        Provider.of<Categories>(context, listen: false).categories;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'Product',
                subtitle: 'List of Products',
                svgIcon: 'assets/icons/daimond.svg',
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
              CustomAutoComplete(
                categories: categories,
                onChange: () {},
              ),
              SizedBox(
                height: height(context) * 1,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: InputFeild(
                      hinntText: 'Search Product',
                      validatior: () {},
                      inputController: _productController,
                    ),
                  ),
                  SizedBox(
                    width: width(context) * 3,
                  ),
                  Expanded(
                    flex: 4,
                    child: CustomDropDown(
                      items: const [
                        'By Date',
                        'By Article',
                      ],
                      onChanged: (value) {},
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height(context) * 3,
              ),
              Expanded(
                child: GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
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
                            products[index].image,
                            fit: BoxFit.contain,
                            height: height(context) * 12,
                            width: width(context) * 100,
                          ),
                          SizedBox(
                            height: height(context) * 0.5,
                          ),
                          // Text(
                          //   products[index].name,
                          //   style: GoogleFonts.righteous(
                          //     color: headingColor,
                          //     fontWeight: FontWeight.w500,
                          //     fontSize: 20,
                          //   ),
                          // ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _deleteProduct(
                                      imgUrl: products[index].image,
                                      prodId: products[index].id);
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, AddProduct.routeName,
                                      arguments: {
                                        "action": "edit",
                                        "imgUrl": products[index].image
                                      });
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: height(context) * 1,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     FittedBox(
                          //       child: Text(
                          //         products[index].dateTime,
                          //         style: GoogleFonts.righteous(
                          //           color: headingColor,
                          //           fontWeight: FontWeight.w500,
                          //           fontSize: 16,
                          //         ),
                          //       ),
                          //     ),
                          //     Text(
                          //       products[index].dateTime.runtimeType.toString(),
                          //       style: TextStyle(
                          //         color: contentColor,
                          //         fontSize: 16,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(AddProduct.routeName, arguments: {
            "action": "add",
          });
        },
      ),
    );
  }
}
