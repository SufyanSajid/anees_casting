import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Widget/appbar.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = '/categoryScreen';
  CategoryScreen({Key? key}) : super(key: key);
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<Categories>(context, listen: false).categories;
    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Container(
        decoration: BoxDecoration(
            gradient:primaryGradient,
            shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            showBottomSheet(
                context: context,
                builder: (ctx) => Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      height: height(context) * 40,
                      width: width(context) * 100,
                      child: Column(
                        children: [
                          Text(
                            'Add Nee Category',
                            style: GoogleFonts.righteous(
                              color: primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 4,
                          ),
                          InputFeild(
                            hinntText: 'Category Name',
                            validatior: () {},
                            inputController: _nameController,
                          ),
                          SizedBox(
                            height: height(context) * 2,
                          ),
                          SubmitButton(
                              height: height(context),
                              width: width(context),
                              onTap: () {},
                              title: 'Add Category')
                        ],
                      ),
                    ));
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'Category',
                subtitle: 'All Your Categories',
                svgIcon: 'assets/icons/category.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 3,
              ),
              Expanded(
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 25.0,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      splashColor: primaryColor,
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: primaryColor,
                              style: BorderStyle.solid,
                              width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 5),
                              blurRadius: 5,
                            )
                          ],
                        ),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              categories[index].name,
                              style: GoogleFonts.righteous(
                                color: headingColor,
                                fontSize: 20,
                              ),
                            )
                          ],
                        )),
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
