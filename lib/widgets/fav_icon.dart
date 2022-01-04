import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';

// ignore: must_be_immutable
class FavIcon extends StatefulWidget {
  FavIcon({Key? key, required this.song}) : super(key: key);
  var song;

  @override
  _FavIconState createState() => _FavIconState();
}

class _FavIconState extends State<FavIcon> {
  final box = Boxes.getSongsDb();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          setState(() {
            List<dynamic>? likedSongs = box.get("favorites");
            likedSongs?.add(widget.song);
            box.put("favorites", likedSongs!);
            likedSongs = box.get("favorites");
          });
        },
        icon: const Icon(
          Icons.favorite_border_rounded,
          size: 30,
        ));
  }
}
