import 'package:flutter/material.dart';
import '../utility/screen_building_utility.dart';

import '../blocs/history_bloc.dart';
import '../blocs/bloc_controller.dart';
import '../events/history_events.dart';

import '../widgets/main_drawer.dart';

class SessionHistoryScreen extends StatefulWidget {
  final BlocController controller;
  static const String routeName = '/session_history';
  static const String title = 'View Session History';

  SessionHistoryScreen(this.controller);

  @override
  _SessionHistoryScreenState createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  final List<Widget> history = [];
  HistoryBloc historyBloc;

  void eraseHistory() {
    historyBloc.historyEventsSink.add(DeleteHistory());
    setState(() {
      history.clear();
    });
  }

  Widget bodyOfApp(String title, BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: history.length != 0
                ? ListView.builder(
                    itemCount: history != null ? history.length : 0,
                    itemBuilder: (ctx, index) => history[index],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        Container(
                          child: Text('There\'s Nothing Here\!',
                              style: TextStyle(fontSize: 20)),
                          padding: EdgeInsets.all(8.0),
                        ),
                        FlatButton(
                          child: Text('Go Roll Some Dice!',
                              style: TextStyle(fontSize: 20)),
                          onPressed: () =>
                              Navigator.of(context).pushReplacementNamed('/'),
                        )
                      ]),
          ),
          Container(
            decoration: BoxDecoration(border: Border(top: BorderSide())),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text('Erase History'),
                    onPressed: eraseHistory,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: MainDrawer(widget.controller),
    );
  }

  void setScreenContent(List<Widget> input) {
    history.addAll(input);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    historyBloc = widget.controller.historyBloc;
    historyBloc.historyListStream.listen(setScreenContent);
    historyBloc.historyEventsSink.add(RetrieveHistory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return platformSpecificWidget(
        bodyOfApp(SessionHistoryScreen.title, context));
  }
}
