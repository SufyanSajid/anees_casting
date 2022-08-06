import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/dropDown.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/productscreen';
  final _productController = TextEditingController();
  ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context, listen: false).products;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'Product',
                subtitle: 'List of Products',
                svgIcon: 'assets/icons/daimond.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              CustomAutoComplete(
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
                      items: [
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
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, 5),
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
                          Image.asset(
                            'assets/icons/ring.png',
                            height: height(context) * 10,
                            width: height(context) * 10,
                            fit: BoxFit.cover,
                          ),
                            SizedBox(
                            height: height(context)*0.5,
                          ),
                          Text(
                            products[index].name,
                            style: GoogleFonts.righteous(
                              color: headingColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: height(context)*1,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Category: ",
                                style: GoogleFonts.righteous(
                                  color: headingColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                products[index].category.name,
                                style: TextStyle(
                                  color: contentColor,
                                  
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
