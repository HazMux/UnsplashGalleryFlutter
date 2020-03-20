import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialAppWithTheme extends StatelessWidget {
  final String title;
  final Widget home;

  MaterialAppWithTheme({Key key, @required this.title, this.home});

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      title: this.title,
      home: this.home,
      theme: _theme.getLightThemeData(),
      darkTheme: _theme.getDarkThemeData(),
      themeMode: _theme.getThemeMode(),
    );
  }
}

class ThemeChanger with ChangeNotifier {
  final _themeModePreferenceKey = 'theme_mode';
  final primaryColor = Colors.deepPurple;
  final accentColor = Colors.deepPurpleAccent;

  ThemeMode _currentThemeMode = ThemeMode.system;
  ThemeData _lightThemeData;
  ThemeData _darkThemeData;

  // final primaryColor = Colors.black;
  // final accentColor = Colors.black;

  ThemeChanger({ThemeData lightTheme, ThemeData darkTheme}){
    loadThemeModePreference();
    _lightThemeData = lightTheme ?? ThemeData();
    _darkThemeData = darkTheme ?? ThemeData.dark();

    if (lightTheme == null){
      _lightThemeData  = _lightThemeData.copyWith(
        accentColor: accentColor,
        primaryColor: primaryColor,
        buttonTheme: _lightThemeData.buttonTheme.copyWith(
          buttonColor: primaryColor,
          textTheme: ButtonTextTheme.primary
        ),
      );
    }
    if (darkTheme == null){
      _darkThemeData  = _darkThemeData.copyWith(
        accentColor: accentColor,
        buttonTheme: _darkThemeData.buttonTheme.copyWith(
          buttonColor: _darkThemeData.primaryColor,
          textTheme: ButtonTextTheme.primary
        ),
      );
    }
  }

  ThemeData getLightThemeData() => _lightThemeData;
  getDarkThemeData()  => _darkThemeData;
  getThemeMode()      => _currentThemeMode;

  setThemeMode(ThemeMode mode){
    if(_currentThemeMode != mode){
      _currentThemeMode = mode;
      notifyListeners();
      saveThemeModePreference();
    }
  }

  loadThemeModePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int prefInt = prefs.getInt(_themeModePreferenceKey);
    print('loaded: ' + prefInt.toString());
    ThemeMode mode = ThemeMode.values[ prefInt ?? ThemeMode.system.index ];
    setThemeMode(mode);
  }

  saveThemeModePreference() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModePreferenceKey, _currentThemeMode.index);
    print('Saved: $_currentThemeMode as ${_currentThemeMode.index} theme.');
  }

  ThemeData getCurrent(context) {
    if (context == null)
      throw NullThrownError();
    Brightness brightness = Theme
        .of(context)
        .brightness;
    print('Brightness: $brightness');
    switch (brightness) {
      case Brightness.light:
        return _lightThemeData;
      case Brightness.dark:
        return _darkThemeData;
      default:
        switch (_currentThemeMode ){
          case ThemeMode.light:
            return _lightThemeData;
          case ThemeMode.dark:
            return _darkThemeData;
          default:
            return _lightThemeData;
        }
    }
  }
}