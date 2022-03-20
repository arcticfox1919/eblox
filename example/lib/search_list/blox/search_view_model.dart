

// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'package:eblox/eblox.dart';
import 'package:eblox_annotation/eblox_annotation.dart';
import 'package:example/search_list/model/song_list_model.dart';
import 'package:example/search_list/service/search_service.dart';
import 'package:flutter/cupertino.dart';

part 'search_view_model.g.dart';

@blox
class SearchVModel with Blox{
  SearchVModel._();
  factory SearchVModel() = _SearchVModel;


  @AsyncX(name: 'SongListState')
  SongListModel _songModel = SongListModel();

  @asyncBind
  @ActionX(bind: 'SongListState')
  BloxAsyncTask<SongListModel> _search(String name){
    return (){
      return  SearchService.search(name);
    };
  }
}