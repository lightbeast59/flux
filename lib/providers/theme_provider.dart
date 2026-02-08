import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  // Default values
  static const Color _defaultPrimaryColor = Color(0xFF6366F1);
  static const Color _defaultBackgroundColor = Color(0xFFFAFAFA);
  static const double _defaultTextScale = 1.0;
  static const bool _defaultDarkMode = false;

  // Available theme colors
  static const List<ThemeColorOption> availableColors = [
    ThemeColorOption('Indigo', Color(0xFF6366F1)),
    ThemeColorOption('Blue', Color(0xFF3B82F6)),
    ThemeColorOption('Purple', Color(0xFF8B5CF6)),
    ThemeColorOption('Pink', Color(0xFFEC4899)),
    ThemeColorOption('Red', Color(0xFFEF4444)),
    ThemeColorOption('Orange', Color(0xFFF97316)),
    ThemeColorOption('Green', Color(0xFF10B981)),
    ThemeColorOption('Teal', Color(0xFF14B8A6)),
  ];

  // Available background colors
  static const List<ThemeColorOption> availableBackgroundColors = [
    ThemeColorOption('Default', Color(0xFFFAFAFA)),
    ThemeColorOption('Warm White', Color(0xFFFFFBF5)),
    ThemeColorOption('Cool Gray', Color(0xFFF1F5F9)),
    ThemeColorOption('Soft Blue', Color(0xFFF0F9FF)),
    ThemeColorOption('Mint', Color(0xFFF0FDF4)),
    ThemeColorOption('Lavender', Color(0xFFFAF5FF)),
  ];

  // Available text sizes
  static const List<TextSizeOption> availableTextSizes = [
    TextSizeOption('Small', 0.85),
    TextSizeOption('Medium', 1.0),
    TextSizeOption('Large', 1.15),
    TextSizeOption('Extra Large', 1.3),
  ];

  Color _primaryColor = _defaultPrimaryColor;
  Color _backgroundColor = _defaultBackgroundColor;
  double _textScaleFactor = _defaultTextScale;
  bool _isDarkMode = _defaultDarkMode;
  bool _isInitialized = false;
  String? _currentUserId;

  Color get primaryColor => _primaryColor;
  Color get backgroundColor => _backgroundColor;
  double get textScaleFactor => _textScaleFactor;
  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  // Keys with user prefix
  String _darkModeKey(String? userId) => userId != null ? '${userId}_darkMode' : 'darkMode';
  String _primaryColorKey(String? userId) => userId != null ? '${userId}_primaryColor' : 'primaryColor';
  String _backgroundColorKey(String? userId) => userId != null ? '${userId}_backgroundColor' : 'backgroundColor';
  String _textScaleKey(String? userId) => userId != null ? '${userId}_textScale' : 'textScale';

  ThemeProvider() {
    _initializeDefaults();
  }

  void _initializeDefaults() {
    _primaryColor = _defaultPrimaryColor;
    _backgroundColor = _defaultBackgroundColor;
    _textScaleFactor = _defaultTextScale;
    _isDarkMode = _defaultDarkMode;
    _isInitialized = true;
    notifyListeners();
  }

  // Load preferences for a specific user (call on login)
  Future<void> loadUserPreferences(String userId) async {
    _currentUserId = userId;
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool(_darkModeKey(userId)) ?? _defaultDarkMode;
    _primaryColor = Color(prefs.getInt(_primaryColorKey(userId)) ?? _defaultPrimaryColor.value);
    _backgroundColor = Color(prefs.getInt(_backgroundColorKey(userId)) ?? _defaultBackgroundColor.value);
    _textScaleFactor = prefs.getDouble(_textScaleKey(userId)) ?? _defaultTextScale;

    notifyListeners();
  }

  // Reset to defaults (call on logout)
  void resetToDefaults() {
    _currentUserId = null;
    _primaryColor = _defaultPrimaryColor;
    _backgroundColor = _defaultBackgroundColor;
    _textScaleFactor = _defaultTextScale;
    _isDarkMode = _defaultDarkMode;
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    notifyListeners();
    if (_currentUserId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_primaryColorKey(_currentUserId), color.value);
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    if (_currentUserId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey(_currentUserId), _isDarkMode);
    }
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();
    if (_currentUserId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey(_currentUserId), value);
    }
  }

  Future<void> setBackgroundColor(Color color) async {
    _backgroundColor = color;
    notifyListeners();
    if (_currentUserId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_backgroundColorKey(_currentUserId), color.value);
    }
  }

  Future<void> setTextScaleFactor(double scale) async {
    _textScaleFactor = scale;
    notifyListeners();
    if (_currentUserId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_textScaleKey(_currentUserId), scale);
    }
  }

  ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: _primaryColor,
        unselectedItemColor: const Color(0xFF6B7280),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF334155)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF1E293B),
        selectedItemColor: _primaryColor,
        unselectedItemColor: const Color(0xFFCBD5E1),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class ThemeColorOption {
  final String name;
  final Color color;

  const ThemeColorOption(this.name, this.color);
}

class TextSizeOption {
  final String name;
  final double scale;

  const TextSizeOption(this.name, this.scale);
}
