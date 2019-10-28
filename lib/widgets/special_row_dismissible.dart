import 'package:flutter/material.dart';
import '../classes/dice.dart';

class SpecialRowDismissible extends StatefulWidget {
  final Function pendingDelete;
  final int index;
  final CollectionOfDice dice;

  SpecialRowDismissible({this.dice, this.pendingDelete, this.index});

  @override
  _SpecialRowDismissibleState createState() => _SpecialRowDismissibleState();
}

class _SpecialRowDismissibleState extends State<SpecialRowDismissible> {
  TextStyle titleStyle;
  TextStyle subtitleStyle;

  @override
  Widget build(BuildContext context) {
    titleStyle = TextStyle(color: Theme.of(context).primaryColor);
    subtitleStyle = TextStyle(color: Theme.of(context).primaryColorLight);
    return createListTile(widget.dice, widget.index);
  }

  Widget createListTile(CollectionOfDice dice, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        widget.pendingDelete(index, context);
      },
      background: Card(
        color: Colors.red,
        child: Center(
          child: ListTile(
            trailing: Icon(
              Icons.delete,
              color: Colors.black54,
              size: 30,
            ),
          ),
        ),
      ),
      child: Card(
        color: Colors.black38,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(dice.name, style: titleStyle),
              subtitle: Text(dice.createSubtitle(), style: subtitleStyle),
              trailing: Checkbox(
                  value: dice.isSelected,
                  onChanged: (newValue) {
                    setState(() {
                      dice.isSelected = newValue;
                    });
                  }),
            )),
      ),
    );
  }
}
