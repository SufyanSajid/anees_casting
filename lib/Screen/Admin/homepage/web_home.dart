import 'package:anees_costing/Models/categories_count.dart';
import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:anees_costing/Models/products_counts.dart';
import 'package:anees_costing/Models/users_count.dart';
import 'package:anees_costing/Screen/Admin/Product/content.dart';
import 'package:anees_costing/Screen/Admin/category/web_content.dart';
import 'package:anees_costing/Screen/Admin/logs/content.dart';
import 'package:anees_costing/Screen/Admin/users/content.dart';
import 'package:anees_costing/Widget/drawer/web_drawer.dart';
import 'package:anees_costing/Widget/webappbar.dart';
import 'package:anees_costing/contant.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Widget/grad_button.dart';
import '../../../Widget/sidebar.dart';

class WebHome extends StatefulWidget {
  WebHome({Key? key}) : super(key: key);

  @override
  State<WebHome> createState() => _WebHomeState();
}

class _WebHomeState extends State<WebHome> {
  int selectedIndex = 0;
  bool isFirst = true;
  bool isLoading = false;
  GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey();
  int? usersCount;
  int? productsCount;
  int? catsCount;

  @override
  void didChangeDependencies() async {
    if (isFirst) {
      isFirst = false;

      if (Provider.of<Categories>(context, listen: false).categories.isEmpty) {
        await Provider.of<Categories>(context, listen: false)
            .fetchAndUpdateCat();
      }

      Provider.of<UsersCount>(context, listen: false)
          .fetchtAndUpdateUsersCount();

      Provider.of<ProductsCount>(context, listen: false)
          .fetchAndGetProductsCount();

      Provider.of<CategoriesCount>(context, listen: false)
          .fetchtAndUpdateCategoriesCount();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    usersCount = Provider.of<UsersCount>(context).getUserCount;
    productsCount = Provider.of<ProductsCount>(context).getProductsCount;
    catsCount = Provider.of<CategoriesCount>(context).getCategoriesCount;

    Widget homeContent = Column(
      children: [
        //home bar
        Container(
          height: height(context) * 20,
          decoration: BoxDecoration(
            boxShadow: shadow,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const Image(
                image: AssetImage(
                  'assets/images/banner.png',
                ),
                fit: BoxFit.cover,
              ),
              SizedBox(
                width: width(context) * 5,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Welcome to Anees Casting',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      height: 3,
                      // width: width(context) * 60,
                      color: primaryColor,
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BarButton(
                            title: 'Manage Users',
                            onTap: () {},
                          ),
                          SizedBox(
                            width: width(context) * 1,
                          ),
                          BarButton(
                            title: 'Manage Designs',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        //home bar end

        //blocks area started
        SizedBox(
          height: height(context) * 3,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TotalBlock(
                title: 'Total Designs',
                value: productsCount == null ? "0" : "$productsCount",
                icon: Icons.diamond_outlined,
              ),
            ),
            SizedBox(
              width: width(context) * 1,
            ),
            Expanded(
              child: TotalBlock(
                title: 'Total Users',
                value: usersCount == null ? "0" : "$usersCount",
                icon: Icons.groups_outlined,
              ),
            ),
            SizedBox(
              width: width(context) * 1,
            ),
            Expanded(
              child: TotalBlock(
                title: 'Total Categories',
                value: catsCount == null ? "0" : "$catsCount",
                icon: Icons.diamond_outlined,
              ),
            ),
          ],
        ),
        //blocks area ended
        SizedBox(
          height: height(context) * 2,
        ),

        //activity logs
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          width: width(context) * 100,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: shadow,
            borderRadius: customRadius,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Activity Logs',
                style: TextStyle(
                    fontSize: 20,
                    color: primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              GradientButton(
                title: 'View All',
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                    print(4);
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: height(context) * 2,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 4,
            itemBuilder: (ctx, index) => Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
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
                        height: height(context) * 6,
                        width: height(context) * 6,
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
                            height: height(context) * 10,
                            width: height(context) * 10,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width(context) * 3,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sufyan Sajid',
                            style: TextStyle(color: primaryColor, fontSize: 16),
                          ),
                          SizedBox(
                            height: height(context) * 0.3,
                          ),
                          Text(
                            'Booker',
                            style:
                                TextStyle(color: secondaryColor, fontSize: 14),
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
                        width: width(context) * 3,
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
        //activity logs eng
      ],
    );
    List<Widget> _tabs = [
      homeContent,
      ProductWebContent(
        scaffoldKey: _ScaffoldKey,
      ),
      UserWebContent(
        scaffoldKey: _ScaffoldKey,
      ),
      CategoryWebContent(
        scaffoldKey: _ScaffoldKey,
      ),
      ActivityLogWebContent(),
    ];

    return Scaffold(
      endDrawer: WebDrawer(
        selectedIndex: selectedIndex,
      ),
      endDrawerEnableOpenDragGesture: true,
      key: _ScaffoldKey,
      backgroundColor: backgroundColor,
      body: Row(
        children: [
          //side bar area
          Expanded(
            flex: 2,
            child: SideBar(
              selectedIndex: selectedIndex,
              onChanged: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          //sidebar area end

          //apbar and main area
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Column(
                children: [
                  if (selectedIndex == 0)
                    WebAppbar(
                        title: 'Dashboard',
                        subTitle: 'Contains all data',
                        onChanged: () {}),
                  if (selectedIndex == 1)
                    WebAppbar(
                        title: 'Design',
                        subTitle: 'Your Designs',
                        onChanged: () {}),
                  if (selectedIndex == 2)
                    WebAppbar(
                        title: 'Users',
                        subTitle: 'All Users',
                        onChanged: () {}),
                  if (selectedIndex == 3)
                    WebAppbar(
                        title: 'Categories',
                        subTitle: 'Your Categories ',
                        onChanged: () {}),
                  if (selectedIndex == 4)
                    WebAppbar(
                        title: 'Activity Logs',
                        subTitle: 'All Users Activities',
                        onChanged: () {}),

                  SizedBox(
                    height: height(context) * 4,
                  ),
                  //home bar
                  Expanded(
                    child: _tabs[selectedIndex],
                  ),
                  //activity logs eng
                ],
              ),
            ),
          ),
          //appbar and main area end
        ],
      ),
    );
  }
}

class TotalBlock extends StatelessWidget {
  TotalBlock({
    required this.title,
    required this.value,
    required this.icon,
    Key? key,
  }) : super(key: key);
  IconData icon;
  String title;
  String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width(context) * 25,
      height: height(context) * 15,
      padding: EdgeInsets.symmetric(
          vertical: height(context) * 1, horizontal: width(context) * 1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: shadow),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: contentColor,
                ),
              ),
              SizedBox(
                height: height(context) * 0.5,
              ),
              Text(
                value,
                style: TextStyle(
                    color: primaryColor,
                    fontSize: 34,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          CircleAvatar(
            radius: width(context) * 3,
            backgroundColor: btnbgColor.withOpacity(0.2),
            child: Icon(
              icon,
              size: width(context) * 3,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class BarButton extends StatelessWidget {
  BarButton({
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  String title;
  void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(213, 178, 79, 0.3),
            borderRadius: BorderRadius.circular(15)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
