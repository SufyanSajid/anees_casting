import 'package:anees_costing/Models/user.dart';
import 'package:anees_costing/Widget/appbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserScreen extends StatelessWidget {
  static const routeName='/userscreen';
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var users = Provider.of<Users>(context, listen: false).users;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: primaryColor,
        onPressed: () {},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'User',
                subtitle: 'All users here',
                svgIcon: 'assets/icons/users.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              Expanded(
                  child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ]),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height(context) * 7,
                        width: height(context) * 7,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor,
                              style: BorderStyle.solid,
                              width: 1,
                            )),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            users[index].image,
                            height: height(context) * 6,
                            width: height(context) * 6,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            users[index].name,
                            style: TextStyle(
                              color: headingColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.5,
                          ),
                          Text(
                            users[index].phone,
                            style: TextStyle(color: contentColor, fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 5),
                                      blurRadius: 5),
                                ]),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit,
                              color: contentColor,
                              size: 20,
                            ),
                          ),
                          SizedBox(
                            width: width(context) * 4,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 5),
                                      blurRadius: 5),
                                ]),
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
