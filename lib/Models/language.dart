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
    'user': ' User',
    'all users here': 'All users here',
    'all': "all",
<<<<<<< Updated upstream
    'password': 'Password',
    'email': 'email',
    'name': 'name',
    'phone': 'phone',
    'add user': 'add user',
    'edit user': 'edit user',
    'log': 'Log',
    'users activities': 'users activities',
    'share': 'Share',
    'activity': 'Activity',
    'profile': 'Profile',
    'edit your profile': 'Edit Your Profile',
    'change name': 'Change Name',
    'change password': 'Change Password',
    'new password': 'New Password',
    'confirm new password': 'Confirm New Password',
    'first name': 'First Name',
    'last name': 'Last Name',
=======
    'dashboard': 'Dashboard',
    'contains all data': 'Contains All Data',
    'profile': 'Profile',
    'logout': "Logout",
    'logout from aness casting': 'Logout from Aness casting',
    'click on the logout button to proceed':
        'Click on the logout button to proceed',
    'cancel': 'Cancel',
    'change your name and Password': 'Change your name and Password',
>>>>>>> Stashed changes
    'language': 'English',
  };
  Map<String, String> urdu = {
    'welcome': 'خوش آمدید',
    'admin': 'ایڈمن',
    'customer': 'گاہک',
    'seller': 'سیلر',
    'quick_links': 'فوری رابطے',
    'designs': 'ڈیزائنز',
    'categories': 'اقسام',
    'categories_list': ' اقسام کی فہرست',
    'customers': 'گاہک',
    'app_user': 'ایپ صارف',
    'view_all': 'سب دیکھیں',
    'all': "تمام",
    'user': ' صارف',
    'all users here': 'تمام صارف',
<<<<<<< Updated upstream
    'password': 'پاس ورڈ',
    'email': 'ای میل',
    'name': 'نام',
    'phone': 'موبائل نمبر',
    'edit user': 'تبدیل کریں',
    'add user': 'اندراج کریں',
    'log': 'لاگ',
    'users activities': 'صارف کی سرگرمیاں',
    'share': 'شیئر',
    'activity': 'سرگرمی',
    'profile': 'پروفائل',
    'edit your profile': 'پروفائل تبدیل کریں',
    'change name': 'نام تبدیل کریں',
    'change password': 'پاس ورڈ تبدیل کریں',
    'new password': 'نیا پاس ورڈ',
    'confirm new password': 'نیا پاس ورڈ',
    'first name': 'پہلا نام',
    'last name': 'آخری نام',
=======
    'dashboard': 'ڈیش بورڈ',
    'contains all data': 'تمام ریکارڈ',
    'profile': 'پروفائل',
    'logout': "لاگ آؤٹ",
    'logout from aness casting': 'انیس کا سٹنگ سے لاگ آؤٹ',
    'click on the logout button to proceed': 'بٹن دبائیں',
    'cancel': 'مؤخر کریں',
    'change your name and password': 'اپنا نام اور پاسورڈ تبدیل کریں',
    'cat list': 'Cats List',
    'add new category': 'Add New Category',
    'name': 'Name',
>>>>>>> Stashed changes
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
      currentLang = lang == language.English.toString()
          ? language.English
          : language.Urdu;
      notifyListeners();
    }
  }
}
