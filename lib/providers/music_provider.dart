import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicProvider with ChangeNotifier {
  final box = Boxes.getSongsDb();

  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  final OnAudioQuery audioQuery = OnAudioQuery();

  List<SongModel> fetchedSongs = [];
  List<DataModel> mappedSongs = [];
  List<DataModel> dbSongs = [];
  List<Audio> audioList = [];

  fetchSongs() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    fetchedSongs = await audioQuery.querySongs();
    mappedSongs = fetchedSongs
        .map((e) => DataModel(
              title: e.title,
              id: e.id,
              path: e.uri!,
              duration: e.duration,
              artist: e.artist,
            ))
        .toList();

    await box.put("musics", mappedSongs);

    dbSongs = box.get("musics") as List<DataModel>;

    converToAudioList();

    // notifyListeners();
  }

  converToAudioList() {
    for (var element in dbSongs) {
        audioList.add(
          Audio.file(
            element.path,
            metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist,
            ),
          ),
        );
      }
  }

  refresh () {
    notifyListeners();
  }

}
