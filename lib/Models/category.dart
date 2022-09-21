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

  Category? getParent(String id) {
    return _categories.firstWhere((element) => element.id == id);
  }

  List<Category> getChildCategories(String catId) {
    return _categories.where((cat) => catId == cat.parentId).toList();
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

  Future<void> deleteCategory(String catId, String userToken) async {
    final url = Uri.parse('${baseUrl}categories/$catId');

    var response =
        await http.delete(url, headers: {'Authorization': 'Bearer $userToken'});

    print(response.body);
  }

  Future<void> fetchAndUpdateCat(String userToken) async {
    try {
      print('yeh ha user token $userToken');
      List<Category> tempCat = [];
      List<Category> tempParentCat = [];
      List<Category> tempChildCat = [];

      final url = Uri.parse('${baseUrl}categories');

      var response = await http.get(url, headers: {
        'Authorization': 'Bearer $userToken',
      });

      var extractedData = json.decode(response.body);

      if (extractedData['success'] == true) {
        var data = extractedData['data'] as List<dynamic>;

        data.forEach((cat) {
          String parentId;
          String parentName;
          if (cat['parent_id'] == null) {
            parentId = '';
          } else {
            parentId = cat['parent_id'].toString();
          }

          if (cat['parent_name'] == null) {
            parentName = '';
          } else {
            parentName = cat['parent_name'].toString();
          }
          tempCat.add(
            Category(
              id: cat['id'].toString(),
              parentId: parentId,
              title: cat['name'],
              parentTitle: parentName,
            ),
          );
        });
        for (var cat in tempCat) {
          cat.parentId.isEmpty ? tempParentCat.add(cat) : tempChildCat.add(cat);
        }
        _categories = tempCat;
        _parentCategories = tempParentCat;
        _childCategories = tempChildCat;

        print(_categories.length);

        notifyListeners();
      } else {
        var message = extractedData['message'];
        throw message;
      }
    } catch (error) {
      print(error);
    }
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
