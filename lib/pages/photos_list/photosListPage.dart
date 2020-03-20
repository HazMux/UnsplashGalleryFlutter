import 'package:flutter/material.dart';
import 'package:unsplash_gallery/constants.dart' as constants;
import 'package:unsplash_gallery/pages/photos_list/photosListView.dart';
import 'package:unsplash_gallery/theme/theme_selector.dart';

class PhotosListPage extends StatefulWidget {
  final int initIndex;

  PhotosListPage({Key key, this.initIndex = 1});

  @override
  PhotosListPageState createState() => PhotosListPageState(initIndex);
}

class PhotosListPageState extends State<PhotosListPage> {
  bool _cachingImages = false;
  int _selectedIndex;
  String _appBarTitle;
  Widget _child;

  PhotosListPageState(initIndex) {
    _onItemTapped(initIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.photo_camera),
        title: Text(_appBarTitle),
        actions: <Widget>[ThemeSelector()],
        //actions: <Widget>[ IconButton(icon: Icon(Icons.settings), onPressed: _openSettings)],
      ),
      body: _child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
        currentIndex: _selectedIndex ?? widget.initIndex,
        onTap: (i) {
          setState(() {
            _onItemTapped(i);
          });
        },
      ),
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      if (index == 0) {
        _cachingImages = false;
        _appBarTitle = 'Random photos';
        _child = Container( child: PhotosListView(constants.res_photos_random, _cachingImages) );

      } else if (index == 1) {
        _cachingImages = true;
        _appBarTitle = 'Dashboard';
        _child = PhotosListView(constants.res_photos, _cachingImages);
      }
    }
  }

  final _bottomNavigationBarItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.casino),
      title: Title(
          title: 'Randrom',
          child: Text('Randrom'),
          color: ThemeData().primaryTextTheme.title.color),
      activeIcon: Icon(Icons.casino),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      title: Title(
          title: 'New',
          child: Text('New'),
          color: ThemeData().primaryTextTheme.title.color),
      activeIcon: Icon(Icons.dashboard),
    )
  ];
}
