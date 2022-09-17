import 'package:anees_costing/Models/activitylogs.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Widget/adaptive_indecator.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../Models/product.dart';
import '../Models/sent_products.dart';
import '../Models/user.dart';

class SendProductButton extends StatefulWidget {
  SendProductButton({
    super.key,
    required this.prod,
  });

  Product prod;
  @override
  State<SendProductButton> createState() => _SendProductButtonState();
}

class _SendProductButtonState extends State<SendProductButton> {
  bool isSending = false;
  bool isSended = false;
  String? receiverId;
  List<AUser> filteredUser = [];

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Auth>(context, listen: true).currentUser;
    List<AUser> customers = Provider.of<Users>(context).customers;
    return IconButton(
      onPressed: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Row(
                  children: [
                    Expanded(
                      flex: 15,
                      child: Text(
                        'Select Users',
                        style: GoogleFonts.righteous(
                          color: headingColor,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              isSended = false;
                            });
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.cancel_rounded,
                            color: Colors.red,
                            size: height(context) * 3.5,
                          )),
                    )
                  ],
                ),
                content: StatefulBuilder(builder: (context, setState) {
                  Product productToSend = Provider.of<Products>(context)
                      .getProdById(widget.prod.id);

                  return Container(
                    height: height(context) * 50,
                    width: width(context) * 50,
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              hintText: 'Search User',
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              focusColor: primaryColor,
                              fillColor: primaryColor,
                              prefixIcon: Icon(
                                Icons.person,
                                color: primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              filteredUser = customers
                                  .where(
                                    (element) => element.name
                                        .toLowerCase()
                                        .contains(val.toLowerCase()),
                                  )
                                  .toList();
                            });
                          },
                        ),
                        SizedBox(
                          height: height(context) * 2,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: filteredUser.isEmpty
                                  ? customers.length
                                  : filteredUser.length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: ListTile(
                                    title: Row(
                                      children: [
                                        Icon(
                                          Icons.person_outline,
                                          color: primaryColor,
                                        ),
                                        SizedBox(
                                          width: width(context) * 1,
                                        ),
                                        Text(
                                          filteredUser.isEmpty
                                              ? customers[index].name
                                              : filteredUser[index].name,
                                        ),
                                      ],
                                    ),
                                    // trailing: isSending &&
                                    //         customers[index].id == receiverId
                                    //     ? Container(
                                    //         width: 50,
                                    //         alignment: Alignment.centerRight,
                                    //         child: AdaptiveIndecator(
                                    //           color: primaryColor,
                                    //         ),
                                    //       )
                                    //     : productToSend.customers != null &&
                                    //             productToSend.customers!
                                    //                 .contains(
                                    //                     customers[index].id)
                                    //         ? IconButton(
                                    //             onPressed: () {},
                                    //             icon: const Icon(
                                    //               Icons.check_circle_outline,
                                    //               color: Colors.green,
                                    //             ))
                                    //         : IconButton(
                                    //             onPressed: () async {
                                    //               // print(customers[index].id);
                                    //               receiverId =
                                    //                   customers[index].id;
                                    //               setState(
                                    //                 () {
                                    //                   isSending = true;
                                    //                 },
                                    //               );
                                    //               // Future.delayed(Duration(seconds: 1)).then((value) {

                                    //               // });
                                    //               await Provider.of<
                                    //                           SentProducts>(ctx,
                                    //                       listen: false)
                                    //                   .addProduct(
                                    //                       product:
                                    //                           productToSend,
                                    //                       userId:
                                    //                           customers[index]
                                    //                               .id);
                                    //               setState(
                                    //                 () {
                                    //                   isSending = false;
                                    //                   isSended = true;
                                    //                 },
                                    //               );
                                    //               // Provider.of<Products>(context,
                                    //               //         listen: false)
                                    //               //     .addCustomer(
                                    //               //         customers[index]
                                    //               //             .id
                                    //               //             .toString(),
                                    //               //         productToSend.id
                                    //               //             .toString());

                                    //               Provider.of<Logs>(context,
                                    //                       listen: false)
                                    //                   .addLog(Log(
                                    //                       id: DateTime.now()
                                    //                           .microsecond
                                    //                           .toString(),
                                    //                       userid:
                                    //                           currentUser!.id,
                                    //                       userName:
                                    //                           currentUser.name!,
                                    //                       content:
                                    //                           '${currentUser.name} shared design ${productToSend.name} with ${customers[index].name}',
                                    //                       logType: 'Share'));

                                    //               // Navigator.of(ctx).pop();
                                    //             },
                                    //             icon: Icon(
                                    //               Icons.send_outlined,
                                    //               color: primaryColor,
                                    //             )),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  );
                }),
              );
            });
      },
      icon: Icon(
        Icons.send,
        color: primaryColor,
      ),
    );
  }
}
