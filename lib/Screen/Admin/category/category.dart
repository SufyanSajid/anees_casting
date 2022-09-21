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
import '../../../Widget/appbar.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = '/categoryScreen';
  CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _nameController = TextEditingController();

  Category? parentCat;
  bool isCatLoading = false;
  bool isLoading = false;
  bool isFirst = true;
  CurrentUser? currentUser;

  Icon? _icon;

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino]);

    _icon = Icon(icon);
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  @override
  void didChangeDependencies() async {
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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    List<Category> categories =
        Provider.of<Categories>(context, listen: true).categories;
    List<Category> parentCategories =
        Provider.of<Categories>(context, listen: false).parentCategories;
    var media = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: backgroundColor,
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
            print('shani');
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (ctx) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: StatefulBuilder(
                        key: ValueKey(1),
                        builder: (context, setState) => Container(
                          // padding:
                          //     EdgeInsets.only(bottom: media.viewInsets.bottom),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          height: height(context) * 40,
                          width: width(context) * 100,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Add New Category',
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
                                  categories: categories,
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
                              isCatLoading
                                  ? Center(
                                      child: AdaptiveIndecator(
                                          color: primaryColor),
                                    )
                                  : SubmitButton(
                                      height: height(context),
                                      width: width(context),
                                      onTap: () async {
                                        setState(() {
                                          isCatLoading = true;
                                        });
                                        var navi = Navigator.of(context);
                                        var provider = Provider.of<Categories>(
                                            context,
                                            listen: false);
                                        await provider
                                            .uploadCatagory(
                                          title: _nameController.text.trim(),
                                          userToken: currentUser!.token,
                                          parentId: parentCat == null
                                              ? ""
                                              : parentCat!.id,
                                        )
                                            .catchError((error) {
                                          showCustomDialog(
                                              context: context,
                                              title: 'Error',
                                              btn1: 'Okay',
                                              content: error.toString(),
                                              btn1Pressed: () {
                                                Navigator.of(context).pop();
                                              });
                                        });
                                        await provider.fetchAndUpdateCat(
                                            currentUser!.token);
                                        setState(() {
                                          _nameController.clear();
                                          isCatLoading = false;
                                        });

                                        navi.pop();
                                      },
                                      title: 'Add Category')
                            ],
                          ),
                        ),
                      ),
                    ));
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
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            splashColor: primaryColor,
                            onTap: () {},
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
                                    categories[index].title.toUpperCase(),
                                    style: GoogleFonts.righteous(
                                      color: headingColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    categories[index].parentId.isEmpty
                                        ? '(Parent)'
                                        : '(${categories[index].parentTitle})',
                                    style: TextStyle(
                                        color: contentColor, fontSize: 12),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        deleteCat(categories[index]);
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ))),
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
