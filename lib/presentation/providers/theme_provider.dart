import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  Color _primaryColor = Colors.deepPurple;
  Color _complementaryColor = Colors.yellow;

  bool get isDarkMode => _isDarkMode;
  Color get primaryColor => _primaryColor;
  Color get complementaryColor => _complementaryColor;
  Brightness get brightness {
    return _isDarkMode ? Brightness.dark : Brightness.light;
  }

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    _isDarkMode = prefs.getBool('isDarkMode') ?? false;

    final colorHex = prefs.getString('primaryColor');
    if (colorHex != null) {
      _primaryColor = _hexToColor(colorHex);
    }

    final colorHexComp = prefs.getString('complementaryColor');
    if (colorHexComp != null) {
      _complementaryColor = _hexToColor(colorHexComp);
    }

    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
    notifyListeners();
  }

  Future<void> updatePrimaryColor(Color newColor) async {
    _primaryColor = newColor;
    Color compColor = _getComplementaryColor(newColor);
    _complementaryColor = compColor;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('primaryColor', _colorToHex(newColor));
    await prefs.setString('complementaryColor', _colorToHex(compColor));
    notifyListeners();
  }

  String _colorToHex(Color color) {
    return color.toARGB32().toRadixString(16).padLeft(8, '0');
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('0x$hex'));
  }

  Color _getComplementaryColor(Color color) {
    int alpha = (color.a * 255).round();
    int red = (color.r * 255).round();
    int green = (color.g * 255).round();
    int blue = (color.b * 255).round();

    return Color.fromARGB(alpha, 255 - red, 255 - green, 255 - blue);
  }
}
