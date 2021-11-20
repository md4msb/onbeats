import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
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
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Column(
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
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
                ),
              ),
            ],
          ),

          searchSongList(title: "Song Title",tail: Icons.play_arrow_rounded,),
          searchSongList(title: "Song Title",tail: Icons.play_arrow_rounded,)

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
            image: DecorationImage(image: AssetImage("assets/images/searchpre.jpg"),fit: BoxFit.cover),
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
          tail,
          size: 30,
        ),
      ),
    );
  }
}
