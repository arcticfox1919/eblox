// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// BloxActionGenerator
// **************************************************************************

class SearchAction extends BloxAction {
  SearchAction(String name) : super.argsByPosition([name]);
}

// **************************************************************************
// BloXGenerator
// **************************************************************************

class SearchVModel extends _SearchVModel {
  SearchVModel() {
    registerAction({SearchAction: _search});
    registerState({SongListState: songModel});
  }

  final SongListState<SongListModel> __songModel =
      SongListState<SongListModel>(SongListModel());
  SongListState<SongListModel> get songModel =>
      __songModel.copy(data: _songModel);

  @override
  Future<SongListModel> _search(String name) {
    runZoned(() => Future(() => super._search(name)),
        zoneSpecification: ZoneSpecification(run: <R>(self, parent, zone, f) {
          __songModel.status = BloxStatus.loading;
          emit(__songModel.copy());
          var r = f();
          (r as Future).then((result) {
            _songModel = result;
            __songModel.data = result;
            __songModel.status =
                __songModel.isEmpty() ? BloxStatus.none : BloxStatus.ok;
            emit(songModel);
          });
          return r;
        }, handleUncaughtError: (self, parent, zone, error, stackTrace) {
          __songModel.status = BloxStatus.error;
          debugPrint(error.toString());
          emit(__songModel.copy(errorMessage: error));
        }));
    return Future.value(_songModel);
  }
}

// **************************************************************************
// BloxStateGenerator
// **************************************************************************

class SongListState<T> extends BloxAsyncState<T> {
  SongListState(data) : super(data);

  @override
  SongListState<T> copy({T? data, BloxStatus? status, errorMessage}) {
    var d = data ?? this.data;
    status ??= this.status;
    errorMessage ??= this.errorMessage;

    return SongListState<T>(d)
      ..status = status
      ..errorMessage = errorMessage;
  }
}
