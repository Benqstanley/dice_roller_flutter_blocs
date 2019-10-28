import 'package:flutter/material.dart';
import '../utility/screen_building_utility.dart';
import '../blocs/view_specials_bloc.dart';
import '../blocs/bloc_controller.dart';

import '../classes/dice.dart';
import '../events/view_events.dart';

import '../widgets/special_row_dismissible.dart';

import '../widgets/main_drawer.dart';

class ViewSpecialsScreen extends StatefulWidget {
  final BlocController controller;
  static const String routeName = '/view_specials';
  static const String title = 'View Special Collections';

  ViewSpecialsScreen(this.controller);

  @override
  _ViewSpecialsScreenState createState() => _ViewSpecialsScreenState();
}

class _ViewSpecialsScreenState extends State<ViewSpecialsScreen> {
  ViewSpecialsBloc viewSpecialsBloc;
  BuildContext context;
  final List<CollectionOfDice> savedList = List<CollectionOfDice>();
  TextStyle titleStyle;
  TextStyle subtitleStyle;
  final List<CollectionOfDice> toSendHome = List<CollectionOfDice>();
  final List<Widget> savedTiles = List<Widget>();

  Widget bodyOfApp(String title, BuildContext context) {
    return Scaffold(
      body: bodyOfViewScreen(),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(widget.controller),
    );
  }

  void pendingDelete(int index, BuildContext context) {
    CollectionOfDice deleted = savedList[index];
    setState(() {
      savedList.removeAt(index);
    });
    Scaffold.of(context)
        .showSnackBar(SnackBar(
            duration: Duration(seconds: 20),
            content: Text(
              '${deleted.name} Deleted',
              style: TextStyle(fontSize: 20),
            ),
            action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  setState(() {
                    savedList.insert(index, deleted);
                  });
                })))
        .closed
        .then((reason) {
      if (reason != SnackBarClosedReason.action) {
        viewSpecialsBloc.inViewEvents.add(ViewDeleteSpecialEvents(index));
      }
    });
  }

  Widget createListTile(CollectionOfDice dice, int index) {
    return Dismissible(
      key: Key(dice.toString()),
      onDismissed: (direction) {
        pendingDelete(index, context);
      },
      background: Card(
          color: Colors.red,
          child: Center(
              child: ListTile(
            trailing: Icon(Icons.delete),
          ))),
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


  @override
  void initState() {
    viewSpecialsBloc = widget.controller.viewSpecialsBloc;
    viewSpecialsBloc.inViewEvents.add(ViewPopulateScreenEvents());
    viewSpecialsBloc.savedListStream.listen((values) {
      if (mounted) {
        setState(() {
          savedList.addAll(values);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    titleStyle = TextStyle(color: Theme.of(context).primaryColor);
    subtitleStyle = TextStyle(color: Theme.of(context).primaryColorLight);
    return platformSpecificWidget(bodyOfApp(ViewSpecialsScreen.title, context));
  }

  Widget bodyOfViewScreen() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Your Saved Collections'),
              )),
              Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: savedList.length,
                  itemBuilder: (bctx, index) => SpecialRowDismissible(
                    dice: savedList[index],
                    index: index,
                    pendingDelete: pendingDelete,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text('Add Selection To Screen'),
                  onPressed: _sendSpecialsToHome,
                )
              ],
            )),
      ],
    );
  }

  void _createListToSendHome() {
    toSendHome.clear();
    for (CollectionOfDice collection in savedList) {
      if (collection.isSelected) {
        toSendHome.add(collection);
      }
    }
    print(toSendHome);
  }

  void _sendSpecialsToHome() {
    _createListToSendHome();
    viewSpecialsBloc.inViewEvents.add(ViewSendSpecialsToHomeBlocEvents(toSendHome));
    Navigator.of(context).pushReplacementNamed('/');
  }
}
