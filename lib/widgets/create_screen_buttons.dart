import 'package:flutter/material.dart';


class CreateScreenButtons extends StatelessWidget {
  final Function reset;
  final Function addRow;
  final Function save;

  CreateScreenButtons(this.reset, this.addRow, this.save);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(child: Text('Clear'),
            onPressed: reset,),
          RaisedButton(child: Text('Add Row'),
            onPressed: addRow,),
          RaisedButton(child: Text('Save'),
            onPressed: () {save(context);},)
        ]);
  }
}
