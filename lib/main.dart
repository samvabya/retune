import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retune/screens/home_screen.dart';
import 'package:retune/util.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cerise,
          brightness: Brightness.light,
          dynamicSchemeVariant: DynamicSchemeVariant.expressive,
        ),
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: cerise,
          brightness: Brightness.dark,
          dynamicSchemeVariant: DynamicSchemeVariant.expressive,
        ),
        fontFamily: GoogleFonts.montserrat().fontFamily,
      ),
      themeMode: ThemeMode.system,
      home: const Scaffold(body: HomeScreen()),
    );
  }
}
