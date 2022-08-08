import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Widget/appbar.dart';
import '../../contant.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';
  CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _nameController = TextEditingController();

  String? parentId;
  bool isUpLoadingCat = false;

  addCategory(BuildContext context, String parentId, String title) async {
    var provider = Provider.of<Categories>(context, listen: false);
    if (title.isNotEmpty) {
      await Provider.of<Categories>(context, listen: false)
          .uploadCatagory(parentId, title);
      provider.fetchAndUpdateCategoris();
    }

    _nameController.text = "";
    setState(() {
      isUpLoadingCat = false;
    });
  }

  bool isFirst = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (isFirst) {
      isFirst = false;
      Provider.of<Categories>(context, listen: false).fetchAndUpdateCategoris();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<Categories>(context).categories;
    List<Category> parentCategories =
        Provider.of<Categories>(context).parentCategories;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: Container(
        decoration:
            BoxDecoration(gradient: primaryGradient, shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          onPressed: () {
            setState(() {
              isUpLoadingCat = true;
            });
          },
          child: const Icon(
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
              if (isUpLoadingCat)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomAutoComplete(
                        categories: parentCategories,
                        onChange: (Category val) {
                          parentId = val.id;
                        }),
                    const SizedBox(
                      height: 30,
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
                        width: width(context) / 2,
                        onTap: () async {
                          addCategory(context, parentId ?? "",
                              _nameController.text.trim());
                        },
                        title: 'Add Category')
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: GridView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
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
                          boxShadow: const [
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
                              categories[index].title,
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
