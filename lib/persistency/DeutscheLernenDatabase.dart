import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

class VocabularyEntry {
  final article;
  final deutsche;
  final spanish;

  VocabularyEntry({this.article, this.deutsche, this.spanish});
}

class DeutscheLernenDatabase {
  final int DATABASE_VERSION = 1;
  final String DATABASE_NAME = "deutsch_lernen_a1.db";

  late Database database;
  late bool isOpen_ = false;
  late List<String> tableNames_;
  Map<String, List<VocabularyEntry>> vocabularyTables_ = {};

  bool isOpen() {
    return isOpen_;
  }

  Future<bool> open() async {
    WidgetsFlutterBinding.ensureInitialized();
    ByteData data = await rootBundle.load('assets/deutsch_lernen_a1.db');
    final Directory tempDir = await getTemporaryDirectory();
    final path = join(tempDir.path, DATABASE_NAME);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(path).writeAsBytes(bytes, flush: true);

    database = await openDatabase(path);

    if (!database.isOpen) {
      return false;
    }

    tableNames_ = (await database
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: true);

    tableNames_.remove('android_metadata');

    for (var tableName in tableNames_) {
      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await database.query(tableName);

      // Convert the List<Map<String, dynamic> into a List<Dog>.
      var table = List.generate(maps.length, (i) {
        return VocabularyEntry(
          article: maps[i]['article'],
          deutsche: maps[i]['deutsche'],
          spanish: maps[i]['spanish'],
        );
      });

      vocabularyTables_[tableName] = table;
    }

    isOpen_ = true;

    return true;
  }

  List<String> getTables() {
    return tableNames_;
  }

  List<VocabularyEntry> getTable(String _tableName) {
    final table = vocabularyTables_[_tableName];
    if (table == null) {
      return [];
    } else {
      return table;
    }
  }

  List<VocabularyEntry> getAll() {
    var tables = getTables();
    List<VocabularyEntry> fullVocab = [];
    for (var tableName in tables) {
      var table = getTable(tableName);
      fullVocab.addAll(table);
    }
    return fullVocab;
  }

  List<VocabularyEntry> getAllTables(List<String> _tables) {
    List<VocabularyEntry> fullVocab = [];
    for (var tableName in _tables) {
      var table = getTable(tableName);
      fullVocab.addAll(table);
    }
    return fullVocab;
  }
}
