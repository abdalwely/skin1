import 'package:flutter/material.dart';
import '../core/services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('ar', 'SA');
  double _textScale = 1.0;
  bool _notificationsEnabled = true;
  bool _autoBackup = true;
  String _backupFrequency = 'weekly';

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  double get textScale => _textScale;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoBackup => _autoBackup;
  String get backupFrequency => _backupFrequency;

  Future<void> loadSettings() async {
    try {
      final themeMode = await DatabaseService.instance.getSetting('theme_mode');
      if (themeMode != null) {
        _themeMode = _parseThemeMode(themeMode);
      }

      final language = await DatabaseService.instance.getSetting('language');
      if (language != null) {
        _locale = Locale(language, language == 'ar' ? 'SA' : 'US');
      }

      final textScale = await DatabaseService.instance.getSetting('text_scale');
      if (textScale != null) {
        _textScale = double.tryParse(textScale) ?? 1.0;
      }

      final notifications = await DatabaseService.instance.getSetting('notifications_enabled');
      if (notifications != null) {
        _notificationsEnabled = notifications == 'true';
      }

      final backup = await DatabaseService.instance.getSetting('auto_backup');
      if (backup != null) {
        _autoBackup = backup == 'true';
      }

      final frequency = await DatabaseService.instance.getSetting('backup_frequency');
      if (frequency != null) {
        _backupFrequency = frequency;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await DatabaseService.instance.setSetting('theme_mode', mode.toString());
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await DatabaseService.instance.setSetting('language', locale.languageCode);
    notifyListeners();
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale;
    await DatabaseService.instance.setSetting('text_scale', scale.toString());
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    await DatabaseService.instance.setSetting('notifications_enabled', enabled.toString());
    notifyListeners();
  }

  Future<void> setAutoBackup(bool enabled) async {
    _autoBackup = enabled;
    await DatabaseService.instance.setSetting('auto_backup', enabled.toString());
    notifyListeners();
  }

  Future<void> setBackupFrequency(String frequency) async {
    _backupFrequency = frequency;
    await DatabaseService.instance.setSetting('backup_frequency', frequency);
    notifyListeners();
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}