import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:nihongogoin5/screens/LessonSelector.dart';
import 'package:nihongogoin5/screens/TestContentSelector.dart';
import 'package:nihongogoin5/persistency/DeutscheLernenDatabase.dart';
import 'package:nihongogoin5/persistency/DeutscheLernenDatabaseLessons.dart';
import 'package:nihongogoin5/screens/VocabularyTopicSelector.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deutsche Lernen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DeutscheLernenDatabase _dbVocabulary = DeutscheLernenDatabase();
  DeutscheLernenDatabaseLessons _dbLessons = DeutscheLernenDatabaseLessons();
  late ProgressDialog dbProcessDialog;
  late Future<bool> isDbOpen;
  late Future<bool> isDbLessonsOpen;
  bool playMusic = false;

  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);

    isDbOpen = _dbVocabulary.open();
    isDbLessonsOpen = _dbLessons.open();
    dbProcessDialog = ProgressDialog(context: context);
    dbProcessDialog.show(
      barrierDismissible: true,
      msg: "Loading DB...",
      hideValue: true,
    );

    Future.delayed(Duration(seconds: 4)).then((onValue) {
      isDbOpen.then((value) {
        if (value) {
          dbProcessDialog.close();
        }
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.repeat(min: 0, max: 2, period: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      if (!_dbVocabulary.isOpen() & !_dbLessons.isOpen) dbProcessDialog.show();
    });

    var random = new Random();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Deutsche Lernen",
            textAlign: TextAlign.center,
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                ListTile(
                    title: Text("Test"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TestContentSelector(_dbVocabulary)))),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                    title: Text("Vocabulario"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VocabularyTopicSelector(_dbVocabulary)))),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                    title: Text("Lessons"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LessonSelector(_dbLessons.getEntries)))),
                Divider(
                  thickness: 2,
                ),
                GifImage(
                  controller: controller,
                  image: AssetImage("assets/gifs/cat_" +
                      (random.nextInt(9) + 1).toString() +
                      ".gif"),
                )
              ],
            )));
  }
}
