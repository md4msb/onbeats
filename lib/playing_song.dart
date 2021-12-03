import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:music_app/widgets/snackbars.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingScreen extends StatefulWidget {
  List<Audio> songs;

  PlayingScreen({
    Key? key,
    required this.songs,
  }) : super(key: key);

  @override
  _PlayingScreenState createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }

  late TextEditingController controller;
  final box = Boxes.getSongsDb();

  List playlists = [];
  List<dynamic>? playlistSongs = [];
  String? playlistName = '';

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 38,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Now Playing",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: assetAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
          final myAudio = find(widget.songs, playing!.audio.assetAudioPath);

          return Center(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //!----------------------------
                //!<<<album art of the song.>>>
                //!----------------------------

                const SizedBox(
                  height: 60,
                ),

                SizedBox(
                  height: 310,
                  width: 310,
                  child: QueryArtworkWidget(
                    id: int.parse(myAudio.metas.id!),
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(20),
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                      height: 310,
                      width: 310,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/default.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                //!----------------------------
                //!<<<title of the song.>>>
                //!----------------------------

                Container(
                  margin: const EdgeInsets.only(right: 70, left: 70),
                  child: Column(
                    children: [
                      Text(
                        myAudio.metas.title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        myAudio.metas.artist ?? "No Artist",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                //!------------------------------------------
                //!<<<Progress bar.>>>
                //!------------------------------------------

                const SizedBox(
                  height: 30,
                ),

                assetAudioPlayer.builderRealtimePlayingInfos(
                    builder: (context, RealtimePlayingInfos? infos) {
                  if (infos == null) {
                    return SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: ProgressBar(
                      timeLabelPadding: 10,
                      thumbRadius: 0,
                      baseBarColor: Colors.grey[500],
                      progressBarColor: Colors.purple[700],
                      thumbGlowRadius: 8,
                      thumbGlowColor: Colors.purple[400],
                      barHeight: 4,
                      progress: infos.currentPosition,
                      total: infos.duration,
                      onSeek: (duration) {
                        assetAudioPlayer.seek(duration);
                      },
                    ),
                  );
                }),

                //!------------------------------------------
                //!<<<song action buttons>>>
                //!------------------------------------------

                const SizedBox(
                  height: 5,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.skip_previous_rounded,
                        size: 28,
                      ),
                      onPressed: () {
                        assetAudioPlayer.previous();
                      },
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    PlayerBuilder.isPlaying(
                        player: assetAudioPlayer,
                        builder: (context, isPlaying) {
                          return IconButton(
                              onPressed: () async {
                                await assetAudioPlayer.playOrPause();
                              },
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 32,
                              ));
                        }),
                    SizedBox(
                      width: 25,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.skip_next_rounded,
                        size: 28,
                      ),
                      onPressed: () {
                        assetAudioPlayer.next();
                      },
                    ),
                  ],
                ),

                //!------------------------------------------
                //!<<<bottom section>>>
                //!------------------------------------------

                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    context: context,
                                    builder: (context) {
                                      List<DataModel> dbSongs =
                                          box.get("musics") as List<DataModel>;
                                      final currentSong = dbSongs
                                          .firstWhere((element) =>
                                              element.id.toString() ==
                                              myAudio.metas.id.toString());
                                          
                                      print(currentSong.title);
                                      return buildSheet(song: currentSong);
                                      
                                    });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.reorder,
                                color: Colors.white,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }

  Widget buildSheet({required song}) {
    playlists = box.keys.toList();
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          libraryList(
            child: ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Give your playlist a name",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.grey,
                  ),
                  actions: [
                    TextButton(
                        onPressed: submit,
                        child: Text(
                          "CREATE",
                          style: TextStyle(
                            color: Colors.pink[500],
                          ),
                        ))
                  ],
                ),
              ),
              leading: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF606060),
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                ),
                child: Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                )),
              ),
              title: Text(
                "Create Playlist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...playlists
              .map((e) => e != "musics"
                  ? libraryList(
                      child: ListTile(
                      onTap: () async {
                        print(song.title);
                        print(e);
                        playlistSongs = box.get(e);
                        List existingSongs = [];
                        existingSongs = playlistSongs!
                            .where((element) =>
                                element.id.toString() == song.id.toString())
                            .toList();

                        if (existingSongs.isEmpty) {
                          playlistSongs?.add(song);
                          await box.put(e, playlistSongs!);

                          setState(() {});
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBars().songAdded);
                        } else {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBars().excistingSong);
                        }
                      },
                      leading: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/searchpre.jpg"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                      ),
                      title: Text(
                        e.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ))
                  : Container())
              .toList()
        ],
      ),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }

  void submit() async {
    playlistName = controller.text;

    List? excistingName = [];
    if (playlists.length > 0) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' && excistingName.length == 0) {
      await box.put(playlistName, playlistSongs!);
      Navigator.of(context).pop();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBars().excistingPlaylist);
    }

    controller.clear();
  }
}
