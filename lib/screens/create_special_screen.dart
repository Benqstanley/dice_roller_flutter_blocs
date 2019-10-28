import 'package:flutter/material.dart';
import '../utility/screen_building_utility.dart';

import '../blocs/create_collection_bloc.dart';
import '../blocs/bloc_controller.dart';
import '../events/create_events.dart';
import '../events/events.dart';

import '../widgets/main_drawer.dart';
import '../widgets/dice_input_row.dart';
import '../widgets/create_screen_buttons.dart';

import '../screens/view_specials_screen.dart';

class CreateSpecialScreen extends StatefulWidget {
  final BlocController controller;
  static const String routeName = '/create_special';
  static const String title = 'Create a Special Collection';

  CreateSpecialScreen(this.controller);

  @override
  _CreateSpecialScreenState createState() => _CreateSpecialScreenState();
}

class _CreateSpecialScreenState extends State<CreateSpecialScreen> {
  final TextEditingController nameController = TextEditingController();
  CreateCollectionBloc createCollectionBloc;

  @override
  void initState() {
    print('initState');
    super.initState();
    createCollectionBloc = widget.controller.createCollectionBloc;
    _initializeScreen();

    createCollectionBloc.context = context;
    createCollectionBloc.getSaveStatus.listen(_navigateAway);
  }

  void _resetScreen() {
    nameController.clear();
    createCollectionBloc.createEventsSink.add(CreateClearScreenEvent());
  }

  void _addRowToScreen() {
    createCollectionBloc.createEventsSink.add(CreateAddRowEvent());
  }

  void _initializeScreen() {
    _resetScreen();
  }

  BuildContext contextForSnackBar;
  void _saveCollection(BuildContext context) {
    contextForSnackBar = context;
    if (!_validateCollection()) {
      _collectionIsInvalid();
    } else {
      createCollectionBloc.createEventsSink.add(SaveCollectionEvent(
          name: nameController.text.trim(),
          onInvalidCollection: _collectionIsInvalid,
          context: context));
    }
  }

  void _navigateAway(Events event) {
    print(event);
    if (event is SaveSucceeded) {
      Navigator.of(context).pushReplacementNamed(ViewSpecialsScreen.routeName);
    } else if (event is SaveFailed) {
      _collectionIsInvalid(message: event.description);
    }
  }

  void _collectionIsInvalid({String message}) {
    if (message == null) {
      Scaffold.of(contextForSnackBar).showSnackBar(SnackBar(
          content: Text(
              'The Collection Needs a Name and at least one non-empty Dice Input')));
    } else {
      Scaffold.of(contextForSnackBar).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  bool _validateCollection() {
    bool hasName = nameController.text.trim().isNotEmpty;
    return hasName;
  }

  List<DiceInputRow> diceInCollection = List<DiceInputRow>();

  Widget bodyOfApp(String title) {
    print('body of App ${nameController.text}');
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(widget.controller),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Container(
                color: Colors.black38,
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 6.0),
                child: TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      labelText: 'Name of Collection',
                      labelStyle: TextStyle(
                          fontSize: 20, color: Theme.of(context).accentColor)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 6.0),
              child: Center(
                child: Text('Dice In Collection'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                height: 1,
                color: Colors.black,
                width: double.infinity,
              ),
            ),
            StreamBuilder(
              stream: createCollectionBloc.rowListStream,
              builder: (ctx, snapshot) => snapshot.data != null
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (ctx, index) => snapshot.data[index],
                      ),
                    )
                  : Container(height: 0, width: 0),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreateScreenButtons(
                    _resetScreen, _addRowToScreen, _saveCollection)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build ${nameController.text}');
    return platformSpecificWidget(bodyOfApp(CreateSpecialScreen.title));
  }
}
