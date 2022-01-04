import 'package:flutter/material.dart';
import 'package:music_app/providers/music_provider.dart';
import 'package:music_app/widgets/snackbars.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class BuildSheet extends StatelessWidget {
  BuildSheet({Key? key, required this.song}) : super(key: key);
  var song;

  List playlists = [];
  String? playlistName = '';
  List<dynamic>? playlistSongs = [];

  @override
  Widget build(BuildContext context) {
    MusicProvider musicProvider = Provider.of<MusicProvider>(context);
    final box = musicProvider.box;
    playlists = box.keys.toList();
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
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
                    onChanged: (value) {
                      playlistName = value;
                    },
                    autofocus: true,
                    cursorRadius: const Radius.circular(50),
                    cursorColor: Colors.grey,
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          bool check = musicProvider.createNewPlaylist(
                              playlists, playlistName);

                          if (check == true) {
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBars().excistingPlaylist);
                          }
                        },
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

                          // setState(() {});
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

  // void submit() async {
  //   List? excistingName = [];
  //   if (playlists.isNotEmpty) {
  //     excistingName =
  //         playlists.where((element) => element == playlistName).toList();
  //   }

  //   if (playlistName != '' && excistingName.isEmpty) {
  //     await box.put(playlistName, playlistSongs!);
  //     Navigator.of(context).pop();
  //     setState(() {});
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBars().excistingPlaylist);
  //   }
  // }
}
