

// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:eblox/blox.dart';
import 'package:eblox_annotation/blox.dart';
import 'package:example/search_list/model/song_list_model.dart';
import 'package:example/search_list/service/search_service.dart';
import 'package:flutter/cupertino.dart';

part 'search_view_model.g.dart';

@bloX
class _SearchVModel extends Blox{

  @AsyncX(name: 'SongListState')
  SongListModel _songModel = SongListModel();

  @ActionX(bind: 'SongListState',bindAsync: true)
  Future<SongListModel> _search(String name){
    return SearchService.search(name);
  }
}