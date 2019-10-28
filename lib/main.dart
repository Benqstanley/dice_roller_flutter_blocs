import 'package:flutter/material.dart';
import './utility/screen_building_utility.dart';

import './classes/dice.dart';

import './widgets/dice_input_row.dart';
import './widgets/inherit_dice_input.dart';

import './widgets/main_drawer.dart';

import './screens/create_special_screen.dart';
import './screens/session_history_screen.dart';
import './screens/view_specials_screen.dart';
import './blocs/bloc_controller.dart';
import './blocs/home_bloc.dart';
import './events/home_events.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _blocController = BlocController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.grey,
        textTheme: TextTheme(
            title: TextStyle(color: Colors.white),
            body1: TextStyle(color: Colors.white, fontSize: 17)),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Dice Roller', controller: _blocController),
      routes: {
        SessionHistoryScreen.routeName: (ctx) =>
            SessionHistoryScreen(_blocController),
        CreateSpecialScreen.routeName: (ctx) =>
            CreateSpecialScreen(_blocController),
        ViewSpecialsScreen.routeName: (ctx) =>
            ViewSpecialsScreen(_blocController),
      },
    );
  }

  @override
  void dispose() {
    _blocController.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.controller});

  final BlocController controller;

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool includeRollBox = false;
  List<Widget> diceOnScreen = [];
  List<Widget> normalDiceOnScreen = [];
  List<Widget> specialDiceOnScreen = [];
  List<CollectionOfDice> specialsOnScreen = List<CollectionOfDice>();
  List<DiceInputRow> diceRows = List<DiceInputRow>();
  List<Dice> diceToRoll;
  List<Widget> diceOutputs;
  BuildContext buildContext;
  HomeBloc homeBloc;

  void onDismiss(DiceInputRow row) {
    homeBloc.homeEventsSink.add(HomeDeleteNormalRowEvent(row));
    setState(() {
      normalDiceOnScreen.remove(row);
    });
  }

  @override
  void initState() {
    homeBloc = widget.controller.homeBloc;
    homeBloc.rollListStream.listen(_showDiceRoll);
    homeBloc.specialRowListStream.listen((specialDiceRows) {
      specialDiceOnScreen = specialDiceRows;
      if (mounted) {
        setState(() {
          diceOnScreen = List<Widget>();
          diceOnScreen.addAll(specialDiceOnScreen);
          diceOnScreen.addAll(normalDiceOnScreen);
        });
      }
    });
    homeBloc.rowListStream.listen((_) {
      normalDiceOnScreen = _;
      print('normalDiceOnScreen $normalDiceOnScreen');
      if (mounted) {
        setState(() {
          diceOnScreen = List<Widget>();
          diceOnScreen.addAll(specialDiceOnScreen);
          diceOnScreen.addAll(normalDiceOnScreen);
        });
      }
    });
    homeBloc.homeEventsSink.add(HomeInitializeScreenEvent());
    super.initState();
  }

  void _showDiceRoll(List<Widget> outputs) {
    if (outputs.length > 0) {
      print('current buildContext value: $context');
      context != null
          ? showModalBottomSheet(
              context: context,
              builder: (_) {
                return Column(
                  children: outputs,
                );
              })
          : print(context);
    }
  }

  Widget bodyOfApp(String title) {
    return Scaffold(
        drawer: MainDrawer(widget.controller),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(title),
        ),
        backgroundColor: Colors.grey,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.black))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Center(
                        child: Text('Dice To Roll'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: HomeListView(diceOnScreen: diceOnScreen, homeBloc: homeBloc,),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Clear'),
                    onPressed: () =>
                        homeBloc.homeEventsSink.add(HomeClearScreenEvent()),
                  ),
                  RaisedButton(
                    child: Text('Add Row'),
                    onPressed: () =>
                        homeBloc.homeEventsSink.add(HomeAddRowEvent()),
                  ),
                  RaisedButton(
                    child: Text('Roll'),
                    onPressed: () {
                      homeBloc.homeEventsSink.add(HomeRollDiceEvent());
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    includeRollBox = MediaQuery.of(context).size.width > 400;
    homeBloc.includeRollBox = includeRollBox;
    return InheritDiceInput(
        child: platformSpecificWidget(bodyOfApp(widget.title)));
  }
}

class HomeListView extends StatelessWidget {
  const HomeListView({
    Key key,
    @required this.diceOnScreen,
    @required this.homeBloc,
  }) : super(key: key);
  final HomeBloc homeBloc;
  final List<Widget> diceOnScreen;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: diceOnScreen.length,
      itemBuilder: (ctx, index) => diceOnScreen[index],
    );
  }
}
