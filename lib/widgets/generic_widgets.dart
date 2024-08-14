import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class GenericFlushbar {
  static void showErrorFlushbar(BuildContext context, String message) {
    Flushbar(
      title: "Error",
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.error_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showInfoFlushbar(BuildContext context, String message) {
    Flushbar(
      title: "Info",
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.blue,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static void showSuccessFlushbar(BuildContext context, String message) {
    Flushbar(
      title: "Success",
      message: message,
      margin: const EdgeInsets.all(8),
      borderRadius: BorderRadius.circular(8),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.info_outline, color: Colors.white),
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}

class GenericText extends StatelessWidget {
  final String text;
  final double fontSize;
  final TextAlign textAlign;

  const GenericText({
    super.key,
    required this.text,
    this.fontSize = 18,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      textAlign: textAlign,
    );
  }
}
