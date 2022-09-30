import 'package:anees_costing/service/autologout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Models/auth.dart';

/// Tracks user activity based on tap/click event
class UserActivityDetector extends StatefulWidget {
  const UserActivityDetector({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  State<UserActivityDetector> createState() => _UserActivityDetectorState();
}

class _UserActivityDetectorState extends State<UserActivityDetector> {
  // Instance of Auto Logout Service, prefer using singleton
  final AutoLogoutService _autoLogoutService = AutoLogoutService();
  final FocusNode focusNode = FocusNode();
  final Auth _authService = Auth();
  @override
  void initState() {
    if (_authService.isUserLoggedIn()) {
      _autoLogoutService.startNewTimer();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(focusNode);
    return KeyboardListener(
      focusNode: focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          _autoLogoutService.trackUserActivity();
        }
      },
      child: GestureDetector(
        // Important for detecting the clicks properly for clickable and non-clickable places.
        behavior: HitTestBehavior.deferToChild,
        onTapDown: _autoLogoutService.trackUserActivity,
        child: widget.child,
      ),
    );
  }
}
