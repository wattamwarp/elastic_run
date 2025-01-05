import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showSnackBar(String message, {int duration = 3}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
      ),
    );
  }
}
