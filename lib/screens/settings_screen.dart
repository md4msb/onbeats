import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool notify = true;

  
  final snackBarNotify = SnackBar(content: const Text('App need to restart to change the settings',style: TextStyle(color: Colors.white),),backgroundColor: Colors.grey[900],);

  @override
  void initState() {
    super.initState();
    getSwitchValues();
  }

  getSwitchValues() async {
    notify = await getSwitchState();
    setState(() {});
  }

  Future<bool> saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("switchState", value);
    return prefs.setBool("switchState", value);
  }

  Future<bool> getSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? notify = prefs.getBool("switchState");

    return notify ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: const Color(0xFF820c3f),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.infinity,
                height: 190,
                decoration: const BoxDecoration(
                    color: Color(0xFF820c3f),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25))),
              ),
            ),
          ),
          Positioned(
              left: 10,
              right: 10,
              top: 60,
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(25),
                          topLeft: Radius.circular(25))),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 10, bottom: 5),
                          child: settingsTile(
                            title: "onbeats",
                            size: 18,
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueGrey,
                              backgroundImage:
                                  AssetImage("assets/images/logo.png"),
                            ),
                          )),
                      const Divider(
                        color: Colors.white70,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                        ),
                        child: Column(
                          children: [
                            settingsTile(
                                title: "Push Notification",
                                tail: Switch(
                                  value: notify,
                                  onChanged: (bool value) {
                                    setState(() {
                                      notify = value;
                                      saveSwitchState(value);
                                    
                                      // ignore: avoid_print
                                      print('Saved state is $notify');

                                      if (notify == true) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarNotify);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBarNotify);
                                      }
                                    });
                                    // ignore: avoid_print
                                    print(notify);
                                  },
                                  activeTrackColor: Colors.pink[700],
                                  thumbColor:
                                      MaterialStateProperty.all(Colors.white),
                                  inactiveTrackColor: Colors.pink[900],
                                )),
                            ListTile(
                              onTap: () {
                                showAboutDialog(
                                  context: context,
                                  applicationIcon: Container(
                                    height: 60,
                                    width: 60,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo.png"),
                                            fit: BoxFit.cover)),
                                  ),
                                  applicationVersion: '1.0.0',
                                  applicationName: 'onbeats',
                                  applicationLegalese: 'MSB',
                                );
                              },
                              title: const Text(
                                "About",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              trailing: const Icon(
                                Icons.keyboard_arrow_right,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  ListTile settingsTile(
      {required title,
      leading,
      tail,
      weight = FontWeight.w500,
      double size = 16}) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style:
            TextStyle(color: Colors.white, fontWeight: weight, fontSize: size),
      ),
      trailing: tail,
    );
  }
}
