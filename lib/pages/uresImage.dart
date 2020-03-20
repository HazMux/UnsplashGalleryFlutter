import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_gallery/pages/photoDetailViewPage.dart';

class UResImage {
  final id;
  final updatedAt;
  final width;
  final height;
  final description;
  final username;
  final name;
  final urlThumb;
  final urlRaw;
  final urlRegular;

  UResImage(
       {this.id,
        this.updatedAt,
        this.width,
        this.height,
        this.description,
        this.username,
        this.name,
        this.urlThumb,
        this.urlRegular,
        this.urlRaw});

  @override
  String toString() {
    return '$id, $updatedAt, $width, $height, \'$description\', $username';
  }

  factory UResImage.fromJson(Map<String, dynamic> json) {
    return UResImage(
        id: json['id'],
        updatedAt: json['updated_at'],
        width: json['width'],
        height: json['height'],
        description: json['description'] ?? json['alt_description'],
        username: json['user']['username'],
        name: json['user']['username'],
        urlThumb: json['urls']['small'],
        urlRaw: json['urls']['raw'],
        urlRegular: json['urls']['regular']);
  }
}

class UImageThumbView extends StatelessWidget {
  final UResImage _uImage;
  final bool _caching;

  UImageThumbView(this._uImage, this._caching);

  @override
  Widget build(BuildContext context) {
    Widget _image;
    if(_caching)
      _image = CachedNetworkImage(
        imageUrl: _uImage.urlThumb,
        fit: BoxFit.cover,
      );
    else{
      _image = Container(
        decoration: new BoxDecoration(
            image: new DecorationImage(
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter,
                image: new NetworkImage( _uImage.urlThumb))),
      );
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[ Center( child: CircularProgressIndicator(), ) ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          AspectRatio(
            aspectRatio: 100 / 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: _image,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Card(
                margin: EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(4),
                  child: Text(
                    _uImage.name ?? _uImage.username ?? 'Unknown',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.all(0),
            child: FlatButton(
              child: null,
              onPressed: () {
                print('tap: $_uImage');
                Navigator.push(context, new MaterialPageRoute(builder: (context) => PhotoDetailViewPage(_uImage)));
              },
            ),
          )
        ],
      ),
    );
  }
}