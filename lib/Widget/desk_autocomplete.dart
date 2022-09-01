import 'package:anees_costing/Models/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../contant.dart';

class WebAutoComplete extends StatefulWidget {
  const WebAutoComplete(
      {Key? key,
      required this.onChange,
      required this.categories,
      required this.onRefresh})
      : super(key: key);

  final Function onChange;
  final Function onRefresh;
  final List<Category> categories;

  @override
  State<WebAutoComplete> createState() => _WebAutoCompleteState();
}

class _WebAutoCompleteState extends State<WebAutoComplete> {
  bool isRefreshed = false;

  @override
  Widget build(BuildContext context) {
    print("Auto");
    return Row(
      children: [
        SizedBox(
          width: 190,
          child: Autocomplete(
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
            fieldViewBuilder: (BuildContext context,
                TextEditingController controller,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: TextField(
                    focusNode: fieldFocusNode,
                    controller:
                        isRefreshed ? (controller..text = "") : controller,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 0),
                      hintText: 'Select Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                        ),
                      ),
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
                  child: Container(
                    width: 250,
                    decoration: BoxDecoration(
                        borderRadius: customRadius, color: primaryColor),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Category option = options.elementAt(index);

                        return GestureDetector(
                          onTap: () {
                            isRefreshed = false;
                            onSelected(option.title);

                            widget.onChange(option);
                            options = const Iterable.empty();
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
          ),
        ),
        Material(
          color: Colors.white,
          child: IconButton(
              onPressed: () {
                widget.onRefresh();
                isRefreshed = !isRefreshed;
              },
              iconSize: 40,
              splashRadius: 20,
              hoverColor: Colors.transparent,
              splashColor: primaryColor.withOpacity(0.5),
              icon: const Icon(Icons.sync)),
        ),
      ],
    );
  }
}
