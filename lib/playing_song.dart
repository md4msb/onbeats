import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';


class PlayingScreen extends StatefulWidget {
  List<Audio> songs;


  PlayingScreen({Key? key, required this.songs, })
      : super(key: key);

  @override
  _PlayingScreenState createState() => _PlayingScreenState();
}

class _PlayingScreenState extends State<PlayingScreen> {
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");

  Audio find(List<Audio> source, String fromPath) {
    print("object");
    return source.firstWhere((element) => element.path == fromPath);
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
                  height: 50,
                ),

                Container(
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  width: MediaQuery.of(context).size.width,
                  height: 3,
                  color: Colors.grey[500],
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 100,
                      height: 3,
                      color: Colors.purple[700],
                    ),
                  ),
                ),

                //!------------------------------------------
                //!<<<song action buttons>>>
                //!------------------------------------------

                const SizedBox(
                  height: 30,
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
                              onPressed: () {},
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
}
