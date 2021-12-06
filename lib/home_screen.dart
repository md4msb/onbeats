import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/all_songs.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:music_app/library_screen.dart';
import 'package:music_app/playing_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Boxes.getSongsDb();
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
  final OnAudioQuery audioQuery = OnAudioQuery();
  int index = 0;

  List<SongModel> songs = [];
  List<DataModel> mappedSongs = [];
  List<DataModel> dbSongs = [];
  List<Audio> allSongs = [];

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    songs = await audioQuery.querySongs();
    mappedSongs = songs
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

    dbSongs.forEach(
      (element) {
        allSongs.add(
          Audio.file(
            element.path,
            metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist,
            ),
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          screens(index)!,
          Positioned(
            child: assetAudioPlayer.builderCurrent(
                builder: (context, Playing? playing) {
              final myAudio = find(allSongs, playing!.audio.assetAudioPath);
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayingScreen(
                            songs: allSongs,
                          ),
                        ),
                      );
                    },
                    child: FroastedContainer(
                      Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            child: QueryArtworkWidget(
                              id: int.parse(myAudio.metas.id!),
                              type: ArtworkType.AUDIO,
                              artworkBorder: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10)),
                                  image: DecorationImage(
                                    image:
                                        AssetImage("assets/images/default.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                top: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myAudio.metas.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[100],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    myAudio.metas.artist!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Row(
                            children: [
                              PlayerBuilder.isPlaying(
                                  player: assetAudioPlayer,
                                  builder: (context, isPlaying) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await assetAudioPlayer.playOrPause();
                                      },
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 28,
                                      ),
                                    );
                                  }),
                              SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  assetAudioPlayer.next();
                                },
                                child: Icon(
                                  Icons.skip_next_rounded,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 15),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[900],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          onTap: ((int x) {
            setState(() {
              index = x;
            });
          }),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_music_rounded),
              label: 'Library',
            ),
          ],
        ),
      ),
    );
  }

  Widget FroastedContainer(Widget child) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(11),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.withOpacity(0.3),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget? screens(int index) {
    switch (index) {
      case 0:
        return AllSongs(
          allSongs: allSongs,
          dbSongs: dbSongs,
        );

      case 1:
        return const SearchScreen();

      case 2:
        return const LibraryScreen();
    }
  }
}
