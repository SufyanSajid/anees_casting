import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Screen/Admin/Product/components/formfeilds.dart';
import 'package:anees_costing/Screen/Admin/users/add_user.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../Models/category.dart';
import '../customautocomplete.dart';
import '../input_feild.dart';
import '../submitbutton.dart';

class WebDrawer extends StatelessWidget {
  WebDrawer({
    Key? key,
    required this.selectedIndex,
    this.category,
  }) : super(key: key);

  int selectedIndex;
  Category? category;

  bool isCategoryEmpty() {
    if (category == null) {
      return true;
    } else {
      return false;
    }
  }

  bool isProductEmpty(BuildContext context) {
    var prod = Provider.of<Products>(context, listen: false).drawerProduct;
    if (prod == null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 25),
      width: width(context) * 35,
      color: Colors.white,
      child: SizedBox(
        height: height(context) * 100,
        child: Column(
          children: [
            if (selectedIndex == 1)
              DrawerAppbar(
                title: 'Design',
                subTitle:
                    isProductEmpty(context) ? 'Add New Design' : 'Edit Design',
                svgIcon: 'assets/icons/daimond.svg',
              ),
            if (selectedIndex == 3)
              DrawerAppbar(
                title: 'Category',
                subTitle:
                    isCategoryEmpty() ? 'Add New Category' : 'Edit Category',
                svgIcon: 'assets/icons/category.svg',
              ),
            if (selectedIndex == 2)
              DrawerAppbar(
                title: 'Users',
                subTitle: 'Add New Users',
                svgIcon: 'assets/icons/profile.svg',
              ),
            SizedBox(
              height: height(context) * 5,
            ),

            //Feilds Area
            if (selectedIndex == 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AddProductFeilds(),
              ),
            if (selectedIndex == 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AddCategoryFeilds(
                  category: category,
                ),
              ),
            if (selectedIndex == 2)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: AddUserFeilds(),
              ),

            //Feilds Area End
          ],
        ),
      ),
    );
  }
}

class AddCategoryFeilds extends StatefulWidget {
  AddCategoryFeilds({
    Key? key,
    this.category,
  }) : super(key: key);

  Category? category;
  @override
  State<AddCategoryFeilds> createState() => _AddCategoryFeildsState();
}

class _AddCategoryFeildsState extends State<AddCategoryFeilds> {
  final _nameController = TextEditingController();

  String? parentId;
  bool isCatLoading = false;
  bool isFirst = true;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.category != null) {
      _nameController.text = widget.category!.title.toString();
    } else {
      _nameController.text = '';
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;

      Provider.of<Categories>(context).fetchAndUpdateCat();
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        Provider.of<Categories>(context, listen: false).categories;
    List<Category> parentCategories =
        Provider.of<Categories>(context, listen: false).parentCategories;
    return Column(
      children: [
        CustomAutoComplete(
            categories: parentCategories,
            onChange: (Category cat) {
              parentId = cat.id;
            }),
        SizedBox(
          height: height(context) * 2,
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
            onTap: () async {
              // setState(() {
              //   isCatLoading = true;
              // });
              // var navi = Navigator.of(context);
              // var provider = Provider.of<Categories>(context, listen: false);
              // await provider.uploadCatagory(
              //     parentId ?? "", _nameController.text.trim());
              // await provider.fetchAndUpdateCat();
              // setState(() {
              //   _nameController.clear();
              //   isCatLoading = false;
              // });

              // navi.pop();
            },
            title: widget.category != null ? 'Edit Category' : 'Add Category')
      ],
    );
  }
}

class DrawerAppbar extends StatelessWidget {
  DrawerAppbar({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.svgIcon,
  }) : super(key: key);

  String svgIcon;
  String title;
  String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgIcon,
          height: 50,
          color: primaryColor,
        ),
        SizedBox(
          height: height(context) * 1,
        ),
        Text(
          title,
          style: GoogleFonts.righteous(
            fontSize: 20,
            color: headingColor,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: height(context) * 0.1,
                  color: Color.fromRGBO(197, 154, 120, 1),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    subTitle,
                    style: TextStyle(color: contentColor),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: height(context) * 0.1,
                  color: Color.fromRGBO(197, 154, 120, 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
