import 'package:flutter/material.dart';
import 'package:music_app/database/boxes.dart';
import 'package:music_app/database/data_model.dart';
import 'package:on_audio_query/on_audio_query.dart';

class buildSheet extends StatefulWidget {
  String playlistName;
  buildSheet({Key? key, required this.playlistName}) : super(key: key);

  @override
  _buildSheetState createState() => _buildSheetState();
}

class _buildSheetState extends State<buildSheet> {
  final box = Boxes.getSongsDb();

  List<dynamic>? dbSongs = [];
  List<dynamic>? playlistSongs = [];

  @override
  void initState() {
    super.initState();
    getSongs();
  }

  getSongs() {
    dbSongs = box.get("musics") as List<DataModel>;
    playlistSongs = box.get(widget.playlistName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 20, left: 5, right: 5),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: dbSongs!.length,
          itemBuilder: (context, index) {
            playlistSongs = box.get(widget.playlistName);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: Container(
                  height: 50,
                  width: 50,
                  child: QueryArtworkWidget(
                    id: dbSongs![index].id,
                    type: ArtworkType.AUDIO,
                    artworkBorder: BorderRadius.circular(15),
                    artworkFit: BoxFit.cover,
                    nullArtworkWidget: Container(
                      height: 50,
                      width: 50,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                          image: AssetImage("assets/images/default.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  dbSongs![index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: playlistSongs!
                        .where((element) =>
                            element.id.toString() ==
                            dbSongs![index].id.toString())
                        .isEmpty
                    ? IconButton(
                        onPressed: () async {
                          playlistSongs?.add(dbSongs![index]);
                          await box.put(widget.playlistName, playlistSongs!);

                          setState(() {
                            playlistSongs = box.get(widget.playlistName);
                          });
                        },
                        icon: Icon(Icons.add))
                    : IconButton(
                        onPressed: () async {
                          playlistSongs?.remove(dbSongs![index]);
                          await box.put(widget.playlistName, playlistSongs!);
                          setState(() {});
                        },
                        icon: Icon(Icons.remove)),
              ),
            );
          },
        ));
  }
}