import 'package:deutsche_lernen_a1/helpers.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabase.dart';
import 'package:path/path.dart';

import 'TestScreen.dart';

class TestContentSelector extends StatefulWidget {
  late DeutscheLernenDatabase db_;

  TestContentSelector(_db) {
    db_ = _db;
  }

  @override
  _TestContentSelectorState createState() => _TestContentSelectorState();
}

class _TestContentSelectorState extends State<TestContentSelector> {
  // multiple choice value
  List<String> tags = [];
  int numQuestions = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Content Selector"),
      ),
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(getBgImage()),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(32),
          child: ListView(
            children: [
              Text("Select topics"),
              ChipsChoice<String>.multiple(
                  value: tags,
                  onChanged: (val) => setState(() => tags = val),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: widget.db_.getTables(),
                    value: (i, v) => v,
                    label: (i, v) => v,
                    tooltip: (i, v) => v,
                  ),
                  wrapped: true),
              Divider(
                thickness: 3,
              ),
              Text("Number of questions."),
              ChipsChoice<int>.single(
                value: numQuestions,
                onChanged: (val) => setState(() => numQuestions = val),
                choiceItems: C2Choice.listFrom<int, String>(
                  source: ["5", "10", "20", "50"],
                  value: (i, v) => int.parse(v),
                  label: (i, v) => v,
                  tooltip: (i, v) => v,
                ),
                wrapped: true,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (tags.length != 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return new TestScreen(
                    widget.db_.getAllTables(tags), numQuestions);
              }),
            );
          }
        },
        label: Text('Start'),
        icon: Icon(Icons.play_arrow),
        backgroundColor: Colors.green,
      ),
    );
  }
}
