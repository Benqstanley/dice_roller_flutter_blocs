import 'package:flutter/material.dart';

class DiceOutputRow extends StatelessWidget {
  final String description;
  final String result;

  DiceOutputRow(this.description, this.result);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Colors.black),
              top: BorderSide(color: Colors.black))),
      padding: EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '$description:',
            style: TextStyle(color: Colors.black),
          ),
          Flexible(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              result,
              style: TextStyle(color: Colors.black),
            ),
          ))
        ],
      ),
    );
  }
}

class SpecialDiceOutputRow extends StatelessWidget {
  final Map<String, List<String>> rollInfo;
  final String collectionName;

  SpecialDiceOutputRow(
      {@required this.rollInfo, @required this.collectionName});

  List<Widget> createList() {
    List<Widget> outputs = [];
    List<String> descriptions = rollInfo['descriptions'];
    List<String> rolls = rollInfo['rolls'];
    for (int i = 0; i < descriptions.length; i++) {
      outputs.add(DiceOutputRow(descriptions[i], rolls[i]));
    }
    return outputs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
          top: BorderSide(),
        ),
      ),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(),
                )),
                padding:
                    const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 8.0),
                child: Text(
                  '$collectionName:',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(border: Border(left: BorderSide())),
                  child: Column(children: createList())),
            ),
          ],
        ),
      ),
    );
  }
}
