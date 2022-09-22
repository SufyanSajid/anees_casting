import 'package:flutter/material.dart';

import '../contant.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    required this.onChanged,
    required this.items,
    this.firstSelect,
  });

  Function onChanged;
  String? firstSelect;
  List<String> items;

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  int selectedIndex = 0;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if (isFirst) {
      if (widget.firstSelect != null && widget.firstSelect!.isNotEmpty) {
        selectedIndex = widget.items.indexOf(widget.firstSelect.toString());
      }
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.firstSelect);
    return Container(
      //   width: width(context) * 20,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          gradient: customGradient,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 15)
          ]),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          dropdownColor: primaryColor,
          icon: const Icon(
            Icons.keyboard_arrow_down_outlined,
            color: Colors.white,
          ),
          value: widget.items[selectedIndex],
          items: widget.items.map(buildMenuItem).toList(),
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {
              selectedIndex = widget.items.indexOf(value.toString());
            });
          },
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: FittedBox(
        child: Text(
          item,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Poppins-thins',
          ),
        ),
      ),
    );
