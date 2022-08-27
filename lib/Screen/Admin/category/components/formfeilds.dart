import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/category.dart';
import '../../../../Widget/customautocomplete.dart';
import '../../../../Widget/input_feild.dart';
import '../../../../Widget/submitbutton.dart';
import '../../../../contant.dart';

class AddCategoryFeilds extends StatefulWidget {
  AddCategoryFeilds({
    Key? key,
  }) : super(key: key);

  @override
  State<AddCategoryFeilds> createState() => _AddCategoryFeildsState();
}

class _AddCategoryFeildsState extends State<AddCategoryFeilds> {
  final _nameController = TextEditingController();

  String? parentId;
  bool isCatLoading = false;
  bool isFirst = true;
  Category? category;
  @override
  void initState() {
    category = Provider.of<Categories>(context, listen: false).drawerCategory;
    // TODO: implement initState
    if (category != null) {
      _nameController.text = category!.title.toString();
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
            title: category != null ? 'Edit Category' : 'Add Category')
      ],
    );
  }
}
