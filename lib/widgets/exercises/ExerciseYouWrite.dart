import 'dart:math';

import 'package:flutter/material.dart';
import 'package:deutsche_lernen_a1/persistency/DeutscheLernenDatabase.dart';

class ExerciseYouWrite extends StatefulWidget {
  List<VocabularyEntry> _vocabulary = [];
  int _idAnswer = 0;
  bool _isRight = false;

  ExerciseYouWrite(vocabulary, idAnswer) {
    _vocabulary = vocabulary;
    _idAnswer = idAnswer;
  }

  bool checkAnswer() {
    return _isRight;
  }

  @override
  _ExerciseYouWriteState createState() => _ExerciseYouWriteState();
}

class _ExerciseYouWriteState extends State<ExerciseYouWrite> {
  String _guess = "";
  String _answer = "";
  String _instructions = "";
  @override
  void initState() {
    // Get word
    var random = new Random();
    var answer = widget._vocabulary[widget._idAnswer];

    // Select mode of exercise
    int sourceType = 0;

    int destType = random.nextInt(1) + 1;

    _guess = getStringFromWord(answer, sourceType);
    _answer = getStringFromWord(answer, destType);
    _instructions = getInstructions(answer, destType);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Text(
              _guess,
              textScaleFactor: 2,
            ),
          ),
          Container(
            child: Text(
              _instructions,
              textScaleFactor: 1,
            ),
          ),
          Divider(height: 20, thickness: 5, indent: 20, endIndent: 20),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Type your answer'),
            onChanged: (value) => widget._isRight =
                _answer.toLowerCase().trim() == value.toLowerCase().trim(),
          )
        ],
      ),
    );
  }

  String getStringFromWord(VocabularyEntry word, int type) {
    switch (type) {
      case 0:
        return word.spanish;
      case 1:
        return word.deutsche;
      default:
        return "error";
    }
  }

  String getInstructions(VocabularyEntry word, int type) {
    switch (type) {
      case 0:
        return "Escribe tu respuesta en Español";
      case 1:
        return "Escribe tu respuesta en Aleman";
      default:
        return "error";
    }
  }
}
