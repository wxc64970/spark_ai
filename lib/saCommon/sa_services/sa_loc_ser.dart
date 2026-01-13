import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SALocaleService extends GetxService {
  static const String _localeKey = 'app_locale';

  final _locale = const Locale('en').obs;

  Locale get locale => _locale.value;

  bool get isArabic => _locale.value.languageCode == 'ar';

  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('ar'), // Arabic
    Locale('fr'), // French
    Locale('de'), // German
    Locale('es'), // Spanish
    Locale('pt'), // Portuguese
    Locale('ja'), // Japanese
    Locale('ko'), // Korean
  ];

  // Language display names
  static const Map<String, String> languageNames = {'en': 'English', 'ar': 'العربية', 'fr': 'Français', 'de': 'Deutsch', 'es': 'Español', 'pt': 'Português', 'ja': '日本語', 'ko': '한국어'};

  /// 公开的初始化方法，供外部调用
  /// Initialize and load locale
  /// Priority: 1. Saved locale, 2. System locale, 3. English (fallback)
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey);

    if (savedLocale != null) {
      // Use saved locale if exists
      _locale.value = Locale(savedLocale);
    } else {
      // Get system locale and check if it's supported
      _locale.value = _getSystemLocale();
    }
  }

  /// Get system locale, fallback to English if not supported
  Locale _getSystemLocale() {
    // Get device locale
    final systemLocale = ui.PlatformDispatcher.instance.locale;

    // Check if system language is supported
    final isSupported = supportedLocales.any((locale) => locale.languageCode == systemLocale.languageCode);

    if (isSupported) {
      return Locale(systemLocale.languageCode);
    } else {
      // Fallback to English
      return const Locale('en');
    }
  }

  /// Change app locale
  Future<void> changeLocale(Locale newLocale) async {
    if (_locale.value == newLocale) return;

    _locale.value = newLocale;
    await Get.updateLocale(newLocale);
    await _saveLocale(newLocale);
  }

  /// Save locale to SharedPreferences
  Future<void> _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Get language display name
  String getLanguageName(Locale locale) {
    return languageNames[locale.languageCode] ?? locale.languageCode;
  }
}
