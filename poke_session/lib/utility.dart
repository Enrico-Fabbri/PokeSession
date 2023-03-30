import 'package:flutter/foundation.dart';

class Utility {
  static const String blue = '\u001b[34m';
  static const String green = '\u001b[32m';
  static const String yellow = '\u001b[33m';
  static const String red = '\u001b[31m';
  static const String reset = '\u001b[0m';

  static void printInfo(String message) {
    if (kDebugMode) {
      print(blue + message + reset);
    }
  }

  static void printDebug(String message) {
    if (kDebugMode) {
      print(green + message + reset);
    }
  }

  static void printAttention(String message) {
    if (kDebugMode) {
      print(yellow + message + reset);
    }
  }

  static void printError(String message) {
    if (kDebugMode) {
      print(red + message + reset);
    }
  }
}
