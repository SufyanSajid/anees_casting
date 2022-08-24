import 'package:anees_costing/Functions/filterbar.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/category.dart';
import '../../../Widget/dropDown.dart';

class CategoryWebContent extends StatefulWidget {
  CategoryWebContent({
    Key? key,
    required this.scaffoldKey,
    required this.onChanged,
  }) : super(key: key);

  GlobalKey<ScaffoldState> scaffoldKey;

  Function(Category cat) onChanged;

  @override
  State<CategoryWebContent> createState() => _CategoryWebContentState();
}

class _CategoryWebContentState extends State<CategoryWebContent> {
  bool isFirst = true;
  bool isLoading = false;
  final categoryController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      setState(() {
        isLoading = true;
      });
      Provider.of<Categories>(context).fetchAndUpdateCat().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var categories = Provider.of<Categories>(context, listen: false).categories;
    return Column(
      children: [
        buildFilterBar(
          context: context,
          searchConttroller: categoryController,
          btnTap: () {
            widget.scaffoldKey.currentState!.openEndDrawer();
          },
          btnText: 'Add New Category',
          dropDown: CustomDropDown(
            onChanged: (value) {
              print(value);
            },
            items: const [
              'Asc',
              'Dec',
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
                      Expanded(
                        flex: 1,
                        child: FeildName(
                          title: 'Edit',
                        ),
                      ),
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
                                    title: categories[index].parentId,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ActionButton(
                                    color: btnbgColor.withOpacity(1),
                                    title: 'Edit',
                                    onTap: () {
                                      setState(() {
                                        widget.onChanged(categories[index]);

                                        widget.scaffoldKey.currentState!
                                            .openEndDrawer();
                                      });
                                    },
                                    icon: Icons.edit_outlined,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ActionButton(
                                    color: Colors.red,
                                    title: 'Delete',
                                    icon: Icons.delete,
                                    onTap: () {},
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
        margin: EdgeInsets.only(right: 30),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: color,
            minimumSize: Size(0, 45),
            maximumSize: Size(0, 45),
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
