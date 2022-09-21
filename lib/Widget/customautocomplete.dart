import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../contant.dart';

class CustomAutoComplete extends StatefulWidget {
  const CustomAutoComplete(
      {Key? key,
      required this.onChange,
      required this.categories,
      this.firstSelction})
      : super(key: key);

  final Function onChange;
  final List<Category> categories;
  final String? firstSelction;

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  bool isFirst = true;
  CurrentUser? currentUser;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      isFirst = false;
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    }

    if (Provider.of<Categories>(context).categories.isEmpty) {}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingValue textEditingValue = TextEditingValue(text: widget.town);

    var height = MediaQuery.of(context).size.height / 100;
    // var width = MediaQuery.of(context).size.width / 100;
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Autocomplete(
      // initialValue: textEditingValue,
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return widget.categories.where((Category option) {
          return option.title
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (value) {},
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, offset: Offset(0, 5), blurRadius: 12),
            ],
          ),
          child: Center(
            child: TextField(
              focusNode: fieldFocusNode,
              controller: controller,
              onChanged: (value) async {
                if (value.isEmpty) {
                  Provider.of<Products>(context, listen: false)
                      .fetchAndUpdateProducts(currentUser!.token);
                }
              },
              decoration: InputDecoration(
                  label: Text(
                    widget.firstSelction == null
                        ? 'Select Category'
                        : widget.firstSelction!,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: primaryColor),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: InputBorder.none
                  // enabledBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(13),
                  //   borderSide: BorderSide(color: primaryColor, width: 1.0),
                  // ),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(13),
                  //   borderSide: BorderSide(color: primaryColor, width: 1.0),
                  // ),
                  // errorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(13),
                  //   borderSide: const BorderSide(color: Colors.red, width: 1.0),
                  // ),
                  ),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: Colors.transparent,
            // child:
            //  Container(
            //   height: height * 33,
            //   margin: const EdgeInsets.only(
            //     right: 40,
            //   ),
            //   width: width * 100,
            //   decoration: BoxDecoration(
            //     color: primaryColor,
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(20),
            //       bottomRight: Radius.circular(20),
            //       topRight: Radius.circular(20),
            //     ),
            //   ),
            child: Container(
              width: width(context) * 60,
              decoration: BoxDecoration(
                  borderRadius: customRadius, color: primaryColor),
              child: ListView.builder(
                shrinkWrap: true,
                // padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Category option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      onSelected(option.title);

                      widget.onChange(option);
                    },
                    child: ListTile(
                      title: Text(
                          option.parentId == ""
                              ? option.title
                              : "${option.title} - ${option.parentTitle}",
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ),
          // ),
        );
      },
    );
  }
}
