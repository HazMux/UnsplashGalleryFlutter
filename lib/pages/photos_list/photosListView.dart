import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unsplash_gallery/constants.dart' as constants;
import 'package:unsplash_gallery/pages/uresImage.dart';


class PhotosListView extends StatefulWidget {
  final String _res;
  final bool _imageCaching;

  PhotosListView(this._res, this._imageCaching);

  @override
  _PhotosListViewState createState() => _PhotosListViewState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return '[PhotoListView: (_res:$_res)]';
  }
}

class _PhotosListViewState extends State<PhotosListView> {
  final _perPage = 10;

  int _page = 0;
  bool _loading = false;

  Map<String, String> _query;
  List<UResImage> _imageList = new List<UResImage>();
  Future<List<UResImage>> futureImageList;

  @override
  void initState() {
    super.initState();
    if(widget._res == constants.res_photos){
      this._query = {
        'page' : '0',
        'per_page' : '10'
      };
    } else if (widget._res == constants.res_photos_random){
      this._query = {
        'count' : '10'
      };
    }
    _queryNextList();
    futureImageList = fetchUImageList(query: _query);
    futureImageList.catchError( onFetchError );
    futureImageList.then((loadedUImageList) {
      setState(() {
        this._imageList.addAll(loadedUImageList);
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_imageList.length == 0) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      child: _buildGridView(),
    );
  }

  Future<List<UResImage>> fetchUImageList({Map<String, String> query}) async {
    _loading = true;
    print("fetchUImageList call ($query)");

    List<UResImage> _uimageList = new List<UResImage>();

    query['client_id'] = query['client_id'] ?? constants.client_id;

    var uri = Uri.https( constants.unsplash_api_url, '/${widget._res}', query);
    print('uri: $uri');

    final response= await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader:
        'application/json',
        //HttpHeaders.authorizationHeader: 'Token $token', todo: try it
      });

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse.isNotEmpty)
        for (var image in jsonResponse) {
          final UResImage uResImage = UResImage.fromJson(image);
          _uimageList.add(uResImage);
          //print('lo: ${uResImage}');
        }
      print('fetchUImageList call ($query) returns _uimageList[${_uimageList.length}]');
      return _uimageList;
    } else {
      throw Exception('Failed to load Image List:\nURI:${uri.toString()}'); // If the server did not return a 200 OK response, then throw an exception.
    }
  }
  GridView _buildGridView() {
    return GridView.builder(
        itemCount: _imageList.length,
        itemBuilder: (BuildContext context, int i) {
          if (i > _imageList.length - _perPage && !_loading) {
            _queryNextList();
            futureImageList = fetchUImageList(query: _query);
            futureImageList.catchError( onFetchError );
            futureImageList.then((loadedUImageList) {
              print('Loaded $_perPage +images');
              setState(() {
                this._imageList.addAll(loadedUImageList);
                _loading = false;
              });
            });
          }
          if (i < _imageList.length)
            return UImageThumbView(_imageList[i], widget._imageCaching,);
          else
            return Center(child: CircularProgressIndicator());
        },
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2));
  }

  void _queryNextList() {
    if(widget._res == constants.res_photos){
      _query['page'] = _page.toString();
      _page++;
    }
  }

  void onFetchError(error) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text("Can\'t fetch image list, please check internet connection"),
    ));
    Timer(Duration(seconds: 4), (){
      futureImageList = fetchUImageList(query: _query);
      futureImageList.catchError( onFetchError );futureImageList.then((loadedUImageList) {
        setState(() {
          this._imageList.addAll(loadedUImageList);
          _loading = false;
        });
      });
    });

  }
}
