import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/language.dart';
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
      _nameController.text = category!.title.split('-').first;
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

  void editCat(Category cat, String parentId) async {
    var navi = Navigator.of(context);
    var catProvider = Provider.of<Categories>(context, listen: false);

    setState(() {
      isCatLoading = true;
    });
    await catProvider.EditCategory(
        userToken: currentUser!.token,
        parentId: parentId,
        title: _nameController.text.trim(),
        catId: cat.id);
    print('hu gya');
    await catProvider.fetchAndUpdateCat(currentUser!.token);
    setState(() {
      isCatLoading = false;
      _nameController.clear();
    });
    navi.pop();
  }

  _uploadCat({required Language lanProvider}) async {
    var navi = Navigator.of(context);
    var catProvider = Provider.of<Categories>(context, listen: false);

    if (catProvider.isCatExist(
        title: _nameController.text.trim(), parentTitle: parentTitle ?? "")) {
      showCustomDialog(
          context: context,
          title: lanProvider.get("Alert"),
          btn1: null,
          content: lanProvider.get("Category already exist"),
          btn2: lanProvider.get("OK"),
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
    Language languageProvider = Provider.of<Language>(context, listen: true);

    return Column(
      children: [
        CustomAutoComplete(
            categories: categories,
            firstSelction: category == null
                ? null
                : category!.parentTitle.split('-').first,
            onChange: (Category cat) {
              parentId = cat.id;
              parentTitle = cat.title;
            }),
        SizedBox(
          height: height(context) * 2,
        ),
        InputFeild(
          hinntText: languageProvider.get('Category Name'),
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
                  category == null
                      ? _uploadCat(lanProvider: languageProvider)
                      : editCat(category!, parentId == null ? '' : parentId!);
                  
                },
                title: category != null
                    ? languageProvider.get('Edit Category')
                    : languageProvider.get('Add Category'))
      ],
    );
  }
}
