import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart';

class LessonEntry {
  final title;
  final html;

  LessonEntry({this.title, this.html});
}

class DeutscheLernenDatabaseLessons {
  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "deutsche_lernen_a1_lessons.db";

  late Database database;
  bool _isOpen = false;
  List<String> _lessons = [];
  Map<String, List<LessonEntry>> _lessonsEntries =
      new Map<String, List<LessonEntry>>();

  bool get isOpen {
    return _isOpen;
  }

  Future<bool> open() async {
    WidgetsFlutterBinding.ensureInitialized();

    //final dbPath  = await getDatabasesPath();
    //final path = join(dbPath, DATABASE_NAME);
    //
    //ByteData data = await rootBundle.load(join("assets", DATABASE_NAME));
    //
    //List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    //await File(path).writeAsBytes(bytes, flush: true);
    //
    //database = await openDatabase(path);

    Directory applicationDirectory = await getApplicationDocumentsDirectory();

    String dbPathEnglish =
        join(applicationDirectory.path, "deutsche_lernen_a1_lessons.db");
    String url =
        "https://github.com/Bardo91/nihongo_goi_n5/raw/master/assets/nihongo_goi_lessons.db";

    var httpClient = new HttpClient();
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();

    // thow an error if there was error getting the file
    // so it prevents from wrting the wrong content into the db file
    if (response.statusCode != 200) throw "Error getting db file";

    var bytes = await consolidateHttpClientResponseBytes(response);

    File file = new File(dbPathEnglish);
    await file.writeAsBytes(bytes);

    database = await openDatabase(dbPathEnglish);

    if (!database.isOpen) {
      return false;
    }

    _lessons = (await database
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);

    _lessons.remove('android_metadata');

    for (var tableName in _lessons) {
      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await database.query(tableName);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      var table = List.generate(maps.length, (i) {
        return LessonEntry(
          title: maps[i]['title'],
          html: maps[i]['content'],
        );
      });

      _lessonsEntries[tableName] = table;
    }

    _isOpen = true;

    return _isOpen;
  }

  List<String> get lessons {
    return _lessons;
  }

  List<LessonEntry> getLesson(String lesson) {
    final res = _lessonsEntries[lesson];
    if (res == null) {
      return [];
    } else {
      return res;
    }
  }

  Map<String, List<LessonEntry>> get getEntries {
    return _lessonsEntries;
  }
}
