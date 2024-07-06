import 'package:flutter/material.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabase.dart';

class VocabularyScreen extends StatefulWidget {
  List<VocabularyEntry> vocabulary_ = [];

  VocabularyScreen(_vocabulary) {
    vocabulary_ = _vocabulary;
  }

  @override
  _VocabularyScreenState createState() => _VocabularyScreenState();
}

class _VocabularyScreenState extends State<VocabularyScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                  ),
                  controller: _searchController,
                  onChanged: (text) => setState(() {}),
                ),
                Flexible(
                  child: ListView.builder(
                      padding: EdgeInsets.all(16.0),
                      itemCount: widget.vocabulary_.length * 2,
                      itemBuilder: /*1*/ (context, i) {
                        final index = i ~/ 2;
                        if (widget.vocabulary_[index].spanish
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase()) ||
                            widget.vocabulary_[index].deutsche
                                .toLowerCase()
                                .contains(
                                    _searchController.text.toLowerCase())) {
                          if (i.isOdd)
                            return Divider(thickness: 2); /*2*/
                          else
                            return _buildRow(widget.vocabulary_[index]);
                        } else {
                          return Container();
                        }
                      }),
                )
              ],
            )));
  }

  Widget _buildRow(VocabularyEntry entry) {
    return ListTile(
        title: Row(
      children: [
        Expanded(child: Text(entry.spanish)),
        Expanded(child: Text(entry.deutsche))
      ],
    ));
  }
}
