import 'package:flutter/material.dart';

class ScoreBar extends StatefulWidget {
  late int numQuestions_;
  ScoreBar(key, _numQuestions) : super(key: key) {
    numQuestions_ = _numQuestions;
  }

  @override
  _ScoreBarState createState() {
    return _ScoreBarState(numQuestions_);
  }
}

class _ScoreBarState extends State<ScoreBar> {
  late List<bool> scores_;
  late int currentScore_ = 0;

  _ScoreBarState(int _maxScore) {
    scores_ = List<bool>.generate(_maxScore, (int) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        children: List.generate(
            scores_.length,
            (i) => Container(
                  child: Icon(
                      i >= currentScore_
                          ? Icons.help_outline
                          : (scores_[i] ? Icons.check : Icons.clear_outlined),
                      color: i == currentScore_
                          ? Colors.yellow
                          : (i > currentScore_
                              ? Colors.blue
                              : (scores_[i] ? Colors.green : Colors.red))),
                )));
  }

  bool hasFinished() {
    return !(currentScore_ < scores_.length - 1);
  }

  void good() {
    if (currentScore_ < scores_.length - 1) {
      scores_[currentScore_] = true;
      currentScore_++;
      setState(() {});
    }
  }

  void bad() {
    if (currentScore_ < scores_.length - 1) {
      scores_[currentScore_] = false;
      currentScore_++;
      setState(() {});
    }
  }

  double finalScore() {
    double good = 0;
    for (var score in scores_) {
      if (score) good += 1;
    }
    return good / scores_.length;
  }
}
