import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import '../screens/create_special_screen.dart';
import '../screens/session_history_screen.dart';
import '../screens/view_specials_screen.dart';

import '../blocs/home_bloc.dart';
import '../blocs/bloc_controller.dart';
import '../events/home_events.dart';



class MainDrawer extends StatefulWidget {
  final BlocController controller;

  MainDrawer(this.controller);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  double statusBarHeight;

  @override
  Widget build(BuildContext context) {
    statusBarHeight = MediaQuery.of(context).padding.top;
    return Drawer(
      child: Container(
        color: Colors.black54,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: AppBar().preferredSize.height + statusBarHeight,
              width: double.infinity,
              child: Container(
                  child: Padding(
                    padding: Platform.isIOS
                        ? const EdgeInsets.all(8.0)
                        : EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                            top: 8.0 + statusBarHeight),
                    child: Center(
                        child: Text('Dice Roller',
                            style: TextStyle(fontSize: 26))),
                  ),
                  color: Theme.of(context).primaryColor),
            ),
            MainDrawerItem(Icons.home, 'Home', '/', context),
            Divider(),
            MainDrawerItem(Icons.edit, 'Create Special',
                CreateSpecialScreen.routeName, context),
            Divider(),
            MainDrawerItem(Icons.attach_file, 'Add Special',
                ViewSpecialsScreen.routeName, context),
            Divider(),
            MainDrawerItem(Icons.schedule, 'Session History',
                SessionHistoryScreen.routeName, context),
            Divider(),
            MainDrawerSwitch(widget.controller.homeBloc),
            Divider(),
          ],
        ),
      ),
    );
  }
}

class MainDrawerItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final String routeName;
  final BuildContext context;
  final TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20);

  void pushScreen() {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  MainDrawerItem(this.icon, this.text, this.routeName, this.context);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: ListTile(
            onTap: pushScreen,
            leading: Icon(icon),
            title: Text(
              text,
              style: textStyle,
            )));
  }
}

class MainDrawerSwitch extends StatefulWidget {
  final HomeBloc homeBloc;

  MainDrawerSwitch(this.homeBloc);

  @override
  _MainDrawerSwitchState createState() => _MainDrawerSwitchState();
}

class _MainDrawerSwitchState extends State<MainDrawerSwitch> {
  bool detailedRoll;
  final TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 20);

  @override
  Widget build(BuildContext context) {
    detailedRoll = widget.homeBloc.detailedRolls;
    return ListTile(
        leading: Icon(Icons.assignment),
        trailing: Platform.isIOS
            ? CupertinoSwitch(
                value: detailedRoll,
                onChanged: (value) {
                  setState(() {
                    detailedRoll = value;
                    widget.homeBloc.homeEventsSink
                        .add(HomeDetailedRollEvent(detailedRoll));
                  });
                },
              )
            : Switch(
                value: detailedRoll,
                onChanged: (value) {
                  setState(() {
                    detailedRoll = value;
                    widget.homeBloc.homeEventsSink
                        .add(HomeDetailedRollEvent(detailedRoll));
                  });
                },
              ),
        title: Text(
          'Detailed Roll',
          style: textStyle,
        ));
  }
}
