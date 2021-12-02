import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/song_list_model.dart';

class SearchService {
  static Future<SongListModel> search(String name) async {
    var json = await rootBundle.loadString('assets/data.json');
    Map map = jsonDecode(json);
    List songs = map['music'];
    var listView = UnmodifiableListView<String>(songs
        .cast<String>()
        .where((e) => e.toLowerCase().contains(name.toLowerCase())));
    return SongListModel(songs: listView);
  }
}
