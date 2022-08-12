import 'package:anees_costing/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../contant.dart';

class CustomAutoComplete extends StatefulWidget {
  CustomAutoComplete({
    required this.onChange,
    required this.categories,
  });

  final Function onChange;
  final List<Category> categories;

  @override
  State<CustomAutoComplete> createState() => _CustomAutoCompleteState();
}

class _CustomAutoCompleteState extends State<CustomAutoComplete> {
  bool isFirst = true;

  @override
  void didChangeDependencies() async {
    if (isFirst) {}
    isFirst = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingValue textEditingValue = TextEditingValue(text: widget.town);

    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
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
      onSelected: (value) {
        print('yeh ha on selectedValue ${value}');
      },
      fieldViewBuilder: (BuildContext context, TextEditingController controller,
          FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
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
              decoration: InputDecoration(
                  label: Text(
                    'Select Category',
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
            child: Container(
              height: height * 33,
              margin: const EdgeInsets.only(
                right: 40,
              ),
              width: width * 100,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Category option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      onSelected(option.title);

                      widget.onChange(option);
                    },
                    child: ListTile(
                      title: Text(option.title,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
