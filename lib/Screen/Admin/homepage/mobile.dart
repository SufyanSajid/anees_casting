import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Screen/Admin/category/category.dart';
import 'package:anees_costing/Screen/Admin/Product/product.dart';
import 'package:anees_costing/Screen/Admin/users/users.dart';
import 'package:anees_costing/Screen/Common/profile.dart';
import 'package:anees_costing/Widget/bottombar.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../contant.dart';

class MobileAdminHomePage extends StatefulWidget {
  const MobileAdminHomePage({Key? key}) : super(key: key);

  @override
  State<MobileAdminHomePage> createState() => _MobileAdminHomePageState();
}

class _MobileAdminHomePageState extends State<MobileAdminHomePage> {
  //bottomNavigationBar: CustomBottomBar(selectedIndex: 1, onTap: (){}),
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    var height = MediaQuery.of(context).size.height / 100;
    var width = MediaQuery.of(context).size.width / 100;
    var homePage = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: height * 7.5,
                      width: height * 7.5,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                          border:
                              Border.all(style: BorderStyle.solid, width: 2),
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
                          height: height * 10,
                          width: height * 10,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 2,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                              color: secondaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Admin',
                          style: GoogleFonts.righteous(
                            color: primaryColor,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    _scaffoldKey.currentState!.openDrawer();
                  },
                  icon: Icon(
                    Icons.filter_list,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
            decoration: BoxDecoration(
              gradient: customGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(94, 89, 89, 0.11),
                    offset: Offset(0, 10),
                    blurRadius: 20),
              ],
            ),

            //width: double.infinity,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DisplayBox(
                  height: height,
                  title: 'Products',
                  value: '25',
                ),
                Container(
                  height: height * 5,
                  width: width * 0.2,
                  color: secondaryColor.withOpacity(0.5),
                ),
                DisplayBox(
                  height: height,
                  title: 'Sales',
                  value: '562',
                ),
                Container(
                  height: height * 5,
                  width: width * 0.2,
                  color: secondaryColor.withOpacity(0.5),
                ),
                DisplayBox(
                  height: height,
                  title: 'Clients',
                  value: '25',
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Quick Links',
              style: GoogleFonts.righteous(fontSize: 18, color: primaryColor),
            ),
          ),
          SizedBox(
            height: height * 1.5,
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            height: height * 18,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                QuickChecks(
                  width: width,
                  height: height,
                  title: 'Design',
                  subtitle: 'Click to view',
                  icon: Icons.inventory_2_outlined,
                  onTap: () {
                    Navigator.pushNamed(context, ProductScreen.routeName);
                  },
                ),
                QuickChecks(
                  width: width,
                  height: height,
                  title: 'Sellers',
                  subtitle: 'Click to view',
                  icon: Icons.person_pin_circle_outlined,
                  onTap: () {},
                ),
                QuickChecks(
                  width: width,
                  height: height,
                  title: 'Customers',
                  subtitle: 'Click to view',
                  icon: Icons.person_outline,
                  onTap: () {},
                ),
              ],
            ),
          ),
          if (currentUser!.role!.toLowerCase() == 'admin')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App User',
                    style: GoogleFonts.righteous(
                        fontSize: 18, color: primaryColor),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: GoogleFonts.ubuntu(
                          fontSize: 15, color: secondaryColor),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            height: height * 0.5,
          ),
          if (currentUser.role!.toLowerCase() == 'admin')
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (ctx, index) => Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin:
                      const EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        const BoxShadow(
                          color: Color.fromRGBO(94, 89, 89, 0.11),
                          offset: Offset(0, 10),
                          blurRadius: 20,
                        ),
                        BoxShadow(
                          color: Color.fromRGBO(94, 89, 89, 0.11),
                          offset: -Offset(0, 10),
                          blurRadius: 20,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: height * 6,
                            width: height * 6,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    style: BorderStyle.solid,
                                    width: 2,
                                    color: primaryColor),
                                borderRadius: BorderRadius.circular(50)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
                                height: height * 10,
                                width: height * 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 3,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sufyan Sajid',
                                style: TextStyle(
                                    color: primaryColor, fontSize: 16),
                              ),
                              SizedBox(
                                height: height * 0.3,
                              ),
                              Text(
                                'Booker',
                                style: TextStyle(
                                    color: secondaryColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Text(
                            'Active',
                            style: TextStyle(color: Colors.green),
                          ),
                          SizedBox(
                            width: width * 3,
                          ),
                          Switch(
                            value: false,
                            activeColor: Colors.green,
                            inactiveTrackColor: Colors.red,
                            thumbColor: MaterialStateProperty.all(Colors.white),
                            onChanged: (value) async {
                              print(value);
                              int status;

                              if (value == true) {
                                status = 1;
                              } else {
                                status = 0;
                              }

                              // setState(() {
                              //   users[index].isActive = !users[index].isActive;
                              // });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    List<Widget> _tabs = [
      homePage,
      const UserScreen(),
      CategoryScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        bottomNavigationBar: CustomBottomBar(
          onTap: (value) {
            setState(() {
              selectIndex = value;
            });
          },
          selectedIndex: selectIndex,
        ),
        body: _tabs[selectIndex]);
  }
}

class DisplayBox extends StatelessWidget {
  const DisplayBox({
    Key? key,
    required this.height,
    required this.title,
    required this.value,
  }) : super(key: key);

  final double height;
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: height * 1,
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class QuickChecks extends StatelessWidget {
  QuickChecks({
    Key? key,
    required this.width,
    required this.height,
    required this.icon,
    required this.subtitle,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final double width;
  final double height;
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
        width: width * 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 1),
                blurRadius: 20),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primaryColor,
                size: 28,
              ),
              SizedBox(
                height: height * 2,
              ),
              Text(
                title,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
