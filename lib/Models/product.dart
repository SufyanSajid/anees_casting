import 'dart:convert';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../contant.dart';

class Product {
  String id;
  String name;
  String categoryId;
  String length;
  String width;
  String unit;
  String image;
  String dateTime;
  List<String>? customers;
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
    this.customers,
    required this.dateTime,
  });
}

class Products with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _catProducts = [];
  Product? drawerProduct;
  String? pageToken;

  void setProduct(Product prod) {
    drawerProduct = prod;
  }

  List<Product> get products {
    return [..._products];
  }

  List<Product> get catProducts {
    return [..._catProducts];
  }

  Future<void> addProduct({
    required Product product,
    required userToken,
    required String imageExtension,
  }) async {
    try {
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
        print(extractedData['message']);
        var data = extractedData['data'];
        Product prod = Product(
            id: data['id'].toString(),
            name: data['name'],
            length: data['length'],
            width: data['width'],
            unit: data['unit'],
            categoryId: data['category_id'].toString(),
            categoryTitle: data['category_name'],
            image: data['imageUrl'],
            dateTime: data['created_at']);

        _products.add(prod);
        notifyListeners();
      } else {
        var message = extractedData['message'];
        throw message;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }

  void addCustomer(String cusId, String prodId) {
    var prod = _products.firstWhere((element) => element.id == prodId);
    prod.customers!.add(cusId);

    notifyListeners();
  }

  void removeCustomer(String cusId, String prodId) {
    List<Product> prods =
        _products.where((element) => element.id == prodId).toList();
    if (prods.isNotEmpty) {
      var prod = _products.firstWhere((element) => element.id == prodId);
      prod.customers!.remove(cusId);
    }
    notifyListeners();
  }

  Product getProdById(String id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndUpdateProducts(String userToken) async {
    if (products.isNotEmpty) {
      return;
    }
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}products');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
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
      });
      _products = tempProds;
      notifyListeners();
    } else {
      var message = extractedData['message'];
      throw message;
    }
  }

  Future<void> getCatProducts(
      {required String userToken, required String catId}) async {
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}products?cat_id=$catId');
    print(url);
    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
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
        _catProducts = tempProds;
        notifyListeners();
      });
    }
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

  Future<List<Product>> getCustomerProducts(
      String userId, String userToken) async {
    print(userId);
    List<Product> tempProds = [];
    final url = Uri.parse('${baseUrl}customer_products?user_id=$userId');

    var response = await http.get(url, headers: {
      'Authorization': 'Bearer $userToken',
    });
    var extractedResponse = json.decode(response.body);
    if (extractedResponse['success'] == true) {
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
      return tempProds;
    } else {
      var message = extractedResponse['message'];
      throw message;
    }

    // print(documents.toString());
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
