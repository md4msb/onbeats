import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'database/data_model.dart';
import 'home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main () async{
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox<List<DataModel>>("songData");

  SharedPreferences prefs = await SharedPreferences.getInstance();
    var notify = prefs.getBool("switchState");
  if (notify != null) {
      prefs.setBool("switchState", true);
  }
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: ThemeData.dark(),
    );
  }
}
