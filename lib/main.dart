import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retune/screens/home_screen.dart';
import 'package:retune/services/audio_handler_service.dart';
import 'package:retune/services/hive_service.dart';
import 'package:retune/util.dart';

AudioPlayerHandler? audioHandler;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.retune.audio',
      androidNotificationChannelName: 'retune',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );
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
