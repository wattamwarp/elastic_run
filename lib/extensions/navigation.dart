import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  Future<T?> pushReplacement<T>(Widget page) {
    return Navigator.of(this).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  void popUntilRoot() {
    Navigator.of(this).popUntil((route) => route.isFirst);
  }
}
