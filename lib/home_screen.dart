import 'package:flutter/material.dart';
import 'package:music_app/all_songs.dart';
import 'package:music_app/library_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens(index),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.grey[900],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          showSelectedLabels: true,
          unselectedItemColor: Colors.white54,
          selectedItemColor: Colors.white,
          onTap: ((int x) {
            setState(() {
              index = x;
            });
          }),
          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_library_music_rounded),
                label: 'Library'),
          ],
        ),
      ),
    );
  }
}

Widget? screens(int index) {
  switch (index) {
    case 0:
      return const AllSongs();

    case 1:
      return const SearchScreen();

    case 2:
      return const LibraryScreen();
  }
}
