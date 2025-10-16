
import 'package:flutter/material.dart';

void showSnack(String message, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

const Color cerise = Color(0xFFDE3163);
const Color primary = Color(0xFFDD1A1C);
const Color secondary = Color(0xFFFFDF42);
const Color tertiary = Color(0xFF4AB2FF);
const Color surface = Color(0xFFF6F6F7);
const Color text = Color(0xFF040411);