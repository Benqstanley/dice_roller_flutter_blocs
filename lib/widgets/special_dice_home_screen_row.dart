import 'package:flutter/material.dart';
import '../classes/dice.dart';

class SpecialDiceHomeScreenRow extends StatefulWidget {

  final CollectionOfDice collection;
  final Function delete;
  final SpecialDiceHomeRowState state = SpecialDiceHomeRowState();

  SpecialDiceHomeScreenRow(this.collection, this.delete);

  @override
  _SpecialDiceHomeScreenRowState createState() => _SpecialDiceHomeScreenRowState();
}

class _SpecialDiceHomeScreenRowState extends State<SpecialDiceHomeScreenRow> {
  TextStyle titleStyle;
  TextStyle subtitleStyle;

  Widget createListTile(CollectionOfDice dice) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => widget.delete(widget),
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
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    titleStyle = TextStyle(color: Theme.of(context).primaryColor);
    subtitleStyle = TextStyle(color: Theme.of(context).primaryColorLight);
    return createListTile(widget.collection);
  }
}

class SpecialDiceHomeRowState{
  bool rollBox;
}