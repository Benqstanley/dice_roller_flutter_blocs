import 'package:flutter/material.dart';
import '../classes/dice_row_state.dart';

class DiceInputRow extends StatefulWidget {
  DiceInputRow(this.includeRollBox, this.onDismissed);
  final DiceRowState diceRowState = DiceRowState(rollBox: true, dropdownValue: null);
  final bool includeRollBox;
  final Function onDismissed;
  final TextEditingController numOfDiceController = TextEditingController();
  final TextEditingController modifierController = TextEditingController();

  @override
  _DiceInputRowState createState() => _DiceInputRowState();
}

class _DiceInputRowState extends State<DiceInputRow> {
  bool rollBox = true;
  String dropdownValue;
  TextStyle style;

  @override
  Widget build(BuildContext context) {

    style = TextStyle(color: Theme.of(context).primaryColor, fontSize: 18);
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => widget.onDismissed(widget),
      background: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(5)),
              child: Center(
                  child: ListTile(
                      trailing: Icon(Icons.delete,
                          color: Colors.black54, size: 30))))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.black),
              color: Colors.black38),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    style: style,
                    controller: widget.numOfDiceController,
                    decoration: InputDecoration(
                      hintText: '# of Dice',
                      hintStyle: style,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.close),
                ),
                Flexible(
                  child: DropdownButton<String>(
                    style: style,
                    hint: Text(
                      'Type',
                      style: style,
                    ),
                    value: dropdownValue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                        widget.diceRowState.dropdownValue = newValue;
                      });
                    },
                    items: <String>['d2', 'd4', 'd6', 'd8', 'd10', 'd12', 'd20']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.add),
                ),
                Flexible(
                    child: TextField(
                  style: style,
                  controller: widget.modifierController,
                  decoration:
                      InputDecoration(hintText: 'Modifier', hintStyle: style),
                )),
                widget.includeRollBox
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            'Roll',
                            style: style,
                          ),
                          Checkbox(
                            value: rollBox,
                            onChanged: (bool value) {
                              setState(() {
                                rollBox = value;
                                widget.diceRowState.rollBox = value;
                              });
                            },
                          ),
                        ],
                      )
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
