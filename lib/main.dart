import 'dart:async';

import 'package:anees_costing/Models/activitylogs.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/language.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Screen/Admin/Design/catlist.dart';
import 'package:anees_costing/Screen/Admin/Design/child_cat.dart';
import 'package:anees_costing/Screen/Admin/Design/desktop/desk_prod.dart';
import 'package:anees_costing/Screen/Admin/Design/prod_list.dart';
import 'package:anees_costing/Screen/Admin/Product/customerproducts.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Screen/Admin/logs/activitylog.dart';
import 'package:anees_costing/Screen/Admin/users/customers.dart';
import 'package:anees_costing/Screen/Auth/forget/newpassword_screen.dart';
import 'package:anees_costing/Screen/Common/profile.dart';
import 'package:anees_costing/Screen/Common/splash.dart';
import 'package:anees_costing/Screen/Customer/cust_cat_prod.dart';
import 'package:anees_costing/Screen/Customer/customer_catchild.dart';
import 'package:anees_costing/Screen/Customer/customer_catlist.dart';
import 'package:anees_costing/Screen/Customer/customer_home.dart';
import 'package:anees_costing/Screen/Customer/all_cat_prod.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

import 'dart:io';

import './Models/category.dart';
import './Models/product.dart';
import './Models/user.dart';
import 'Screen/Admin/Product/addproduct.dart';
import 'Screen/Admin/homepage/admin_home.dart';
import 'Screen/Admin/users/add_user.dart';
import 'Screen/Admin/Product/product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Screen/Admin/category/category.dart';
import 'Screen/Admin/users/users.dart';
import 'Screen/Auth/Login/login.dart';
import 'Screen/Auth/forget/forget_screen.dart';
import 'Screen/Auth/forget/verification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //----- To restrict Desktop app for certain height to avoid overflow -----//
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(710, 650)); // below 710 * 650 cause overflow on few pages
  }
  //----- To restrict Desktop app for certain height to avoid overflow -----//
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (ctx) => Auth(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Users(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Products(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Logs(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Categories(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Counts(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => SentProducts(),
    ),
    ChangeNotifierProvider(
      create: (ctx) => Language(),
    ),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Do you want to exit?"),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            print('yes selected');
                            exit(0);
                          },
                          child: Text("Yes"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade800),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          print('no selected');
                          Navigator.of(context).pop();
                        },
                        child:
                            Text("No", style: TextStyle(color: Colors.black)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  // This widget is the root of your application.
  final _navigatorKey = GlobalKey<NavigatorState>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer(const Duration(minutes: 100), _logOutUser);
  }

  void _logOutUser() {
    print('logut');
    _timer!.cancel();
    Provider.of<Auth>(context, listen: false).logout();

    // Popping all routes and pushing welcome screen
    _navigatorKey.currentState!.pushNamed(LoginScreen.routeName);
  }

  void _handleUserInteraction([_]) {
    print('user interacted');
    _initializeTimer();
  }

  @override
  Widget build(BuildContext context) {
    Auth auth = Auth();
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _handleUserInteraction,
        onPanDown: _handleUserInteraction,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Anees_Casting',
          theme: ThemeData(
            useMaterial3: false,
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.ubuntuTextTheme(),
          ),
          navigatorKey: _navigatorKey,
          routes: {
            '/': (ctx) => SplashScreen(),
            ProfileScreen.routeName: (context) => ProfileScreen(),
            LoginScreen.routeName: (ctx) => const LoginScreen(),
            AdminHomePage.routeName: (ctx) => const AdminHomePage(),
            CategoryScreen.routeName: (ctx) => CategoryScreen(),
            UserScreen.routeName: (ctx) => const UserScreen(),
            CustomerScreen.routeName: (ctx) => CustomerScreen(),
            AdminSideCustomerProductScreen.routeName: (ctx) =>
                const AdminSideCustomerProductScreen(),
            ProductScreen.routeName: (ctx) => ProductScreen(),
            AddProduct.routeName: (ctx) => const AddProduct(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            AddUser.routeName: (ctx) => AddUser(),
            CustomerHomeScreen.routeName: (ctx) => CustomerHomeScreen(),
            CustomerProductScreen.routeName: (ctx) =>
                const CustomerProductScreen(),
            CustomerCatList.routeName: (ctx) => CustomerCatList(),
            CustomerCatChild.routeName: (ctx) => CustomerCatChild(),
            CustomerCatProductScreen.routeName: (ctx) =>
                CustomerCatProductScreen(),
            ActivityLogScreen.routeName: (ctx) => ActivityLogScreen(),
            CategoryListScreen.routeName: (ctx) => const CategoryListScreen(),
            CategoryChildListScreen.routeName: (ctx) =>
                const CategoryChildListScreen(),
            CatProductScreen.routeName: (ctx) => const CatProductScreen(),
            ForgetScreen.routeName: (ctx) => ForgetScreen(),
            VerificationScreen.routeName: (ctx) => VerificationScreen(),
            NewPassScreen.routeName: (ctx) => const NewPassScreen(),
            DesktopCategoryProduct.routeName: (ctx) => DesktopCategoryProduct(),
          },
        ),
      ),
    );
  }
}
