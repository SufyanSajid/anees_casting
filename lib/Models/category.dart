import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Helpers/firestore_methods.dart';
import '../contant.dart';

class Category {
  String id;
  String title;
  String parentTitle;
  String parentId;
  Category({
    required this.id,
    required this.parentId,
    required this.title,
    required this.parentTitle,
  });
}

class Categories with ChangeNotifier {
  Category? drawerCategory;

  void setCatgeory(Category cat) {
    drawerCategory = cat;
  }

  List<Category> _categories = [];
  List<Category> _parentCategories = [];
  List<Category> _childCategories = [];
  List<Category> _searchedCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Category> get parentCategories {
    return [..._parentCategories];
  }

  List<Category> get childCategories {
    return [..._childCategories];
  }

  List<Category> get searchedCategories {
    return [..._searchedCategories];
  }

  Future<void> uploadCatagory(
      {required String parentId,
      required String title,
      required userToken}) async {
    try {
      final url = Uri.parse('${baseUrl}categories');
      http.Response response;

      if (parentId.isEmpty) {
        response = await http.post(url, headers: {
          'Authorization': 'Bearer ${userToken}'
        }, body: {
          'name': title,
        });
      } else {
        response = await http.post(url, headers: {
          'Authorization': 'Bearer ${userToken}'
        }, body: {
          'name': title,
          'parent_id': parentId,
        });
      }
      var extractedData = json.decode(response.body);
      if (extractedData['success'] == true) {
        print('uploaded');
      } else {
        var message = extractedData['message'];
        throw message;
      }

      print(response.body);
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchAndUpdateCat(String userToken) async {
    print('yeh ha user token $userToken');
    List<Category> tempCat = [];
    List<Category> tempParentCat = [];
    List<Category> tempChildCat = [];

    final url = Uri.parse('${baseUrl}categories');

    var response = await http.post(url, headers: {
      'Authorization': 'Bearer $userToken',
    }, body: {});
    print(response.body);

    // for (var cat in tempCat) {
    //   cat.parentId.isEmpty ? tempParentCat.add(cat) : tempChildCat.add(cat);
    // }

    _categories = tempCat;
    _parentCategories = tempParentCat;
    _childCategories = tempChildCat;
    notifyListeners();
  }

  // Add new items in categories list

  bool isCatExist({required String title, required String parentTitle}) {
    bool catExist = false;

    for (var element in _categories) {
      if (element.title == title && element.parentTitle == parentTitle) {
        catExist = true;
        break;
      }
    }

    return catExist;
  }

  Category? getCategoryById(String id) {
    for (var element in _categories) {
      if (element.id == id) {
        print(element);
        return element;
      }
    }
    print("No Elemtne");
    return null;
  }

  getCategoriesByTitle(Category cat) {
    List<Category> tempCat = [];
    for (var element in _categories) {
      if (element.title == cat.title) {
        tempCat.add(element);
      }
    }
    _searchedCategories = tempCat;
    // notifyListeners();
  }

  resetSearchedCats() {
    _searchedCategories = [];
    // notifyListeners();
  }
}
