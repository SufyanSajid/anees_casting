import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum language {
  English,
  Urdu,
}

class Language extends ChangeNotifier {
  language currentLang = language.Urdu;

  Map<String, String> english = {
    'welcome': 'Welcome Back',
    'admin': 'Admin',
    'customer': 'Customer',
    'seller': 'Seller',
    'quick_links': 'Quick Links',
    'designs': 'Designs',
    'categories': 'Categories',
    'categories_list': 'Categories List',
    'customers': 'Customers',
    'app_user': 'App User',
    'view_all': 'View All',
    'language': 'English'
  };
  Map<String, String> urdu = {
    'welcome': 'خوش آمدید',
    'admin': 'ایڈمن',
    'customer': 'صارف',
    'seller': 'بیچنے والے',
    'quick_links': 'فوری رابطے',
    'designs': 'ڈیزائنز',
    'categories': 'اقسام',
    'categories_list': 'زمرہ جات کی فہرست',
    'customers': 'گاہک',
    'app_user': 'ایپ صارف',
    'view_all': 'سب دیکھیں',
    'language': 'اردو',
  };

  String get(String key) {
    print(key.toLowerCase());
    key = key.toLowerCase();
    var en = (english[key] != null ? english[key] : key);
    var ur = (urdu[key] != null ? urdu[key] : key);
    return currentLang == language.English ? en! : ur!;
  }

  void setLang(language lang) async {
    currentLang = lang;
    var shared = await SharedPreferences.getInstance();
    shared.setString('language', lang.toString());
    notifyListeners();
  }

  void defaultLang() async {
    var shared = await SharedPreferences.getInstance();
    if (shared.containsKey('language')) {
      var lang = shared.get('language');
      print('gsdhsgfgshddfhs');
      currentLang = lang == language.English.toString()
          ? language.English
          : language.Urdu;
      notifyListeners();
    }
  }
}
