import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _boxName = 'settings';
  static const String _vibrancyKey = 'vibrancy';

  Box? _settingsBox;
  bool _vibrancy = true;

  static final SettingsProvider _instance = SettingsProvider._internal();
  factory SettingsProvider() => _instance;
  SettingsProvider._internal();

  bool get vibrancy => _vibrancy;

  Future<void> init() async {
    try {
      await Hive.initFlutter();

      _settingsBox = await Hive.openBox(_boxName);

      _loadVibrancy();

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

  @override
  Future<void> dispose() async {
    await _settingsBox?.close();
    super.dispose();
  }
}
