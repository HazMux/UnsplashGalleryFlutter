import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_gallery/pages/uresImage.dart';
import 'package:unsplash_gallery/theme/theme.dart';

class PhotoDetailViewPage extends StatelessWidget{
  final UResImage _uResImage;

  PhotoDetailViewPage(this._uResImage);

  @override
  Widget build(BuildContext context) {
    return MaterialAppWithTheme(
      title: _uResImage.name ?? _uResImage.username,
      home: Scaffold(
        appBar: AppBar(title: Text(_uResImage.name ?? _uResImage.username), actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.pop(context),)
        ],),
        body: ListView(
          padding: EdgeInsets.all(8),
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: _uResImage.urlRegular,
                    placeholder: (context, url) => Container(
                      height: _uResImage.height / _uResImage.width * (MediaQuery.of(context).size.width * 0.95),
                      child: Center( child: CircularProgressIndicator(),),
                    ),
                    errorWidget: (context, url, error) => Wrap(
                      children: <Widget>[
                        Icon(Icons.error),
                        Text('Can\'t load image')
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Container(
                padding: EdgeInsets.all(8),
                child: Wrap(
                  children: <Widget>[
                    Text('Description: '),
                    Text(_uResImage.description)
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}