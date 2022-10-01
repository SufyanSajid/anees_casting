import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Widget/adaptiveDialog.dart';
import 'package:anees_costing/Widget/desk_autocomplete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/contant.dart';

import '../../../Models/category.dart';
import '../../../Models/product.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/grad_button.dart';
import '../../../Widget/snakbar.dart';

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
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
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

  void deleteCat(Category cat, Language lagnProvider) async {
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
      var provider = Provider.of<Products>(context, listen: false);
      provider.setLoader(false);
      showCustomDialog(
          context: context,
          title: lagnProvider.get("Parent Category"),
          btn1: null,
          content: lagnProvider.get('Parent category can\'t be deleted.'),
          btn2: lagnProvider.get('OK'),
          btn1Pressed: null,
          btn2Pressed: () => Navigator.of(context).pop());
    } else {
      var provider = Provider.of<Products>(context, listen: false);
      await Provider.of<Products>(context, listen: false)
          .getCatProducts(userToken: currentUser!.token, catId: cat.id);
      List<Product> prods =
          Provider.of<Products>(context, listen: false).catProducts;
      provider.setLoader(false);
      print('${prods.length}');
      if (prods.isNotEmpty) {
        provider.setLoader(false);
        showCustomDialog(
            context: context,
            title: lagnProvider.get('Delete'),
            btn1: lagnProvider.get('Okay'),
            content: lagnProvider
                .get('This Category contains products cannot deleted'),
            btn1Pressed: () {
              Navigator.of(context).pop();
            });
        return;
      } else {
        showCustomDialog(
            context: context,
            title: lagnProvider.get('Delete'),
            btn1: lagnProvider.get('Yes'),
            content:
                lagnProvider.get('Do You want to Delete') + " " + cat.title,
            btn2: lagnProvider.get('No'),
            btn1Pressed: () {
              Navigator.of(context).pop();
              setState(() {
                isLoading = true;
              });
              Provider.of<Categories>(context, listen: false)
                  .deleteCategory(cat.id, currentUser!.token)
                  .then((value) async {
                showMySnackBar(
                    context: context,
                    text: lagnProvider.get('Category has been deleted'));
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
  }

  refreshSearchedCats(Category val) {
    Provider.of<Categories>(context, listen: false).getCategoriesByTitle(val);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    categories = Provider.of<Categories>(context, listen: false).categories;
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    Language languageProvider = Provider.of<Language>(context, listen: true);

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
                  title: languageProvider.get("Add New Category"),
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
                    first: HeadingName(title: languageProvider.get("Name")),
                    second: HeadingName(
                        title: languageProvider.get("Parent Category")),
                    third: TextButton(
                      child: HeadingName(title: languageProvider.get("Delete")),
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
                              third: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Provider.of<Categories>(context,
                                                listen: false)
                                            .setCatgeory(categories[index]);
                                        widget.scaffoldKey.currentState!
                                            .openEndDrawer();
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
                                        child: Icon(
                                          Icons.edit,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    Consumer<Products>(
                                        builder: (context, prods, _) {
                                      return prods.deleteLoader &&
                                              prods.deleteCatId ==
                                                  categories[index].id
                                          ? Container(
                                              alignment: Alignment.center,
                                              height: height(context) * 3,
                                              width: height(context) * 3,
                                              child: CircularProgressIndicator(
                                                color:
                                                    btnbgColor.withOpacity(1),
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () {
                                                if (currentUser!.role!
                                                        .toLowerCase() !=
                                                    'admin') {
                                                  showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AdaptiveDiaglog(
                                                              ctx: ctx,
                                                              title:
                                                                  'Access Denied',
                                                              content:
                                                                  'Only admin can delete Categories',
                                                              btnYes: 'Okay',
                                                              yesPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }));
                                                } else {
                                                  prods.setDeleteCatId(
                                                      categories[index].id);
                                                  prods.setLoader(true);
                                                  deleteCat(categories[index],
                                                      languageProvider);
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
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            );
                                    }),
                                  ]),
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
    Language languageProvider = Provider.of<Language>(context, listen: true);

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
        fontSize: 16,
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
            border: Border.all(
              color: btnbgColor.withOpacity(0.6),
              width: 1,
            ),
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
