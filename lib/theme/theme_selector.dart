import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_gallery/theme/theme.dart';

class ThemeSelector extends StatefulWidget{
  @override
  _ThemeSelectorState createState() => _ThemeSelectorState();
}

class _ThemeSelectorState extends State<ThemeSelector> {
  String _selected;

  @override
  Widget build(BuildContext context) {
    final _theme = Provider.of<ThemeChanger>(context);
    _selected = getThemeModeString(_theme.getThemeMode());

    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: PopupMenuButton<ThemeMode>(
          onSelected: (ThemeMode mode) {
            setState(() {
              _theme.setThemeMode(mode);
              _selected = getThemeModeString(mode);
            });
          },
          child: Text(_selected),
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
                value: ThemeMode.system,
                child: Text('System')
            ),
            const PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Light')
            ),
            const PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark')
            ),
          ]
      ),
    );
  }

  String getThemeModeString(themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'System';
    }
  }
}