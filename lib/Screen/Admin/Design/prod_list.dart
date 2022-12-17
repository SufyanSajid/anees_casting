import 'package:anees_costing/Models/category.dart';
import 'package:anees_costing/Widget/drawer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../Models/auth.dart';
import '../../../Models/language.dart';
import '../../../Models/pagination.dart';
import '../../../Models/product.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';
import '../../../Widget/input_feild.dart';
import '../../../Widget/paginate.dart';
import '../../../Widget/send_button.dart';
import '../../../contant.dart';
import '../Product/addproduct.dart';
import '../Product/content.dart';
import '../Product/functions/getsearchedproducts.dart';
import '../Product/product_detail.dart';

class CatProductScreen extends StatefulWidget {
  static const routeName = '/cat-prod';
  const CatProductScreen({super.key});

  @override
  State<CatProductScreen> createState() => _CatProductScreenState();
}

class _CatProductScreenState extends State<CatProductScreen> {
  final _productController = TextEditingController();
  bool isFirst = true;
  bool isLoading = false;
  CurrentUser? currentUser;
  String selectedFilter = 'By Date';
  Category? cat;

  @override
  void didChangeDependencies() async {
    print(123);
    // TODO: implement didChangeDependencies
    if (isFirst) {
      print('did');
      print(456);
      cat = ModalRoute.of(context)!.settings.arguments as Category;
      currentUser = Provider.of<Auth>(context).currentUser;

      print(789);
      setState(() {
        isLoading = true;
      });
      await Provider.of<Products>(context, listen: false)
          .getCatProducts(page: '1',userToken: currentUser!.token, catId: cat!.id);

      setState(() {
        isLoading = false;
      });
    }
    isFirst = false;

    super.didChangeDependencies();
  }

  _deleteProduct({required imgUrl, required prodId}) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: btnbgColor.withOpacity(0.8),
              title: const Text(
                'Are Your sure ?',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Design will be deleted Permanently',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // if (isLoading) {
                    //   setState(() {
                    //     showLoaderDialog(context, 'Loading..');
                    //   });
                    // }
                    setState(() {
                      isLoading = true;
                    });
                    var provider =
                        Provider.of<Products>(context, listen: false);

                    await provider.deleteProduct(prodId, currentUser!.token);

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'),
                ),
              ],
            ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Language languageProvider = Provider.of<Language>(context, listen: true);
    List<Product> products = Provider.of<Products>(context).catProducts;
    List<CustomPage> pages =
        Provider.of<Products>(context,).catpages;
    
    
    void _onPageChange(CustomPage page) {
      // print(p.url);
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context, listen: false)
          .getCatProducts(
              page: page.url.split('=').last, catId: cat!.id, userToken: currentUser!.token)
          .then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Appbar(
                title: languageProvider.get('Product'),
                subtitle: languageProvider.get('List of Products'),
                svgIcon: 'assets/icons/daimond.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: InputFeild(
                      hinntText: 'Search Product',
                      validatior: () {},
                      inputController: _productController,
                      submitted: (value) {
                        getSearchedProductByCat(
                            search: value, context: context, catId: cat!.id);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PopupMenuButton(
                      tooltip: languageProvider.get('Filters'),
                      icon: Icon(
                        Icons.more_vert,
                        color: primaryColor,
                      ),
                      color: btnbgColor.withOpacity(1),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          onTap: () {
                            setState(() {
                              isLoading = true;
                            });
                            Provider.of<Products>(context, listen: false)
                                .getCatProdByDate();
                            setState(() {
                              isLoading = false;
                            });
                            setState(() {
                              selectedFilter = 'By Date';
                            });
                          },
                          child: Text(
                            languageProvider.get('by date'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            Provider.of<Products>(context, listen: false)
                                .setCatProductByName();
                            setState(
                              () {
                                selectedFilter = 'By Name';
                              },
                            );
                          },
                          child: Text(
                            languageProvider.get('by name'),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height(context) * 3,
              ),
              Expanded(
                child: isLoading
                    ? Center(
                        child: AdaptiveIndecator(
                          color: primaryColor,
                        ),
                      )
                    : products.isEmpty
                        ? Center(
                            child: Text('No Products to show'),
                          )
                        : GridView.builder(
                            cacheExtent: 9999,
                            // physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 15.0,
                            ),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return Container(
                                key: ValueKey(products[index].id),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: const Offset(0, 5),
                                        blurRadius: 15),
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset: -Offset(5, 0),
                                        blurRadius: 5)
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                ProductDetailScreen.routeName,
                                                arguments: products[index]);
                                          },
                                          child: ExtendedImage.network(
                                            products[index].image,
                                            fit: BoxFit.cover,
                                            cache: true,
                                          )
                                          // Image.network(
                                          //   products[index].image,
                                          //   fit: BoxFit.contain,
                                          //   height: height(context) * 12,
                                          //   width: width(context) * 100,
                                          // ),
                                          ),
                                    ),
                                    SizedBox(
                                      height: height(context) * 0.5,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              alignment: Alignment.bottomCenter,
                                              child: Text(
                                                products[index].name,
                                                style: GoogleFonts.righteous(
                                                  color: headingColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (currentUser!.role!
                                                        .toLowerCase() ==
                                                    'admin')
                                                  Expanded(
                                                    child: PopupMenuButton(
                                                      icon: Icon(
                                                        Icons.more_vert,
                                                        color: primaryColor
                                                            .withOpacity(0.8),
                                                      ),
                                                      itemBuilder: (BuildContext
                                                              context) =>
                                                          <PopupMenuEntry>[
                                                        PopupMenuItem(
                                                          child: PopupItem(
                                                            icon: Icons
                                                                .edit_outlined,
                                                            text: 'Edit',
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  AddProduct
                                                                      .routeName,
                                                                  arguments: {
                                                                    "action":
                                                                        "edit",
                                                                    "product":
                                                                        products[
                                                                            index]
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                        PopupMenuItem(
                                                          child: PopupItem(
                                                            icon: Icons.delete,
                                                            text: 'Delete',
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _deleteProduct(
                                                                  imgUrl: products[
                                                                          index]
                                                                      .image,
                                                                  prodId: products[
                                                                          index]
                                                                      .id);
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                Flexible(
                                                  child: SendProductButton(
                                                      prod: products[index]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...pages.map(
                      (page) => Paginate(
                        page: page,
                        onTap: page.url.isEmpty
                            ? () {}
                            : () => _onPageChange(page),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
