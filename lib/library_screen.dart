import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/favorites.dart';
import 'package:music_app/playlist_screen.dart';
import 'database/boxes.dart';
import 'database/data_model.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late TextEditingController controller;

  final excistingPlaylist = SnackBar(
    content: Text(
      'Excisting playlist name',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.grey[900],
  );

  final box = Boxes.getSongsDb();
  List playlists = [];

  List<DataModel> library = [];

  String? playlistName = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();

    playlists = box.keys.toList();
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
        title: const Text(
          'Your Library',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        toolbarHeight: 65,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Playlists",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: 79,
                  height: 2.6,
                  decoration: BoxDecoration(
                      color: Colors.pink[700],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                ),
              ],
            ),
          ),
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
                        onPressed: () {
                          submit();
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
          libraryLists(
              title: "Liked Songs",
              leadIcon: Icons.favorite_border_rounded,
              leadSize: 23,
              leadClr: Colors.pink[400],
              tail: Icons.arrow_forward_ios),
          ...playlists
              .map((e) => e != "musics" && e != "favorites"
                  ? libraryList(
                      child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PlaylistScreen(
                                        playlistName: e,
                                      )),
                            );
                          },
                          leading: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/searchpre.jpg"),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                            ),
                          ),
                          title: Text(
                            e.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Text("Delete Playlist"),
                                      value: "0",
                                    ),
                                  ],
                              onSelected: (value) {
                                if (value == "0") {
                                  box.delete(e);
                                  setState(() {
                                    playlists = box.keys.toList();
                                  });
                                }
                              })),
                    )
                  : Container())
              .toList()
        ],
      ),
    );
  }

  Padding libraryLists(
      {required title,
      leadIcon = Icons.music_note_rounded,
      double leadSize = 28,
      tail,
      leadClr = Colors.pink}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
      child: ListTile(
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Favorites())),
          leading: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: leadClr,
              borderRadius: BorderRadius.all(Radius.circular(17)),
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Favorites())),
            icon: Icon(
              tail,
              size: 20,
            ),
          )),
    );
  }

  Padding libraryList({required child}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        child: child);
  }

  void submit() {
    playlistName = controller.text;

    List? excistingName = [];
    if (playlists.length > 0) {
      excistingName =
          playlists.where((element) => element == playlistName).toList();
    }

    if (playlistName != '' && excistingName.length == 0) {
      box.put(playlistName, library);
      Navigator.of(context).pop();
      setState(() {
        playlists = box.keys.toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(excistingPlaylist);
    }

    controller.clear();
  }
}
