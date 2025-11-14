import 'package:flutter/material.dart';

class Helper {
  static Future<T?> handleRequest<T>(Future<T> Function() action) async {
    try {
      return await action();
    } catch (e, stackTrace) {
      debugPrint('Error occured: $e');
      debugPrint('Stack Trace: $stackTrace');
      return null;
    } 

  }
}