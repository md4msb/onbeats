import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicProvider with ChangeNotifier {
  final box = Boxes.getSongsDb();

  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  final OnAudioQuery audioQuery = OnAudioQuery();

  List<DataModel> dbSongs = [];
  List<Audio> audioList = [];

  Audio findCurrentSong(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  update() {
    notifyListeners();
  }

  int screenIndex = 0;
  changeScreen(index) {
    screenIndex = index;
    notifyListeners();
  }

  bool createNewPlaylist(playlists, playlistName) {
    List<dynamic>? playlistSongs = [];
    List? excistingName = [];
    if (playlists.isNotEmpty) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' && excistingName!.isEmpty) {
      box.put(playlistName, playlistSongs);
      notifyListeners();
      return true;
      // Navigator.of(context).pop();
      // setState(() {});
    } else {
      return false;
      // ScaffoldMessenger.of(context).showSnackBar(SnackBars().excistingPlaylist);
    }
  }
}
