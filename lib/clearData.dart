import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:launch_review/launch_review.dart';
import 'package:root_access/root_access.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:storage_path/storage_path.dart';
import 'package:storage_path/storage_path.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

import 'package:path_provider_ex/path_provider_ex.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'HomePage.dart';
import 'myApp.dart';
import 'myDrawer.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CLEAR extends StatefulWidget {
  @override
  _CLEARState createState() => _CLEARState();
}

class _CLEARState extends State<CLEAR> {
  List<StorageInfo> _storageInfo = [];
  Future<void> _launched;

  // static const platform = const MethodChannel('clearData');
  bool _rootAccess = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initRootRequest();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> initRootRequest() async {
    bool rootAccess = await RootAccess.rootAccess;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _rootAccess = rootAccess;
    });
  }

  @override
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4E008A),
        title: Text(
          "Clear Data",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        leading: Image.asset(
          "assets/logo.png",
          color: Colors.white,
        ),
        actions: [
          Builder(
            builder: (context) => FlatButton(
              child: Icon(
                Icons.list,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: myApp(),
      endDrawer: myDrawer(),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color(0xffFF375E),
                Color(0xff4E008A),
              ])),
          child: Center(
            child: Container(
              height: 300,
              width: 300,
              child: Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    InkWell(
                      child: Column(
                        children: [
                          Text(
                            "START NOW",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "قريبا",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                      onTap: () {
                        deleteFile();
                      },
                    )
                    //Text("START NOW",style: TextStyle(color: Colors.white,fontSize: 26,fontWeight: FontWeight.bold), ),
                    //Text("قريبا",style: TextStyle(color: Colors.white,fontSize: 18),),
                  ])),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Color(0xff4E008A)],
                  ),
                  //RadialGradient(colors: [Color(0xffCBBFD5),Color(0xff4E008A)],),
                  borderRadius: BorderRadius.circular(150),
                  border: Border.all(color: Colors.white, width: 8)),
            ),
          )),
    );
  }

  Future<File> get _localFile async {
    final path = await _storageInfo[0].rootDir;

    return File(
        '$path/Android/data/com.tencent.ig/files/UE4Game/ShadowTrackerExtra/Saved/Logs/ShadowTrackerExtra.log');
  }

  Future<void> deleteFile() async {
    try {
      if (_rootAccess) {
        try {
          File file = await _localFile;
          file.delete();
        } catch (err) {
          print(err);
        }
      } else {
        AppAvailability.launchApp("com.salah.manager")
            .then((_) => print("Lunched"))
            .catchError((err) {
          print(err);
          _launched = _launchInBrowser(
              "https://play.google.com/store/apps/details?id=com.salah.manager");
        });
      }
    } catch (e) {}
  }

  Future<void> initPlatformState() async {
    List<StorageInfo> storageInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      storageInfo = await PathProviderEx.getStorageInfo();
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _storageInfo = storageInfo;
    });
  }

  void changeBrightness() {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  Widget lanBox(Function lang, String lanName) {
    return InkWell(
      onTap: lang,
      child: Material(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8.0, bottom: 8, right: 18, left: 18),
          child: Text(
            lanName,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 10,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
      ),
    );
  }
}
