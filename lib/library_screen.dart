import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_app/favorites.dart';


class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
              title: "Create Playlist",
            
              leadIcon: Icons.add,
              leadClr: Color(0xFF606060)),
          libraryList(
              title: "Liked Songs",
         
              leadIcon: Icons.favorite_border_rounded,
              leadSize: 22,
              leadClr: Colors.pink[400],
              tail: Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  Padding libraryList(
      {required title,
 
      leadIcon = Icons.music_note_rounded,
      double leadSize = 28,
      tail,
      leadClr = Colors.pink}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => Favorites())),
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
        trailing: Icon(
          tail,
          size: 20,
        ),
      ),
    );
  }
}
