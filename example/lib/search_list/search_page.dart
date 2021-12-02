import 'package:eblox/blox.dart';
import 'package:example/search_list/blox/search_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'model/song_list_model.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Song search'),),
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  suffix: IconButton(
                icon: const Icon(Icons.search_rounded),
                onPressed: (){
                  if(_controller.text.isNotEmpty) {
                    SearchAction(_controller.text).to<SearchVModel>();
                  }
                },
              )),
            ),
            Flexible(
                child: BloxView<SearchVModel, SongListState<SongListModel>>(
              create: () => SearchVModel(),
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onEmpty: ()=> const Center(child: Text("Empty")),
              builder: (state) {
                return ListView.builder(
                    itemCount: state.data.songs.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        alignment: Alignment.center,
                        height: 40,
                        child: Text(state.data.songs[i],style: const TextStyle(color: Colors.blueGrey,fontSize: 20),),
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }
}
