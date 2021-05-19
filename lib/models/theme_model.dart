import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModel with ChangeNotifier {
  ThemeData theme;

  ThemeModel({@required ThemeData theme}) {
    backgroundColor = theme.backgroundColor;

    if (theme.brightness == Brightness.dark) {
      secondBackgroundColor = Color(0xFF4E5D6A);
      textColor = Colors.white;
      secondTextColor = Color(0xFFA6BCD0);
    } else {
      secondBackgroundColor = Colors.white;
      textColor = Colors.black;
      secondTextColor = Color(0xFF696969);
    }

    this.theme = theme;
  }

  ///Save theme name in local storage with shared prefs
  Future<void> setToStorage(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  Color secondBackgroundColor;
  Color backgroundColor;
  Color textColor;
  Color secondTextColor;

  final Color shadowColor = Colors.black.withOpacity(0.07);
  final Color priceColor = Color(0xFFFFA700);

  final Color accentColor = Color(0xFF7BED8D);

  ///Update theme to dark or light
  Future<void> updateTheme() async {
    bool isDark = theme.brightness == Brightness.dark;
    if (isDark) {
      theme = light;
    } else {
      theme = dark;
    }

    backgroundColor = theme.backgroundColor;

    if (theme.brightness == Brightness.dark) {
      secondBackgroundColor = Color(0xFF4E5D6A);
      textColor = Colors.white;
      secondTextColor = Color(0xFFA6BCD0);
    } else {
      secondBackgroundColor = Colors.white;
      textColor = Colors.black;
      secondTextColor = Color(0xFF696969);
    }

    await setToStorage(!isDark);
    notifyListeners();
  }

  static MaterialColor _primarySwatch(int color) {
    return MaterialColor(color, {
      50: Color.fromRGBO(255, 92, 87, .1),
      100: Color.fromRGBO(255, 92, 87, .2),
      200: Color.fromRGBO(255, 92, 87, .3),
      300: Color.fromRGBO(255, 92, 87, .4),
      400: Color.fromRGBO(255, 92, 87, .5),
      500: Color.fromRGBO(255, 92, 87, .6),
      600: Color.fromRGBO(255, 92, 87, .7),
      700: Color.fromRGBO(255, 92, 87, .8),
      800: Color.fromRGBO(255, 92, 87, .9),
      900: Color.fromRGBO(255, 92, 87, 1),
    });
  }

  static MaterialColor lightSwatch = _primarySwatch(0xFF7BED8D);

  ///Light theme
  static final light = ThemeData(
      brightness: Brightness.light,
      primarySwatch: lightSwatch,
      primaryColor: lightSwatch,
      primaryColorDark: lightSwatch,
      accentColor: Color(0xFF7BED8D),
      toggleableActiveColor: Color(0xFF7BED8D),
      backgroundColor: Color(0xFFf4f4f4),
      scaffoldBackgroundColor: Color(0xFFf4f4f4),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      bottomNavigationBarTheme:
          BottomNavigationBarThemeData(backgroundColor: Color(0xFFf4f4f4)),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Color(0xFF7BED8D),
      ));

  ///Dark theme
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: lightSwatch,
    primaryColor: lightSwatch,
    primaryColorDark: lightSwatch,
    accentColor: Color(0xFF7BED8D),
    toggleableActiveColor: Color(0xFF7BED8D),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xFF7BED8D),
    ),
    backgroundColor: Color(0xFF404E5A),
    scaffoldBackgroundColor: Color(0xFF404E5A),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF404E5A), elevation: 0),
  );
}
