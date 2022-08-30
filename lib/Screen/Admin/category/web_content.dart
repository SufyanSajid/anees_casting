import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/category.dart';

class CategoryWebContent extends StatefulWidget {
  CategoryWebContent({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<CategoryWebContent> createState() => _CategoryWebContentState();
}

class _CategoryWebContentState extends State<CategoryWebContent> {
  bool isFirst = true;
  bool isLoading = false;
  final categoryController = TextEditingController();
  List<Category>? categories;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      isFirst = false;
      if (Provider.of<Categories>(context).categories.isEmpty) {
        setState(() {
          isLoading = true;
        });
        await Provider.of<Categories>(context).fetchAndUpdateCat().then(
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
          btn1: 'No',
          content: 'Do You want to "${cat.title}" Category?',
          btn2: 'Yes',
          btn1Pressed: () {
            Navigator.of(context).pop();
          },
          btn2Pressed: () {
            Navigator.of(context).pop();
            setState(() {
              isLoading = true;
            });
            FirestoreMethods()
                .deleteRecord(collection: 'categories', prodId: cat.id)
                .then((value) async {
              await Provider.of<Categories>(context, listen: false)
                  .fetchAndUpdateCat();
              setState(() {
                isLoading = false;
              });
            });
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Provider.of<Categories>(context).categories;
    return Column(
      children: [
        buildFilterBar(
            searchSubmitted: () {},
            context: context,
            searchConttroller: categoryController,
            btnTap: () {
              Provider.of<Categories>(context, listen: false).drawerCategory =
                  null;
              widget.scaffoldKey.currentState!.openEndDrawer();
            },
            btnText: 'Add New Category',
            dropDown: null),
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                      color: btnbgColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: FeildName(
                          title: 'Name',
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: FeildName(
                          title: 'Parent Category',
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: FeildName(
                      //     title: 'Edit',
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: FeildName(
                          title: 'Delete',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (ctx, index) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: RowItem(
                                    title: categories[index].title,
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: RowItem(
                                    title: categories[index].parentTitle,
                                  ),
                                ),
                                // Expanded(
                                //   flex: 1,
                                //   child: ActionButton(
                                //     color: btnbgColor.withOpacity(1),
                                //     title: 'Edit',
                                //     onTap: () {
                                //       setState(
                                //         () {
                                //           Provider.of<Categories>(context,
                                //                   listen: false)
                                //               .setCatgeory(categories![index]);
                                //           widget.scaffoldKey.currentState!
                                //               .openEndDrawer();
                                //         },
                                //       );
                                //     },
                                //     icon: Icons.edit_outlined,
                                //   ),
                                // ),
                                InkWell(
                                  onTap: () => deleteCat(categories[index]),
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
                              ],
                            ),
                          ),
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

class ActionButton extends StatelessWidget {
  ActionButton({
    Key? key,
    required this.title,
    required this.color,
    required this.onTap,
    required this.icon,
  }) : super(key: key);
  Color color;
  String title;
  Function()? onTap;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        margin: const EdgeInsets.only(right: 30),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: color,
            minimumSize: const Size(0, 45),
            maximumSize: const Size(0, 45),
          ),
          onPressed: onTap,
          icon: Icon(
            icon,
            color: Colors.white,
          ),
          label: FittedBox(
            child: Text(
              title,
            ),
          ),
        ),
      ),
    );
  }
}

class FeildName extends StatelessWidget {
  FeildName({
    Key? key,
    required this.title,
  }) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: GoogleFonts.righteous(
        fontSize: 16,
        color: primaryColor,
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  RowItem({
    Key? key,
    required this.title,
  }) : super(key: key);
  String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: headingColor,
        ),
      ),
    );
  }
}
