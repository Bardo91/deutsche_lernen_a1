import 'package:deutsche_lernen_a1/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';
import 'package:deutsche_lernen_a1/screens/TestContentSelector.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabase.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabaseLessons.dart';
import 'package:deutsche_lernen_a1/screens/VocabularyTopicSelector.dart';

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
  bool isDbOpen = false;
  bool isDbLessonsOpen = false;

  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);

    _dbVocabulary.open().then((value) => isDbOpen = value);
    // _dbLessons.open().then((value) => isDbLessonsOpen = value);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.repeat(min: 0, max: 2, period: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                image: AssetImage(getBgImage()),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView(
              children: [
                ListTile(
                    title: Text("Test"),
                    onTap: () => isDbOpen
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TestContentSelector(_dbVocabulary)))
                        : {}),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                    title: Text("Vocabulario"),
                    onTap: () => isDbOpen
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VocabularyTopicSelector(_dbVocabulary)))
                        : {}),
                Divider(
                  thickness: 2,
                ),
                ListTile(
                  title: Text("Lessons"),
                  // onTap: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             LessonSelector(_dbLessons.getEntries)))
                ),
              ],
            )));
  }
}
