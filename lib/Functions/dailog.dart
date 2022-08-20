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
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.cancel),
        ),
        title: title != null && customTitle == null
            ? Text(
                title,
                style: TextStyle(fontSize: 16, color: Colors.white),
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

Future<void> showLogoutDialog({
  required BuildContext context,
  required String title,
  String? image,
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
          backgroundColor: btnbgColor.withOpacity(0.8),
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            //  height: maxHeight(context) * 0.25,
            width: width(context) * 01,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildTopTitle(context, title: title, image: image),
                SizedBox(height: height(context) * 01),
                Row(
                  children: [
                    Checkbox(
                        value: isCheck,
                        onChanged: (value) {
                          isCheck = !isCheck;
                        }),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      '$desc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 1),
                Row(
                  children: [
                    // const SizedBox(width: 85),
                    Expanded(
                      child: DialogButton(
                        text: 'Cancel',
                        btncolor: btnbgColor,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: DialogButton(
                        text: 'Logout',
                        btncolor: Colors.grey,
                        onPressed: logoutap,
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
