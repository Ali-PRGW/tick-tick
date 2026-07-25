import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeProvider extends ChangeNotifier {
  Brightness _brightness;
  
  ThemeProvider(this._brightness) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateSystemUI();
    });
  }

  Brightness get brightness => _brightness;

  void toggleTheme() {
    _brightness = (_brightness == Brightness.dark)
        ? Brightness.light
        : Brightness.dark;

    notifyListeners();
    _updateSystemUI();
  }

  void updateTheme(Brightness brightness) {
    if (_brightness != brightness) {
      _brightness = brightness;
      notifyListeners();
      _updateSystemUI();
    }
  }

  void _updateSystemUI() {
    final bool isDark = _brightness == Brightness.dark;

    final Color statusBarColor = isDark
        ? const Color(0xFF1E1E1E)
        : const Color(0xFFD0BCFF);
        
    final Color navBarColor = isDark
        ? const Color(0xFF121212)
        : const Color(0xFFF7F2FA);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        // ✅ تنظیمات ثابت برای Status Bar
        statusBarColor: Colors.transparent, // شفاف
        statusBarIconBrightness: Brightness.light, // آیکون سفید
        statusBarBrightness: Brightness.dark, // متن سفید
        
        // تنظیمات Navigation Bar
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
      ),
    );
  }
}