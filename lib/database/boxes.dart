import 'package:hive/hive.dart';
import 'package:music_app/database/data_model.dart';

class Boxes {
  static Box<List<DataModel>> getSongsDb() => 
    Hive.box<List<DataModel>>("songData");
}
