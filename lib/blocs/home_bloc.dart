import 'package:dice_roller/classes/dice_row_state.dart';
import 'package:flutter/material.dart';
import './bloc_parent.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';


import '../events/events.dart';
import '../events/home_events.dart';
import '../classes/dice.dart';
import '../blocs/bloc_controller.dart';

import '../widgets/dice_input_row.dart';
import '../widgets/dice_output_row.dart';
import '../widgets/special_dice_home_screen_row.dart';

class HomeBloc extends BlocParent {
  BlocController controller;
  List<DiceInputRow> _diceOnHomeScreen = [];
  List<Dice> _diceToRoll = [];
  List<Widget> _diceOutputs = [];
  List<CollectionOfDice> _specialsToRoll = [];
  List<CollectionOfDice> specialsToDisplayOnHome = List<CollectionOfDice>();
  List<SpecialDiceHomeScreenRow> _specialCollectionRowsForHome = [];
  bool detailedRolls;
  bool includeRollBox;
  SharedPreferences prefs;
  BuildContext context;


  final _homeScreenNormalController =
      StreamController<List<DiceInputRow>>.broadcast();

  StreamSink<List<DiceInputRow>> get _inScreenState =>
      _homeScreenNormalController.sink;

  Stream<List<DiceInputRow>> get rowListStream =>
      _homeScreenNormalController.stream;

  final _homeScreenSpecialController =
      StreamController<List<SpecialDiceHomeScreenRow>>.broadcast();

  StreamSink<List<SpecialDiceHomeScreenRow>> get _inSpecialsScreenState =>
      _homeScreenSpecialController.sink;

  Stream<List<SpecialDiceHomeScreenRow>> get specialRowListStream =>
      _homeScreenSpecialController.stream;

  final _diceRollStateController = StreamController<List<Widget>>.broadcast();

  StreamSink<List<Widget>> get _inRollScreenState =>
      _diceRollStateController.sink;

  Stream<List<Widget>> get rollListStream => _diceRollStateController.stream;

  final _homeScreenEventsController = StreamController<Events>.broadcast();

  StreamSink<Events> get homeEventsSink => _homeScreenEventsController.sink;

  void dispose() {
    _homeScreenNormalController.close();
    _homeScreenSpecialController.close();
    _homeScreenEventsController.close();
    _diceRollStateController.close();
  }

  HomeBloc(this.controller) {
    _homeScreenEventsController.stream.listen(_mapEventToState);
    _getDetailedStatusFromSharedPref();
  }

  void _getDetailedStatusFromSharedPref() async{
    prefs = await SharedPreferences.getInstance();
    detailedRolls = (prefs.getBool('detailed_rolls') ?? false);
  }

  void _onDismiss(DiceInputRow row){
    _diceOnHomeScreen.remove(row);
    _inScreenState.add(_diceOnHomeScreen);
  }


  void _mapEventToState(Events event) {
    if (event is HomeAddRowEvent) {
      _diceOnHomeScreen.add(DiceInputRow(includeRollBox, _onDismiss));
      _inScreenState.add(_diceOnHomeScreen);
    } else if (event is HomeClearScreenEvent) {
      _diceOnHomeScreen.clear();
      _diceOnHomeScreen = [DiceInputRow(includeRollBox, _onDismiss)];
      specialsToDisplayOnHome.clear();
      _specialCollectionRowsForHome.clear();
      _inSpecialsScreenState.add(_specialCollectionRowsForHome);
      _inScreenState.add(_diceOnHomeScreen);
    } else if (event is HomeInitializeScreenEvent) {
      if (_diceOnHomeScreen.isEmpty) {
        _diceOnHomeScreen = [DiceInputRow(includeRollBox, _onDismiss)];
      }
      _inScreenState.add(_diceOnHomeScreen);
      _createSpecialRows();
      _inSpecialsScreenState.add(_specialCollectionRowsForHome);
    } else if (event is HomeRollDiceEvent) {
      _prepareDiceToRoll();
      _inRollScreenState.add(_diceOutputs);
      controller.historyBloc.history.addAll(_diceOutputs);
    } else if (event is HomeDetailedRollEvent){
      detailedRolls = event.payload;
      prefs.setBool('detailed_rolls', event.payload);
    } else if(event is HomeDeleteNormalRowEvent){
      _diceOnHomeScreen.remove(event.payload);
    }
  }

  void delete(SpecialDiceHomeScreenRow row) {
    int i = _specialCollectionRowsForHome.indexOf(row);
    specialsToDisplayOnHome.removeAt(i);
    _specialCollectionRowsForHome.remove(row);
    _inSpecialsScreenState.add(_specialCollectionRowsForHome);
  }

  void _createSpecialRows() {
    _specialCollectionRowsForHome = specialsToDisplayOnHome
        .map((special) => SpecialDiceHomeScreenRow(special, delete))
        .toList();
  }

  void _prepareDiceToRoll() {
    _diceToRoll.clear();
    _diceOutputs.clear();
    _specialsToRoll.clear();

    for (int i = 0; i < _specialCollectionRowsForHome.length; i++) {
      SpecialDiceHomeScreenRow row = _specialCollectionRowsForHome[i];
      if (row.collection.isSelected) {
        CollectionOfDice collectionOfDice = specialsToDisplayOnHome[i];
        _specialsToRoll.add(collectionOfDice);
      }
    }

    for (DiceInputRow dice in _diceOnHomeScreen) {
      if (_mapToDice(dice) != null) {
        _diceToRoll.add(_mapToDice(dice));
      }
    }
    if (_specialsToRoll.length > 0) {
      _rollSpecialDice();
    }

    if (_diceToRoll.length > 0) {
      _rollDice();
    }
  }

  void _rollSpecialDice() {
    if(!detailedRolls) {
      for (CollectionOfDice collection in _specialsToRoll) {
        _diceOutputs.add(
          SpecialDiceOutputRow(
            collectionName: collection.name,
            rollInfo: collection.rollCollections(),
          ),
        );
      }
    }else{
      for (CollectionOfDice collection in _specialsToRoll) {
        _diceOutputs.add(
          SpecialDiceOutputRow(
            collectionName: collection.name,
            rollInfo: collection.rollCollectionsDetailed(),
          ),
        );
      }
    }
  }

  void _rollDice() {
    if(!detailedRolls) {
      for (Dice dice in _diceToRoll) {
        _diceOutputs.add(DiceOutputRow(dice.toString(), dice.rollDiceString()));
      }
    }else{
      for (Dice dice in _diceToRoll) {
        _diceOutputs.add(DiceOutputRow(dice.toString(), dice.rollDiceDetailed()));
      }
    }
  }

  Dice _mapToDice(DiceInputRow dice) {
    int numberOfDice;
    String type;
    int modifier;
    DiceRowState diceRowState = dice.diceRowState;
    if (diceRowState.rollBox == true) {
      if (dice.numOfDiceController.text.isNotEmpty &&
          diceRowState.dropdownValue != null) {
        numberOfDice = int.parse(dice.numOfDiceController.text);
        type = diceRowState.dropdownValue;
        modifier = int.tryParse(dice.modifierController.text);
        if (modifier == null) modifier = 0;
        return Dice(type, numberOfDice, modifier);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
