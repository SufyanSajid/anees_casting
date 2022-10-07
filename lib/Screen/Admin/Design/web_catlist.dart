// import 'package:anees_costing/Screen/Admin/Design/child_cat.dart';
// import 'package:anees_costing/Screen/Admin/Design/prod_list.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../Models/auth.dart';
// import '../../../Models/category.dart';
// import '../../../Widget/adaptive_indecator.dart';
// import '../../../contant.dart';

// class CategoryListWeb extends StatefulWidget {
//   const CategoryListWeb({super.key});

//   @override
//   State<CategoryListWeb> createState() => _CategoryListWebState();
// }

// class _CategoryListWebState extends State<CategoryListWeb> {
//   bool isFirst = true;
//   bool isLoading = false;
//   List<Category> categories = [];
//   CurrentUser? currentUser;

//   @override
//   void didChangeDependencies() async {
//     if (isFirst) {
//       currentUser = Provider.of<Auth>(context, listen: false).currentUser;
//       if (Provider.of<Categories>(context, listen: false).categories.isEmpty) {
//         setState(() {
//           isLoading = true;
//         });
//         await Provider.of<Categories>(context, listen: false)
//             .fetchAndUpdateCat(currentUser!.token);
//         setState(() {
//           isLoading = false;
//         });
//       }
//       isFirst = false;
//     }
//     // TODO: implement didChangeDependencies
//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var categories = Provider.of<Categories>(context).parentCategories;
//     return Column(
//       children: [
//         SizedBox(
//           height: height(context) * 3,
//         ),
//         Expanded(
//           child: isLoading
//               ? Center(
//                   child: AdaptiveIndecator(color: primaryColor),
//                 )
//               : GridView.builder(
//                   shrinkWrap: true,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 5,
//                     crossAxisSpacing: 20.0,
//                     mainAxisSpacing: 20.0,
//                   ),
//                   itemCount: categories.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       splashColor: primaryColor,
//                       onTap: () {
//                         List<Category> cats =
//                             Provider.of<Categories>(context, listen: false)
//                                 .getChildCategories(categories[index].id);
//                         if (cats.isEmpty) {
//                           Navigator.of(context).pushNamed(
//                               CatProductScreen.routeName,
//                               arguments: categories[index]);
//                         } else {
//                           Navigator.of(context).pushReplacementNamed(
//                               CategoryChildListScreen.routeName,
//                               arguments: categories[index]);
//                           print('next cat');
//                         }
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(5),
//                           border: Border.all(
//                               color: btnbgColor.withOpacity(0.6), width: 1),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Colors.grey,
//                               offset: Offset(0, 5),
//                               blurRadius: 5,
//                             )
//                           ],
//                         ),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.category_outlined,
//                               color: primaryColor,
//                               size: 40,
//                             ),
//                             SizedBox(
//                               height: height(context) * 1,
//                             ),
//                             Text(
//                               categories[index].title,
//                               style: TextStyle(
//                                   color: headingColor,
//                                   fontWeight: FontWeight.w700,
//                                   fontSize: 20),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         )
//       ],
//     );
//   }
// }
