import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Widget/adaptiveDialog.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/category.dart';
import '../../../../Widget/customautocomplete.dart';
import '../../../../Widget/input_feild.dart';
import '../../../../Widget/submitbutton.dart';
import '../../../../contant.dart';

class AddCategoryFeilds extends StatefulWidget {
  const AddCategoryFeilds({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCategoryFeilds> createState() => _AddCategoryFeildsState();
}

class _AddCategoryFeildsState extends State<AddCategoryFeilds> {
  final _nameController = TextEditingController();

  String? parentTitle;
  String? parentId;
  bool isCatLoading = false;
  bool isFirst = true;
  Category? category;
  CurrentUser? currentUser;

  @override
  void initState() {
    category = Provider.of<Categories>(context, listen: false).drawerCategory;
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    if (category != null) {
      _nameController.text = category!.title.toString();
    } else {
      _nameController.text = '';
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  _uploadCat() async {
    var navi = Navigator.of(context);
    var catProvider = Provider.of<Categories>(context, listen: false);
    var countProvider = Provider.of<Counts>(context, listen: false);

    if (catProvider.isCatExist(
        title: _nameController.text.trim(), parentTitle: parentTitle ?? "")) {
      showCustomDialog(
          context: context,
          title: "Alert",
          btn1: null,
          content: "Category already exist",
          btn2: "OK",
          btn1Pressed: null,
          btn2Pressed: () => Navigator.of(context).pop());
    } else {
      setState(() {
        isCatLoading = true;
      });

      await catProvider.uploadCatagory(
        title: _nameController.text.trim(),
        userToken: currentUser!.token,
        parentId: parentId ?? "",
      );

      await catProvider.fetchAndUpdateCat(currentUser!.token);
      countProvider.increaseCount(category: 1);
      setState(() {
        _nameController.clear();
        isCatLoading = false;
      });

      navi.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        Provider.of<Categories>(context, listen: false).categories;

    return Column(
      children: [
        CustomAutoComplete(
            categories: categories,
            onChange: (Category cat) {
              parentId = cat.id;
              parentTitle = cat.title;
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
        isCatLoading
            ? AdaptiveIndecator(
                color: primaryColor,
              )
            : SubmitButton(
                height: height(context),
                width: width(context),
                onTap: () {
                  _uploadCat();
                },
                title: category != null ? 'Edit Category' : 'Add Category')
      ],
    );
  }
}
