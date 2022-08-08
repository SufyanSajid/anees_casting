import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class Category {
  String id;
  String title;
  String parentId;
  Category({
    required this.id,
    required this.parentId,
    required this.title,
  });
}

class Categories with ChangeNotifier {
  List<Category> _categories = [];
  List<Category> _parentCategories = [];
  List<Category> _childCategories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Category> get parentCategories {
    return [..._parentCategories];
  }

  List<Category> get childCategories {
    return [..._childCategories];
  }

  Future<void> uploadCatagory(String parentId, String title) async {
    try {
      await db
          .collection("categories")
          .add({"title": title, "parentId": parentId});
    } catch (e) {
      print(e.toString());
    }
  }

  fetchAndUpdateCategoris() async {
    try {
      QuerySnapshot<Map<String, dynamic>> catSnap =
          await db.collection("categories").get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = catSnap.docs;
      List<Category> categories = [];
      List<Category> parentCategories = [];
      List<Category> childCategories = [];

      for (var i = 0; i < docs.length; i++) {
        var doc = docs[i];
        categories.add(Category(
            id: doc.id,
            parentId: doc.data()["parentId"],
            title: doc.data()["title"]));
      }
      // seprate parents and childs
      for (var cat in categories) {
        cat.parentId == ""
            ? parentCategories.add(cat)
            : childCategories.add(cat);
      }

      _categories = categories;
      _parentCategories = parentCategories;
      _childCategories = childCategories;

      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
