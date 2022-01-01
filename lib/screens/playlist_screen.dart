import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/open_assetaudio.dart';
import 'package:music_app/screens/playing_song.dart';
import 'package:music_app/widgets/playlist_bottomsheet.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../database/boxes.dart';
import '../database/data_model.dart';

// ignore: must_be_immutable
class PlaylistScreen extends StatefulWidget {
  String playlistName;

  PlaylistScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<dynamic>? dbSongs = [];

  List<dynamic>? playlistSongs = [];
  List<Audio> playPlaylist = [];

  final box = Boxes.getSongsDb();

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() {
    dbSongs = box.get("musics") as List<DataModel>;
    playlistSongs = box.get(widget.playlistName);
  }

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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 12),
            child: Text(
              widget.playlistName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return buildSheet(
                        playlistName: widget.playlistName,
                      );
                    });
              },
              child: const Text(
                'ADD SONG',
                style: TextStyle(fontSize: 15.5),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.pink[800],
                  fixedSize: const Size(195, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Boxes.getSongsDb().listenable(),
                builder: (context, Box boxes, _) {
                  List<dynamic> playlistSongs = boxes.get(widget.playlistName);
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: playlistSongs.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        for (var element in playlistSongs) {
                            playPlaylist.add(
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
                        OpenAssetAudio(allSongs: playPlaylist, index: index)
                            .open();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlayingScreen(
                                      songs: playPlaylist,
                                    )));
                      },
                      child: ListTile(
                        leading: SizedBox(
                          height: 50,
                          width: 50,
                          child: QueryArtworkWidget(
                            id: playlistSongs[index].id,
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(15),
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              height: 50,
                              width: 50,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/default.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          playlistSongs[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          playlistSongs[index].artist,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
