import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:unsplash_gallery/pages/photos_list/photosListPage.dart';
import 'package:unsplash_gallery/theme/theme.dart';


void main() => runApp(UGalleryApp());

class UGalleryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
    return ChangeNotifierProvider<ThemeChanger>(
        create: (_) => ThemeChanger(),
        child: MaterialAppWithTheme(
          title: 'Dashboard',
          home: PhotosListPage(),
        ));
  }
}
