import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:music_app/playing_song.dart';
import 'package:music_app/settings_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'open_assetaudio.dart';
import 'dart:ui';
import 'package:music_app/widgets/snackbars.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  _AllSongsState createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  late TextEditingController controller;
  List playlists = [];
  List<dynamic>? playlistSongs = [];
  String? playlistName = '';

  List<dynamic>? likedSongs = [];

  final OnAudioQuery audioQuery = OnAudioQuery();
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId("0");
  final box = Boxes.getSongsDb();

  List<SongModel> songs = [];
  List<DataModel> mappedSongs = [];
  List<DataModel> dbSongs = [];
  List<Audio> allSongs = [];

  @override
  void initState() {
    super.initState();
    requestPermission();
    controller = TextEditingController();
    likedSongs = box.get("favorites");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controller.dispose();
    super.dispose();
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

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PlayingScreen(
                                    songs: allSongs,
                                  )));
                    },
                    onLongPress: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        likedSongs = box.get("favorites");
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
                                      dbSongs[index].title,
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
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showModalBottomSheet(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20))),
                                        context: context,
                                        builder: (context) =>
                                            buildSheet(song: dbSongs[index]),
                                      );
                                    },
                                  ),
                                  likedSongs!
                                          .where((element) =>
                                              element.id.toString() ==
                                              dbSongs[index].id.toString())
                                          .isEmpty
                                      ? ListTile(
                                          title: Text("Add to Favorites"),
                                          trailing: Icon(
                                            Icons.favorite_border_rounded,
                                            // color: Colors.redAccent,
                                          ),
                                          onTap: () async {
                                            likedSongs?.add(dbSongs[index]);
                                            await box.put(
                                                "favorites", likedSongs!);

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    SnackBars().likedAdd);
                                          },
                                        )
                                      : ListTile(
                                          title: Text("Remove from Favorites"),
                                          trailing: Icon(
                                            Icons.favorite_rounded,
                                            color: Colors.redAccent,
                                          ),
                                          onTap: () async {
                                            likedSongs?.removeWhere((elemet) =>
                                                elemet.id.toString() ==
                                                dbSongs[index].id.toString());
                                            await box.put(
                                                "favorites", likedSongs!);
                                            setState(() {});

                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                                    SnackBars().likedRemove);
                                          },
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
                                      dbSongs[index].artist ?? "No Artist",
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
