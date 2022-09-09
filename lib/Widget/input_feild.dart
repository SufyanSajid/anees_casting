import 'package:flutter/material.dart';

import '../contant.dart';

class InputFeild extends StatefulWidget {
  String hinntText;

  Function validatior;
  void Function(String?)? saved;
  void Function(String)? submitted;
  void Function(String)? onChanged;
  TextEditingController inputController;
  TextInputType? type;
  TextInputAction? textInputAction;
  FocusNode? focusNode;
  bool secure = true;
  IconData? suffix;
  bool readOnly;
  Function? suffixPress;
  int? maxLines;

  InputFeild(
      {required this.hinntText,
      required this.validatior,
      required this.inputController,
      this.type,
      this.focusNode,
      this.submitted,
      this.saved,
      this.suffix,
      this.maxLines = 1,
      this.suffixPress,
      this.onChanged,
      this.textInputAction,
      this.readOnly = false,
      this.secure = false});

  @override
  State<InputFeild> createState() => _InputFeildState();
}

class _InputFeildState extends State<InputFeild> {
  var isError = false;

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height / 100;
    // if (height < 700) {
    //   height = 700 / 100;
    // }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(0, 5), blurRadius: 12),
        ],
      ),
      //  height: isError ? height * 9 : height * 7,
      //   margin: EdgeInsets.only(top: height * 3),
      child: Center(
        child: TextFormField(
          onChanged: widget.onChanged,
          maxLines: widget.maxLines,
          onFieldSubmitted: widget.submitted,
          onSaved: widget.saved,
          focusNode: widget.focusNode,
          textInputAction: widget.textInputAction,
          obscureText: widget.secure,
          readOnly: widget.readOnly,
          keyboardType: widget.type,
          controller: widget.inputController,
          validator: (value) {
            var error = widget.validatior(value);
            if (error != null) {
              setState(() {
                isError = true;
              });
            } else {
              setState(() {
                isError = false;
              });
            }

            return error;
          },
          style: TextStyle(color: primaryColor),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
              suffixIcon: IconButton(
                icon: Icon(
                  widget.suffix,
                  color: primaryColor,
                ),
                onPressed: widget.suffixPress as Function()?,
              ),
              fillColor: primaryColor,
              // contentPadding: const EdgeInsets.all(5),
              hintStyle: TextStyle(color: contentColor, fontSize: 15),
              hintText: widget.hinntText,
              border: InputBorder.none
              //  focusedBorder:
              // UnderlineInputBorder(
              //   borderSide: BorderSide(color: primaryColor),
              // ),
              // OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide:  BorderSide(color: primaryColor, width: 0.0),
              // ),
              // enabledBorder:
              // const UnderlineInputBorder(
              //   borderSide: BorderSide(
              //     color: Color.fromRGBO(168, 167, 167, 1),
              //   ),
              // ),
              // OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide:  BorderSide(color: primaryColor, width: 0),
              // ),
              // errorBorder:
              // const UnderlineInputBorder(
              //   borderSide: BorderSide(color: Colors.red),
              // ),
              //  OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: const BorderSide(color: Colors.red, width: 0),
              // ),
              // focusedErrorBorder:
              //  UnderlineInputBorder(
              //   borderSide: BorderSide(color: secondaryColor),
              // ),
              // OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: const BorderSide(color: Colors.red, width: 0),
              // // ),
              // errorStyle: Theme.of(context).textTheme.caption!.copyWith(
              //       color: Colors.red,
              //       fontSize: 10,
              //     ),
              ),
        ),
      ),
    );
  }
}
