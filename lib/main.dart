import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/providers/music_provider.dart';
import 'package:music_app/screens/home_screen.dart';
import 'database/data_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<List<dynamic>>("songData");

  final box = Boxes.getSongsDb();

  List<dynamic> libraryKeys = box.keys.toList();

  if (!libraryKeys.contains("favorites")) {
    List<dynamic> likedSongs = [];
    await box.put("favorites", likedSongs);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MusicProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
