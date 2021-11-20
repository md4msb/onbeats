import 'package:hive/hive.dart';
part 'data_model.g.dart';

@HiveType(typeId: 0)
class DataModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  int id;

  @HiveField(2)
  String path;

  @HiveField(3)
  String? artist;

  @HiveField(4)
  int? duration;

  DataModel({
    required this.title,
    required this.id,
    required this.path,
    required this.artist,
    required this.duration,
  });
}
