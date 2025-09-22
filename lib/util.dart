
import 'package:flutter/material.dart';

void showSnack(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

const Color cerise = Color(0xFFDE3163);