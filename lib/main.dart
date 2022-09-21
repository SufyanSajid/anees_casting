import 'package:anees_costing/Models/activitylogs.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Models/sent_products.dart';
import 'package:anees_costing/Screen/Admin/Design/catlist.dart';
import 'package:anees_costing/Screen/Admin/Design/child_cat.dart';
import 'package:anees_costing/Screen/Admin/Design/prod_list.dart';
import 'package:anees_costing/Screen/Admin/Product/customerproducts.dart';
import 'package:anees_costing/Screen/Admin/Product/product_detail.dart';
import 'package:anees_costing/Screen/Admin/logs/activitylog.dart';
import 'package:anees_costing/Screen/Admin/users/customers.dart';
import 'package:anees_costing/Screen/Common/splash.dart';
import 'package:anees_costing/Screen/Customer/customer_products.dart';
import 'package:flutter/foundation.dart';

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

void main() async {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Anees_Casting',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.ubuntuTextTheme(),
        ),
        routes: {
          '/': (ctx) => SplashScreen(),
          LoginScreen.routeName: (ctx) => const LoginScreen(),
          AdminHomePage.routeName: (ctx) => const AdminHomePage(),
          CategoryScreen.routeName: (ctx) => CategoryScreen(),
          UserScreen.routeName: (ctx) => const UserScreen(),
          CustomerScreen.routeName: (ctx) => CustomerScreen(),
          AdminSideCustomerProductScreen.routeName: (ctx) =>
              AdminSideCustomerProductScreen(),
          ProductScreen.routeName: (ctx) => ProductScreen(),
          AddProduct.routeName: (ctx) => const AddProduct(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          AddUser.routeName: (ctx) => AddUser(),
          CustomerProductScreen.routeName: (ctx) => CustomerProductScreen(),
          ActivityLogScreen.routeName: (ctx) => ActivityLogScreen(),
          CategoryListScreen.routeName: (ctx) => CategoryListScreen(),
          CategoryChildListScreen.routeName: (ctx) => CategoryChildListScreen(),
          CatProductScreen.routeName: (ctx) => CatProductScreen(),
        },
      ),
    );
  }
}
