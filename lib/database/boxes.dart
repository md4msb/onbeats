import 'package:hive/hive.dart';


class Boxes {
  static Box<List<dynamic>> getSongsDb() => 
    Hive.box<List<dynamic>>("songData");
}
