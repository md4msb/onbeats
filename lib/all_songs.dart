import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:music_app/playing_song.dart';
import 'package:music_app/settings_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'open_assetaudio.dart';
import 'dart:ui';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");

  

  List<SongModel> songs = [];

  List<DataModel> mappedSongs = [];

  final box = Boxes.getSongsDb();

  List<DataModel>? dbSongs = [];

  List<Audio> allSongs = [];

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

    dbSongs = await box.get("musics");

    dbSongs!.forEach( 
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
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF660b32), Color(0xFF000000)],
              begin: Alignment.topLeft,
              end: FractionalOffset(0.6, 0.3))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
                icon: const Icon(
                  Icons.settings_outlined,
                ))
          ],
        ),
        body: SafeArea(
            child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                padding: const EdgeInsets.only(
                    left: 25, right: 25, bottom: 25, top: 5),
                itemCount: allSongs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      
                      OpenAssetAudio(allSongs: allSongs, index: index).open();
                     
                      // OpenAssetAudio.open();
                      // audioPlayer.open(
                      //   Playlist(audios: allSongs, startIndex: index),
                      //   showNotification: true,
                      //   autoStart: true,
                      // );
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayingScreen(
                                    songs: allSongs,
                                    index: index,
                                  )));
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: DialogContainer(
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 30, right: 30),
                                    child: Text(
                                      dbSongs![index].title,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  ListTile(
                                    title: Text("Add to Playlist"),
                                    trailing: Icon(Icons.add),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text("Add to Favorites"),
                                    trailing: Icon(
                                      Icons.favorite_border_rounded,
                                      // color: Colors.redAccent,
                                    ),
                                    onTap: () {},
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    child: Stack(
                      clipBehavior: Clip.antiAlias,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          child: QueryArtworkWidget(
                            artworkClipBehavior: Clip.antiAlias,
                            id: int.parse(allSongs[index].metas.id!),
                            type: ArtworkType.AUDIO,
                            artworkBorder: BorderRadius.circular(25),
                            artworkFit: BoxFit.cover,
                            nullArtworkWidget: Container(
                              height: 156,
                              width: 160,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/default.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              child: FroastedContainer(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allSongs[index].metas.title!,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      dbSongs?[index].artist ?? "No Artist",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                })),
      ),
    );
  }

  Widget FroastedContainer(Widget child) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          height: 61,
          width: 144,
          color: Colors.grey.withOpacity(0.3),
          child: child,
        ),
      ),
    );
  }

  Widget DialogContainer(Widget child) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: Colors.grey.withOpacity(0.1),
          child: child,
        ),
      ),
    );
  }
}
