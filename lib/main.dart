import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retune/screens/home_screen.dart';
import 'package:retune/services/hive_service.dart';
import 'package:retune/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  await HiveService.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: primary,
            onPrimary: text,
            secondary: secondary,
            onSecondary: text,
            error: surface,
            onError: text,
            surface: surface,
            onSurface: text,
          ),
          fontFamily: GoogleFonts.interTight().fontFamily,
        ),
        home: const Scaffold(body: HomeScreen()),
      ),
    );
  }
}
