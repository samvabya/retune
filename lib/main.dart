import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:retune/providers/player_provider.dart';
import 'package:retune/providers/search_provider.dart';
import 'package:retune/providers/song_provider.dart';
import 'package:retune/screens/home_screen.dart';
import 'package:retune/services/hive_service.dart';
import 'package:retune/util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchProvider()),
        ChangeNotifierProvider(create: (context) => PlayerProvider()),
        ChangeNotifierProvider(create: (context) => SongProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
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
