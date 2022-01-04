import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:music_app/screens/library_screen.dart';
import 'package:music_app/widgets/fav_icon.dart';
import 'package:music_app/widgets/red_fav.dart';
import 'package:music_app/widgets/snackbars.dart';
import 'package:on_audio_query/on_audio_query.dart';

// ignore: must_be_immutable
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
  List<DataModel> dbSongs = [];
  List<dynamic>? likedSongs = [];

  @override
  void initState() {
    super.initState();
    dbSongs = box.get("musics") as List<DataModel>;
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
    return SafeArea(
      child: Scaffold(
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

            final currentSong = dbSongs.firstWhere((element) =>
                element.id.toString() == myAudio.metas.id.toString());

            likedSongs = box.get("favorites");

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
                    height: 50,
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
                    height: 40,
                  ),

                  assetAudioPlayer.builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                    if (infos == null) {
                      return const SizedBox();
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
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
                      const SizedBox(
                        width: 30,
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
                                  size: 34,
                                ));
                          }),
                      const SizedBox(
                        width: 30,
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
                            likedSongs!
                                    .where((element) =>
                                        element.id.toString() ==
                                        currentSong.id.toString())
                                    .isEmpty
                                ? FavIcon(song: currentSong)
                                // IconButton(
                                //     onPressed: () async {
                                //       likedSongs?.add(currentSong);
                                //       await box.put("favorites", likedSongs!);

                                //       setState(() {});
                                //     },
                                //     icon: const Icon(
                                //       Icons.favorite_border_rounded,
                                //       size: 30,
                                //     ))
                                : RedFav(song: currentSong),
                            // IconButton(
                            //     onPressed: () async {
                            //       likedSongs?.removeWhere((elemet) =>
                            //           elemet.id.toString() ==
                            //           currentSong.id.toString());
                            //       await box.put("favorites", likedSongs!);
                            //       setState(() {});
                            //     },
                            //     icon: const Icon(
                            //       Icons.favorite_rounded,
                            //       color: Colors.redAccent,
                            //       size: 30,
                            //     )),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20))),
                                      context: context,
                                      builder: (context) {
                                        return buildSheet(song: currentSong);
                                      });
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 30,
                                )),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LibraryScreen()));
                                },
                                icon: const Icon(
                                  Icons.playlist_play_rounded,
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
          })),
    );
  }

  Widget buildSheet({required song}) {
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          libraryList(
            child: ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text(
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
                decoration: const BoxDecoration(
                  color: Color(0xFF606060),
                  borderRadius: BorderRadius.all(Radius.circular(17)),
                ),
                child: const Center(
                    child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                )),
              ),
              title: const Text(
                "Create Playlist",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ...playlists
              .map((e) => e != "musics" && e != "favorites"
                  ? libraryList(
                      child: ListTile(
                      onTap: () async {
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/searchpre.jpg"),
                              fit: BoxFit.cover),
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                      ),
                      title: Text(
                        e.toString(),
                        style: const TextStyle(
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
    if (playlists.isNotEmpty) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' && excistingName.isEmpty) {
      await box.put(playlistName, playlistSongs!);
      Navigator.of(context).pop();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBars().excistingPlaylist);
    }

    controller.clear();
  }
}
