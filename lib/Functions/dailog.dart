import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';

Widget lightDivider() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey.withOpacity(0.5),
      height: 1,
    );

Column buildTopTitle(
  BuildContext context, {
  bool? isPack,
  String? title,
  String? image,
  Widget? customTitle,
  bool showDivider = true,
}) {
  return Column(
    children: [
      ListTile(
        leading: Image.asset('assets/images/logo.png'),
        trailing: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel),
          ),
        ),
        title: title != null && customTitle == null
            ? Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              )
            : customTitle,
        onTap: () {
          Navigator.pop(context);
        },
      ),
      if (showDivider)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: lightDivider(),
        ),
    ],
  );
}

Future<void> showCustomDialog({
  required BuildContext context,
  required String title,
  required String btn1,
  required String content,
  required String btn2,
  required Function()? btn1Pressed,
  required Function()? btn2Pressed,
  Function()? logoutap,
}) async {
  String desc = 'Remember my info?';
  bool isCheck = true;
  // when synced

  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: btnbgColor.withOpacity(1),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            height: height(context) * 22,
            width: width(context) * 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTopTitle(context,
                    title: title, image: 'assets/images/logo.png'),
                SizedBox(height: height(context) * 01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                SizedBox(height: height(context) * 1),
                Row(
                  children: [
                    // const SizedBox(width: 85),
                    Expanded(
                      child: DialogButton(
                        text: btn1,
                        btncolor: Colors.grey,
                        onPressed: btn1Pressed,
                      ),
                    ),
                    Expanded(
                      child: DialogButton(
                        text: btn2,
                        btncolor: btnbgColor,
                        onPressed: btn2Pressed,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ));
    },
  );
}

class DialogButton extends StatelessWidget {
  DialogButton({
    required this.text,
    required this.btncolor,
    required this.onPressed,
  });
  String text;
  Color btncolor;
  Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Color buttonColor = btncolor;
    Color textColor = contentColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(buttonColor),
            minimumSize: MaterialStateProperty.all(const Size(999, 45)),
            // padding:EdgeInsets.symmetric(horizontal: 5),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(color: headingColor, width: 2),
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
            )),
        icon: const Icon(Icons.hide_image, size: 0),
        label: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
