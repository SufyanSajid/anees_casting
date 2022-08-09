import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Screen/Common/splash.dart';

import './Models/category.dart';
import './Models/product.dart';
import './Models/user.dart';
import './Screen/Admin/addproduct.dart';
import 'Screen/Admin/add_user.dart';
import './Screen/Admin/homepage.dart';
import './Screen/Admin/product.dart';
// import '../Screen/Auth/login.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Screen/Admin/category.dart';
import 'Screen/Admin/users.dart';
import 'Screen/Auth/login.dart';

void main() async {
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
          create: (ctx) => Categories(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Users(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Products(),
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
          LoginScreen.routeName: (ctx) => LoginScreen(),
          AdminHomePage.routeName: (ctx) => AdminHomePage(),
          CategoryScreen.routeName: (ctx) => CategoryScreen(),
          UserScreen.routeName: (ctx) => UserScreen(),
          ProductScreen.routeName: (ctx) => ProductScreen(),
          AddProduct.routeName: (ctx) => AddProduct(),
          AddUser.routeName: (ctx) => AddUser(),
        },
      ),
    );
  }
}
