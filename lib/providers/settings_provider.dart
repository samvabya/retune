import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_flutter/hive_flutter.dart';

final settingsProvider = ChangeNotifierProvider<SettingsProvider>((ref) => SettingsProvider());

class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _vibrancyKey = 'vibrancy';
  static const String _autoPlayKey = 'autoPlay';

  Box? _settingsBox;
  bool _vibrancy = true;
  bool _autoPlay = true;

  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  bool get vibrancy => _vibrancy;
  bool get autoPlay => _autoPlay;

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      _settingsBox = await Hive.openBox(_boxName);

      _loadVibrancy();
      _loadAutoPlay();

      debugPrint('SettingsService initialized successfully');
    } catch (e) {
      debugPrint('Error initializing SettingsService: $e');
      _vibrancy = false;
    }
  }

  void _loadVibrancy() {
    try {
      _vibrancy =
          _settingsBox?.get(_vibrancyKey, defaultValue: false) ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading dynamic mode setting: $e');
      _vibrancy = false;
    }
  }

  Future<void> setVibrancy(bool value) async {
    try {
      _vibrancy = value;
      await _settingsBox?.put(_vibrancyKey, value);
      notifyListeners();
      debugPrint('Dynamic mode set to: $value');
    } catch (e) {
      debugPrint('Error saving dynamic mode setting: $e');
    }
  }

  Future<void> toggleVibrancy() async {
    await setVibrancy(!_vibrancy);
  }

  void _loadAutoPlay() {
    try {
      _autoPlay = _settingsBox?.get(_autoPlayKey, defaultValue: true) ?? true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auto play setting: $e');
      _autoPlay = true;
    }
  }

  Future<void> setAutoPlay(bool value) async {
    try {
      _autoPlay = value;
      await _settingsBox?.put(_autoPlayKey, value);
      notifyListeners();
      debugPrint('Auto play set to: $value');
    } catch (e) {
      debugPrint('Error saving auto play setting: $e');
    }
  }

  Future<void> toggleAutoPlay() async {
    await setAutoPlay(!_autoPlay);
  }

  @override
  Future<void> dispose() async {
    await _settingsBox?.close();
    super.dispose();
  }
}
