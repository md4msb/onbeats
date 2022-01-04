import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';

// ignore: must_be_immutable
class RedFav extends StatefulWidget {
  RedFav({Key? key, required this.song}) : super(key: key);
  var song;

  @override
  _RedFavState createState() => _RedFavState();
}

class _RedFavState extends State<RedFav> {
  final box = Boxes.getSongsDb();
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          setState(() {
            List<dynamic>? likedSongs = box.get("favorites");
            likedSongs?.removeWhere(
                (elemet) => elemet.id.toString() == widget.song.id.toString());
            box.put("favorites", likedSongs!);
          });
        },
        icon: const Icon(
          Icons.favorite_border_rounded,
          size: 30,
        ));
  }
}
