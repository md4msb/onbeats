import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OpenAssetAudio {
  List<Audio> allSongs;
  int index;
  bool? notify;

  Future<bool?>setNotifyValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notify = await prefs.getBool("switchState");

    return notify;
  }

  OpenAssetAudio({required this.allSongs, required this.index});

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  open() async{
    notify = await setNotifyValue();
    audioPlayer.open(
      Playlist(audios: allSongs, startIndex: index),
      showNotification: notify == null || notify == true ? true : false,      
      autoStart: true,
    );
  }
}
