import 'dart:async';

import 'package:anees_costing/Models/auth.dart';

class AutoLogoutService {
  static Timer? _timer;
  static const autoLogoutTimer = 1000;
  // Instance of authentication service, prefer singleton
  final Auth _authService = Auth();

  /// Resets the existing timer and starts a new timer
  void startNewTimer() {
    stopTimer();
    if (_authService.isUserLoggedIn()) {
      _timer = Timer.periodic(const Duration(seconds: autoLogoutTimer), (_) {
        print(autoLogoutTimer);
        timedOut();
      });
    }
  }

  /// Stops the existing timer if it exists
  void stopTimer() {
    if (_timer != null || (_timer?.isActive != null && _timer!.isActive)) {
      _timer?.cancel();
    }
  }

  /// Track user activity and reset timer
  void trackUserActivity([_]) async {
    print('User Activity Detected!');
    if (_authService.isUserLoggedIn() && _timer != null) {
      startNewTimer();
    }
  }

  /// Called if the user is inactive for a period of time and opens a dialog
  Future<void> timedOut() async {
    print('timmeeeeeeeeeeeeeeeee out');
    print(_authService.autoLogout);
    stopTimer();
    if (_authService.isUserLoggedIn()) {
      // Logout the user and pass the reason to the Auth Service
      _authService.logout();
      _authService.setAutoLogout(true);
      print(_authService.autoLogout);
    }
  }
}
