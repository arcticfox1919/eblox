

import 'dart:collection';

import 'package:eblox/blox.dart';

class SongListModel with BloxData{

  SongListModel({UnmodifiableListView<String>? songs}){
    if(songs !=null) this.songs = songs;
  }

  UnmodifiableListView<String> songs = UnmodifiableListView([]);

  @override
  bool get isEmpty => songs.isEmpty;
}