import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/Widget/customautocomplete.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:anees_costing/Widget/input_feild.dart';
import 'package:anees_costing/Widget/submitbutton.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Functions/dailog.dart';
import '../../../Models/product.dart';
import '../../../Widget/appbar.dart';
import '../../../Widget/snakbar.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';
  CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _nameController = TextEditingController();

  Category? parentCat;
  bool isLoading = false;
  bool isFirst = true;
  CurrentUser? currentUser;
  List<Category>? categories;
  List<Category>? parentCategories;

  Icon? _icon;


  @override
  void didChangeDependencies() async {
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    if (isFirst) {
      if (Provider.of<Categories>(context, listen: false).categories.isEmpty) {
        setState(() {
          isLoading = true;
        });

        await Provider.of<Categories>(context, listen: false)
            .fetchAndUpdateCat(currentUser!.token);
        setState(() {
          isLoading = false;
        });
      }
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void addCategory(BuildContext ctx) async {
    var provider = Provider.of<Categories>(context, listen: false);
    provider.setCatLoader(true);
    var navi = Navigator.of(ctx);

    await provider
        .uploadCatagory(
      title: _nameController.text.trim(),
      userToken: currentUser!.token,
      parentId: parentCat == null ? "" : parentCat!.id,
    )
        .then((value) {
      showMySnackBar(context: context, text: 'Category : Category Added');
    }).catchError((error) {
      provider.setCatLoader(false);

      showCustomDialog(
          context: context,
          title: 'Error',
          btn1: 'Okay',
          content: error.toString(),
          btn1Pressed: () {
            Navigator.of(ctx).pop();
          });
    });
    await provider.fetchAndUpdateCat(currentUser!.token);
    setState(() {
      _nameController.clear();
      provider.setCatLoader(false);
    });

    navi.pop();
  }

  void editCategorty(Category cat) async {
    var provider = Provider.of<Categories>(context, listen: false);
    provider.setCatLoader(true);

    Provider.of<Categories>(context, listen: false)
        .EditCategory(
      userToken: currentUser!.token,
      catId: cat.id,
      title: _nameController.text,
      parentId: parentCat == null ? "" : parentCat!.id,
    )
        .then((value) async {
      await Provider.of<Categories>(context, listen: false)
          .fetchAndUpdateCat(currentUser!.token);
      provider.setCatLoader(false);
      Navigator.of(context).pop();

      showMySnackBar(context: context, text: 'Category : Category updated');
    }).catchError((error) {
      provider.setCatLoader(false);

      print(error.toString());
    });
  }

  void deleteCat(Category cat) async {
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
          title: "Parent Category",
          btn1: null,
          content: "Parent category can't be deleted.",
          btn2: "Ok",
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
            title: 'Delete',
            btn1: 'Okay',
            content: 'This Category contains products cannot delete',
            btn1Pressed: () {
              Navigator.of(context).pop();
            });
        return;
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
                showMySnackBar(
                    context: context, text: 'Category : Category Deleted');
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showCustomBottomSheet({required String action, Category? cat}) {
    var provider = Provider.of<Categories>(context, listen: false);

    bool isEdit = false;
    if (action == 'edit') {
      isEdit = true;
    } else {
      isEdit = false;
    }
    if (isEdit) {
      _nameController.text = cat!.title.split('-').first;
    } else {
      _nameController.clear();
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                key: ValueKey(1),
                builder: (ctx, setState) => Container(
                  // padding:
                  //     EdgeInsets.only(bottom: media.viewInsets.bottom),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  height: height(context) * 40,
                  width: width(context) * 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isEdit ? 'Edit Category' : 'Add New Category',
                        style: GoogleFonts.righteous(
                          color: primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: height(context) * 4,
                      ),
                      CustomAutoComplete(
                          categories: categories!,
                          firstSelction: (isEdit && cat!.parentId != '')
                              ? cat.parentTitle
                              : null,
                          onChange: (Category cat) {
                            parentCat = cat;
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
                      provider.isCatLoading
                          ? Center(
                              child: AdaptiveIndecator(color: primaryColor),
                            )
                          : SubmitButton(
                              height: height(context),
                              width: width(context),
                              onTap: () {
                                isEdit ? editCategorty(cat!) : addCategory(ctx);
                              },
                              title: isEdit ? 'Edit Category' : 'Add Category'),
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
  
    categories = Provider.of<Categories>(context, listen: true).categories;
    parentCategories =
        Provider.of<Categories>(context, listen: false).parentCategories;
    var media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                btnbgColor.withOpacity(1),
                btnbgColor.withOpacity(1),
              ],
            ),
            shape: BoxShape.circle),
        child: FloatingActionButton(
          backgroundColor: btnbgColor.withOpacity(0.4),
          onPressed: () {
            showCustomBottomSheet(action: 'add');
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Appbar(
                title: 'Category',
                subtitle: 'All Your Categories',
                svgIcon: 'assets/icons/category.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              SizedBox(
                height: height(context) * 3,
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: AdaptiveIndecator(color: primaryColor),
                      )
                    : ListView.builder(
                        itemCount: categories!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: primaryColor,
                            onDoubleTap: () {
                              showCustomBottomSheet(
                                  action: 'edit', cat: categories![index]);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: btnbgColor.withOpacity(0.6),
                                    width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0, 5),
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: ListTile(
                                leading: Icon(
                                  Icons.bookmark,
                                  color: btnbgColor.withOpacity(1),
                                ),
                                title: Text(
                                  categories![index].title.toUpperCase(),
                                  style: GoogleFonts.righteous(
                                    color: headingColor,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  categories![index].parentId.isEmpty
                                      ? '(Parent)'
                                      : '(${categories![index].parentTitle})',
                                  style: TextStyle(
                                      color: contentColor, fontSize: 12),
                                ),
                                trailing: Consumer<Products>(
                                  builder: (context, prods, _) {
                                    return prods.deleteLoader &&
                                            prods.deleteCatId ==
                                                categories![index].id
                                        ? Container(
                                            alignment: Alignment.centerRight,
                                            height: height(context) * 2,
                                            width: height(context) * 2,
                                            child: CircularProgressIndicator(
                                              color: btnbgColor.withOpacity(1),
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              prods.setDeleteCatId(
                                                  categories![index].id);
                                              prods.setLoader(true);
                                              deleteCat(categories![index]);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ));
                                  },
                                ),
                              ),
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
