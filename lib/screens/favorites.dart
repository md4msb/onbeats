import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/screens/playing_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../open_assetaudio.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Audio> playLiked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 12),
            child: Text(
              "Liked Songs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ValueListenableBuilder(
                  valueListenable: Boxes.getSongsDb().listenable(),
                  builder: (context, Box boxes, _) {
                    List<dynamic> likedSongs = boxes.get("favorites");
                    return ListView.builder(
                        itemCount: likedSongs.length,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                for (var element in likedSongs) {
                                  playLiked.add(
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
                                OpenAssetAudio(
                                        allSongs: playLiked, index: index)
                                    .open();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlayingScreen(
                                              songs: playLiked,
                                            )));
                              },
                              child: ListTile(
                                leading: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: QueryArtworkWidget(
                                    id: likedSongs[index].id,
                                    type: ArtworkType.AUDIO,
                                    artworkBorder: BorderRadius.circular(15),
                                    artworkFit: BoxFit.cover,
                                    nullArtworkWidget: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/default.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  likedSongs[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  likedSongs[index].artist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ));
                  }))
        ],
      ),
    );
  }

  Padding likedSongList(
      {required title,
      leadIcon = Icons.music_note_rounded,
      double leadSize = 28,
      leadClr = Colors.pink}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/searchpre.jpg"),
                fit: BoxFit.cover),
            color: leadClr,
            borderRadius: const BorderRadius.all(Radius.circular(17)),
          ),
          child: Center(
              child: Icon(
            leadIcon,
            color: Colors.white,
            size: leadSize,
          )),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(
          Icons.play_arrow_rounded,
          size: 30,
        ),
      ),
    );
  }
}
