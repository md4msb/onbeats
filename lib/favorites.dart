import 'package:flutter/material.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 12),
            child: Text(
              "Liked Songs",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          likedSongList(title: "Song Title"),
          likedSongList(title: "Song Title"),
          likedSongList(title: "Song Title"),
        ],
      ),
    );
  }

  Padding likedSongList(
      {required title,
      leadIcon = Icons.music_note_rounded,
      double leadSize = 28,
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
        trailing: Icon(
          Icons.play_arrow_rounded,
          size: 30,
        ),
      ),
    );
  }
}
