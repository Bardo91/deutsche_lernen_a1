import 'package:deutsche_lernen_a1/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:deutsche_lernen_a1/widgets/EntrySelector.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabaseLessons.dart';

class LessonSelector extends StatefulWidget {
  Map<String, List<LessonEntry>> _lessonsEntries =
      new Map<String, List<LessonEntry>>();
  List<String> _keyList = [];
  LessonSelector(lessons) {
    _lessonsEntries = lessons;
    _keyList = _lessonsEntries.keys.toList();
  }

  @override
  _LessonSelectorState createState() => _LessonSelectorState();
}

class _LessonSelectorState extends State<LessonSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lessons"),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBgImage()),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: widget._keyList.length * 2,
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider(thickness: 2); /*2*/
                  final index = i ~/ 2;
                  return ListTile(
                    title: Text(widget._keyList[index]),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EntrySelector(
                              widget._lessonsEntries[widget._keyList[index]]),
                        )),
                  );
                })));
  }
}
