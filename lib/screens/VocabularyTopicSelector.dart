import 'package:flutter/material.dart';
import 'package:nihongogoin5/persistency/DeutscheLernenDatabase.dart';
import 'package:nihongogoin5/screens/VocabularyScreen.dart';

class VocabularyTopicSelector extends StatefulWidget {
  List<String> topics_ = [];
  late DeutscheLernenDatabase database_;
  VocabularyTopicSelector(_database) {
    database_ = _database;
    topics_ = database_.getTables();
  }

  @override
  _VocabularyTopicSelectorState createState() =>
      _VocabularyTopicSelectorState();
}

class _VocabularyTopicSelectorState extends State<VocabularyTopicSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vocabulary Screen"),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
                padding: EdgeInsets.all(16.0),
                itemCount: widget.topics_.length * 2,
                itemBuilder: /*1*/ (context, i) {
                  if (i.isOdd) return Divider(thickness: 2); /*2*/
                  final index = i ~/ 2;
                  return ListTile(
                    title: Text(widget.topics_[index]),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VocabularyScreen(
                              widget.database_.getTable(widget.topics_[index])),
                        )),
                  );
                })));
  }
}
