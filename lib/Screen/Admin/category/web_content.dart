import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Widget/adaptiveDialog.dart';
import 'package:anees_costing/Widget/desk_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/contant.dart';

import '../../../Models/category.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/grad_button.dart';

class CategoryWebContent extends StatefulWidget {
  const CategoryWebContent({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<CategoryWebContent> createState() => _CategoryWebContentState();
}

class _CategoryWebContentState extends State<CategoryWebContent> {
  bool isFirst = true;
  bool isLoading = false;
  final categoryController = TextEditingController();
  List<Category> categories = [];
  List<Category> searchedCat = [];
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      isFirst = false;
      if (Provider.of<Categories>(context, listen: false).categories.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Categories>(context, listen: false)
            .fetchAndUpdateCat(currentUser!.token)
            .then(
          (value) {
            setState(() {
              isLoading = false;
            });
          },
        );
      }
    }
    super.didChangeDependencies();
  }

  void deleteCat(Category cat) {
    bool isParent = false;
    List<Category> childCat =
        Provider.of<Categories>(context, listen: false).childCategories;
    for (var element in childCat) {
      if (element.parentId == cat.id) {
        isParent = true;
        break;
      }
    }
    if (isParent) {
      showCustomDialog(
          context: context,
          title: "Parent Category",
          btn1: null,
          content: "Parent category can't be deleted.",
          btn2: "Ok",
          btn1Pressed: null,
          btn2Pressed: () => Navigator.of(context).pop());
    } else {
      showCustomDialog(
          context: context,
          title: 'Delete',
          btn1: 'Yes',
          content: 'Do You want to "${cat.title}" Category?',
          btn2: 'No',
          btn1Pressed: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = true;
            });
            Provider.of<Categories>(context, listen: false)
                .deleteCategory(cat.id, currentUser!.token)
                .then((value) async {
              await Provider.of<Categories>(context, listen: false)
                  .fetchAndUpdateCat(currentUser!.token);
              setState(() {
                isLoading = false;
              });
            });
          },
          btn2Pressed: () {
            Navigator.of(context).pop();
          });
    }
  }

  refreshSearchedCats(Category val) {
    Provider.of<Categories>(context, listen: false).getCategoriesByTitle(val);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    categories = Provider.of<Categories>(context, listen: false).categories;
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    searchedCat =
        Provider.of<Categories>(context, listen: false).searchedCategories;
    if (searchedCat.isNotEmpty) {
      categories = searchedCat;
      Provider.of<Categories>(context, listen: false).resetSearchedCats();
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: btnbgColor.withOpacity(0.6), width: 1),
            color: Colors.white,
            boxShadow: shadow,
            borderRadius: customRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  WebAutoComplete(
                    onRefresh: () {
                      setState(() {});
                    },
                    onChange: (val) {
                      refreshSearchedCats(val);
                    },
                    categories: categories,
                    users: null,
                  ),
                ],
              ),
              if (currentUser!.role!.toLowerCase() == 'admin')
                GradientButton(
                  onTap: () {
                    Provider.of<Categories>(context, listen: false)
                        .drawerCategory = null;
                    widget.scaffoldKey.currentState!.openEndDrawer();
                  },
                  title: "Add New Category",
                ),
            ],
          ),
        ),
        SizedBox(
          height: height(context) * 2,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: customRadius,
              boxShadow: shadow,
            ),
            child: Column(
              children: [
                RowDetail(
                    first: const HeadingName(title: "Name"),
                    second: const HeadingName(title: "Parent Category"),
                    third: TextButton(
                      child: const HeadingName(title: "Delete"),
                      onPressed: () {},
                    ),
                    isHeading: true),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: AdaptiveIndecator(color: primaryColor),
                        )
                      : ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (ctx, index) => RowDetail(
                              first: RowItem(
                                title: categories[index].title,
                              ),
                              second: RowItem(
                                title: categories[index].parentTitle.isEmpty
                                    ? 'P'
                                    : categories[index].parentTitle,
                              ),
                              third: InkWell(
                                onTap: () {
                                  if (currentUser!.role!.toLowerCase() !=
                                      'admin') {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) => AdaptiveDiaglog(
                                            ctx: ctx,
                                            title: 'Access Denied',
                                            content:
                                                'Only admin can delete Categories',
                                            btnYes: 'Okay',
                                            yesPressed: () {
                                              Navigator.of(context).pop();
                                            }));
                                  } else {
                                    deleteCat(categories[index]);
                                  }
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0, 5),
                                            blurRadius: 5),
                                      ]),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              isHeading: false),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HeadingName extends StatelessWidget {
  const HeadingName({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: GoogleFonts.righteous(
        fontSize: 18,
        color: primaryColor,
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  const RowItem({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: headingColor,
      ),
    );
  }
}

class RowDetail extends StatelessWidget {
  final Widget first;
  final Widget second;
  final Widget third;
  final bool isHeading;
  const RowDetail(
      {Key? key,
      required this.first,
      required this.second,
      required this.third,
      required this.isHeading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            border: Border.all(color: btnbgColor.withOpacity(0.6), width: 1),
            color: isHeading ? btnbgColor.withOpacity(0.5) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(0, 5),
                blurRadius: 10,
              ),
            ]),
        margin: const EdgeInsets.only(bottom: 20),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [first, second, third])
          ],
        )

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [first, second, third],
        // ),
        );
  }
}
