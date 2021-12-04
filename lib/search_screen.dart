import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/playing_song.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'database/data_model.dart';
import 'open_assetaudio.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<DataModel> dbSongs = [];
  List<Audio> allSongs = [];

  String search = "";

  final box = Boxes.getSongsDb();

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  Future<String> debounce() async {
    await Future.delayed(Duration(seconds: 1));
    return "Waited 1";
  }

  getSongs() {
    dbSongs = box.get("musics") as List<DataModel>;

    dbSongs.forEach((element) {
      allSongs.add(
        Audio.file(
          element.path,
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Audio> searchResult = allSongs
        .where((element) => element.metas.title!.toLowerCase().startsWith(
              search.toLowerCase(),
            ))
        .toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF414345),
            Color(0xFF000000),
          ],
          begin: Alignment.topLeft,
          end: FractionalOffset(0.2, 0.7),
        ),
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(30)),
          Text(
            "Search",
            style: TextStyle(
                color: Colors.white.withOpacity(1.0),
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: TextField(
                style: const TextStyle(color: Colors.black87),
                cursorWidth: 2.3,
                cursorRadius: const Radius.circular(50),
                cursorColor: Colors.pink[800],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusColor: Colors.pink,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black87,
                    size: 24,
                  ),
                  hintText: 'Search for songs',
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                }),
          ),
          search.isNotEmpty
              ? searchResult.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                          // shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: searchResult.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder(
                                future: debounce(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return GestureDetector(
                                      onTap: () {
                                        OpenAssetAudio(
                                                allSongs: searchResult,
                                                index: index)
                                            .open();

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayingScreen(
                                                      songs: searchResult,
                                                    )));
                                      },
                                      child: ListTile(
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          child: QueryArtworkWidget(
                                            id: int.parse(
                                                searchResult[index].metas.id!),
                                            type: ArtworkType.AUDIO,
                                            artworkBorder:
                                                BorderRadius.circular(15),
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
                                          searchResult[index].metas.title!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Text(
                                          searchResult[index].metas.artist!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }
                                  return Container();
                                });
                          }),
                    )
                  : Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        "No result found",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    )
              : SizedBox()
        ],
      ),
    );
  }

  Padding searchSongList(
      {required title,
      leadIcon = Icons.music_note_rounded,
      double leadSize = 28,
      tail,
      leadClr = Colors.pink}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/searchpre.jpg"),
                fit: BoxFit.cover),
            color: leadClr,
            borderRadius: BorderRadius.all(Radius.circular(17)),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          tail,
          size: 30,
        ),
      ),
    );
  }
}
