import 'dart:convert';
import 'dart:developer';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Models/pagination.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../contant.dart';
import 'category.dart';

class Product {
  String id;
  String name;
  String categoryId;
  String length;
  String width;
  String unit;
  String image;
  String dateTime;
  List<String> customers;
  String categoryTitle;

  Product({
    required this.id,
    required this.name,
    required this.length,
    required this.width,
    required this.unit,
    required this.categoryId,
    required this.categoryTitle,
    required this.image,
    required this.customers,
    required this.dateTime,
  });
}

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _catProducts = [];
  List<Product> _cutomerProducts = [];
  List<Product> _cutomerCatProducts = [];
  List<Product> productsToSort = [];
  List<Product> catProductsToSort = [];

  List<CustomPage> _pages = [];
  List<CustomPage> _catpages = [];

  Product? drawerProduct;
  String? pageToken;
  GlobalKey<ScaffoldState>? scaffoldKey;
  int _total = 0;

  int get total {
    return _total;
  }

  void setProduct(Product prod) {
    drawerProduct = prod;
  }

  void setScaffoldKey(var key) {
    scaffoldKey = key;
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get customerProducts {
    return [..._cutomerProducts];
  }

  List<Product> get customerCatProducts {
    return [..._cutomerCatProducts];
  }

  List<Product> get catProducts {
    return [..._catProducts];
  }

  List<CustomPage> get pages {
    return [..._pages];
  }

  List<CustomPage> get catpages {
    return [..._catpages];
  }

  bool deleteLoader = false;

  String? deleteCatId;

  List<Product> getCustCatProducts({required String catId}) {
    return _cutomerProducts
        .where((element) => element.categoryId == catId)
        .toList();
  }

  void setDeleteCatId(String value) {
    deleteCatId = value;
    notifyListeners();
  }

  void setLoader(bool value) {
    deleteLoader = value;
    notifyListeners();
  }

  void getProductsByDate() {
    _products = productsToSort;
    notifyListeners();
  }

  void getCatProdByDate() {
    _catProducts = catProductsToSort;
    notifyListeners();
  }

  void setProductByName() {
    _products
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void setCatProductByName() {
    _catProducts
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  Future<void> addProduct({
    required Product product,
    required userToken,
    required String imageExtension,
  }) async {
    // try {
    final url = Uri.parse('${baseUrl}products');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'name': product.name,
      'image': product.image,
      'length': product.length,
      'width': product.width,
      'unit': product.unit,
      'ext': imageExtension,
      'category_id': product.categoryId,
    });
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      // print(extractedData['message']);
      var data = extractedData['data'];
      Product prod = Product(
          id: data['id'].toString(),
          name: data['name'],
          length: data['length'],
          width: data['width'],
          unit: data['unit'],
          customers: [],
          categoryId: data['category_id'].toString(),
          categoryTitle: data['category_name'],
          image: data['imageUrl'],
          dateTime: data['created_at']);

      _products.add(prod);
      notifyListeners();
    } else {
      var message = extractedData['message'];
      print(message);
      // throw message;
    }
    // }
    //  catch (error) {
    //   print(error);
    //   throw error;
    // }
  }

  void updateProductLocally(Product prod) {
    _products.removeWhere((element) => element.id == prod.id);
    _products.add(prod);
    notifyListeners();
  }

  void addCustomer(String cusId, String prodId) {
    var prod = _products.firstWhere((element) => element.id == prodId);
    prod.customers.add(cusId);

    notifyListeners();
  }

  void removeCustomer(String cusId, String prodId) {
    List<Product> prods =
        _products.where((element) => element.id == prodId).toList();
    if (prods.isNotEmpty) {
      var prod = _products.firstWhere((element) => element.id == prodId);
      prod.customers.remove(cusId);
    }
    notifyListeners();
  }

  Product getProdById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  CustomPage fromLink(Map<String, dynamic> link) {
    return CustomPage(
      id: DateTime.now().millisecond.toString(),
      title: link['label'],
      active: link['active'],
      url: link['url'] ?? '',
    );
  }

  Future<void> fetchAndUpdateProducts(
      {String? page, required String userToken, bool? forced}) async {
    if (forced == false) {
      if (products.isNotEmpty) {
        return;
      }
    }
    List<Product> tempProds = [];
    Uri url = Uri.parse('${baseUrl}products?page=${page}');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    var extractedData = json.decode(response.body);
    print(extractedData);

    _total = extractedData['meta']['total'];
    var data = extractedData['data'] as List<dynamic>;
    data.forEach((prod) {
      List<String> tempCustomers = [];
      var customers = prod['customers'] as List<dynamic>;
      customers.forEach((cust) {
        tempCustomers.add(cust.toString());
      });
      tempProds.add(
        Product(
          id: prod['id'].toString(),
          name: prod['name'],
          length: prod['length'],
          width: prod['width'],
          unit: prod['unit'],
          customers: tempCustomers,
          categoryId: prod['category_id'].toString(),
          categoryTitle: prod['category_name'],
          image: prod['imageUrl'],
          dateTime: prod['created_at'],
        ),
      );
    });
    _products = tempProds;
    productsToSort = _products;
    notifyListeners();
    var metaData = extractedData['meta'];
    var links = metaData['links'] as List<dynamic>;

    List<CustomPage> tempPage = [];

    if (links.isNotEmpty) {
      for (var link in links) {
        CustomPage page = fromLink(link);
        tempPage.add(page);
      }
      _total = metaData['total'];
      _pages = tempPage;
      notifyListeners();
    } else {
      var message = extractedData['message'];
      log(message.toString());
      //throw message;
    }
    print(_pages.length);
  }

  Future<void> getCatProducts(
      {required String userToken, String? page, required String catId}) async {
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}products?cat_id=$catId&page=$page');
    print(url);
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    var extractedData = json.decode(response.body);
    print(extractedData);

    //if (extractedData['success'] == true) {
    var data = extractedData['data'] as List<dynamic>;
    data.forEach((prod) {
      List<String> tempCustomers = [];
      var customers = prod['customers'] as List<dynamic>;
      customers.forEach((cust) {
        tempCustomers.add(cust.toString());
      });
      tempProds.add(
        Product(
          id: prod['id'].toString(),
          name: prod['name'],
          length: prod['length'],
          width: prod['width'],
          unit: prod['unit'],
          customers: tempCustomers,
          categoryId: prod['category_id'].toString(),
          categoryTitle: prod['category_name'],
          image: prod['imageUrl'],
          dateTime: prod['created_at'],
        ),
      );
    });

    print('yeh ha cat prods ${tempProds.length}');

    var metaData = extractedData['meta'];
    var links = metaData['links'] as List<dynamic>;
    List<CustomPage> tempPage = [];

    if (links.isNotEmpty) {
      for (var link in links) {
        CustomPage page = fromLink(link);
        tempPage.add(page);
      }
    }
    _catpages = tempPage;
    _catProducts = tempProds;
    catProductsToSort = _catProducts;
    notifyListeners();
    // }
  }

  Future<void> getPaginationProducts() async {
    http.Response res =
        await FirestoreMethods().getChunkRecords(collection: "products");
  }

  Future<void> searchProduct({
    required String title,
    required String userToken,
    String? catId,
  }) async {
    print('yeh ha cat id $catId');
    List<Product> tempProds = [];
    var url;
    var cat_id = catId == null ? '' : catId;
    if (cat_id == '') {
      url = Uri.parse('${baseUrl}search_products?search=$title');
    } else {
      print('yes');
      url =
          Uri.parse('${baseUrl}search_products?cat_id=${cat_id}&search=$title');
    }
    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );
    var extractedData = json.decode(response.body);

    if (extractedData['success'] == true) {
      var data = extractedData['data'] as List<dynamic>;
      data.forEach((prod) {
        List<String> tempCustomers = [];
        var customers = prod['customers'] as List<dynamic>;
        customers.forEach((cust) {
          tempCustomers.add(cust.toString());
        });
        tempProds.add(
          Product(
            id: prod['id'].toString(),
            name: prod['name'],
            length: prod['length'],
            width: prod['width'],
            unit: prod['unit'],
            customers: tempCustomers,
            categoryId: prod['category_id'].toString(),
            categoryTitle: prod['category_name'],
            image: prod['imageUrl'],
            dateTime: prod['created_at'],
          ),
        );
        if (cat_id == '') {
          _products = tempProds;
        } else {
          _catProducts = tempProds;
        }
        notifyListeners();
      });
    }

    notifyListeners();
  }

  Future<void> deleteProduct(String prodId, String userToken) async {
    try {
      final url = Uri.parse('${baseUrl}products/$prodId');
      print(url);
      var response = await http.delete(url, headers: {
        'Authorization': 'Bearer $userToken',
      });
      var extractedResponse = json.decode(response.body);
      if (extractedResponse['success'] == true) {
        print(extractedResponse['message']);
        _catProducts.removeWhere((element) => element.id == prodId);
        _products.removeWhere((element) => element.id == prodId);
        notifyListeners();
      } else {
        var message = extractedResponse['message'];
        throw message;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(
      {required Product product,
      required String userToken,
      required String imageExtension}) async {
    Product prod;

    final url = Uri.parse('${baseUrl}products/${product.id}');

    print(product.image);

    var response = await http.patch(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'name': product.name,
      if (product.image.isNotEmpty) 'image': product.image,
      'length': product.length,
      'width': product.width,
      'unit': product.unit,
      if (product.image.isNotEmpty) 'ext': imageExtension,
      'category_id': product.categoryId,
    });

    print(response.body);
    var extractedData = json.decode(response.body);
    if (extractedData['success'] == true) {
      var prod = extractedData['data'];

      List<String> tempCustomers = [];
      var customers = prod['customers'] as List<dynamic>;
      customers.forEach((cust) {
        tempCustomers.add(cust.toString());
      });

      prod = Product(
        id: prod['id'].toString(),
        name: prod['name'],
        length: prod['length'],
        width: prod['width'],
        unit: prod['unit'],
        customers: tempCustomers,
        categoryId: prod['category_id'].toString(),
        categoryTitle: prod['category_name'],
        image: prod['imageUrl'],
        dateTime: prod['created_at'],
      );
      _products.removeWhere((element) => element.id == prod.id);
      _products.add(prod);
      _catProducts.removeWhere((element) => element.id == prod.id);
      _catProducts.add(prod);
      notifyListeners();
    } else {
      print('error in updating product');
    }
  }

  Future<void> sendProductToUser({
    required Product product,
    required String userId,
    required String userToken,
  }) async {
    final url = Uri.parse('${baseUrl}assign_customer');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'user_id': userId,
      'product_id': product.id,
    });
  }
 //----only showing products for first page
  Future<void> getCustomerProducts(
      {required String userId, required String userToken}) async {
    print(userId);
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}customer_products?user_id=$userId');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    var extractedResponse = json.decode(response.body);
    // if (extractedResponse['success'] == true) {
      var data = extractedResponse['data'] as List<dynamic>;
      data.forEach((prod) {
        List<String> tempCustomers = [];
        var customers = prod['customers'] as List<dynamic>;
        customers.forEach((cust) {
          tempCustomers.add(cust.toString());
        });
        tempProds.add(
          Product(
            id: prod['id'].toString(),
            name: prod['name'],
            length: prod['length'],
            width: prod['width'],
            unit: prod['unit'],
            customers: tempCustomers,
            categoryId: prod['category_id'].toString(),
            categoryTitle: prod['category_name'],
            image: prod['imageUrl'],
            dateTime: prod['created_at'],
          ),
        );
      });
      _cutomerProducts = tempProds;
      notifyListeners();
    // } else {
    //   var message = extractedResponse['message'];
    //   throw message;
    // }
    // var metaData = extractedResponse['meta'];
    // var links = metaData['links'] as List<dynamic>;
    // List<CustomPage> tempPage = [];

    // if (links.isNotEmpty) {
    //   for (var link in links) {
    //     CustomPage page = fromLink(link);
    //     tempPage.add(page);
    //   }
    // }
    // _cutomerProducts = tempProds;
    // _pages = tempPage;
    // notifyListeners();
    // print(_pages.length);
  }

  Future<void> deleteCustomerProduct({
    required String userId,
    required String prodId,
    required String userToken,
  }) async {
    print(prodId);
    print(userId);
    final url = Uri.parse('${baseUrl}delete_assign_customer');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {
      'user_id': userId,
      'product_id': prodId,
    });
    print(response.body);
  }
}
