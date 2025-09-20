import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  bool _isFirstTime = true;
  bool _isLoading = false;
  String? _error;

  bool get isFirstTime => _isFirstTime;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      // التحقق من حالة التطبيق
      final isFirstTime = await StorageService.instance.getBool('is_first_time') ?? true;
      _isFirstTime = isFirstTime;

      // تهيئة الخدمات الأخرى
      await Future.delayed(const Duration(seconds: 1)); // محاكاة التحميل

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    await StorageService.instance.setBool('is_first_time', false);
    _isFirstTime = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}