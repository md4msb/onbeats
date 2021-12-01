import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  String playlistName;

  PlaylistScreen({Key? key, required this.playlistName}) : super(key: key);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 12),
                child: Text(
                  widget.playlistName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('ADD SONG',style: TextStyle(
                    fontSize: 15.5
                  ),),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pink[800],
                      fixedSize: const Size(195, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              )
            ],
          ),

          // likedSongList(title: "Song Title"),
          // likedSongList(title: "Song Title"),
          // likedSongList(title: "Song Title"),
        ],
      ),
    );
  }

  // Padding likedSongList(
  //     {required title,
  //     leadIcon = Icons.music_note_rounded,
  //     double leadSize = 28,
  //     leadClr = Colors.pink}) {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
  //     child: ListTile(
  //       leading: Container(
  //         height: 50,
  //         width: 50,
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //               image: AssetImage("assets/images/searchpre.jpg"),
  //               fit: BoxFit.cover),
  //           color: leadClr,
  //           borderRadius: BorderRadius.all(Radius.circular(17)),
  //         ),
  //         child: Center(
  //             child: Icon(
  //           leadIcon,
  //           color: Colors.white,
  //           size: leadSize,
  //         )),
  //       ),
  //       title: Text(
  //         title,
  //         style: TextStyle(
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       trailing: Icon(
  //         Icons.play_arrow_rounded,
  //         size: 30,
  //       ),
  //     ),
  //   );
  // }
}
