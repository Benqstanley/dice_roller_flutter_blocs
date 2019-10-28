import 'package:dice_roller/classes/dice_row_state.dart';
import 'package:flutter/material.dart';
import './bloc_parent.dart';
import 'dart:async';

import '../events/events.dart';
import '../events/create_events.dart';

import '../classes/dice.dart';

import '../widgets/dice_input_row.dart';

import './bloc_controller.dart';

class CreateCollectionBloc extends BlocParent {
  BuildContext context;
  final BlocController controller;
  List<DiceInputRow> _diceForCollection = List<DiceInputRow>();

  final _saveStatusIndicator = StreamController<CreateEvents>.broadcast();

  Stream<Events> get getSaveStatus => _saveStatusIndicator.stream;

  StreamSink<Events> get _inSaveStatus => _saveStatusIndicator.sink;

  final _createScreenSaveIndicator = StreamController<bool>.broadcast();

  StreamSink<bool> get _inSave => _createScreenSaveIndicator.sink;

  Stream<bool> get saveIndicatorStream => _createScreenSaveIndicator.stream;

  final _createScreenStateController =
      StreamController<List<DiceInputRow>>.broadcast();

  StreamSink<List<DiceInputRow>> get _inCreateScreenState =>
      _createScreenStateController.sink;

  Stream<List<DiceInputRow>> get rowListStream =>
      _createScreenStateController.stream;

  final _createEventsController = StreamController<Events>.broadcast();

  StreamSink<Events> get createEventsSink => _createEventsController.sink;

  void dispose() {
    _createScreenStateController.close();
    _createScreenSaveIndicator.close();
    _createEventsController.close();
    _saveStatusIndicator.close();
  }

  CreateCollectionBloc(this.controller) {
    _createEventsController.stream.listen(_mapEventsToState);
  }

  void _onDismiss(DiceInputRow toDelete) {
    _diceForCollection.remove(toDelete);
    _inCreateScreenState.add(_diceForCollection);
  }

  void _mapEventsToState(Events event) async {
    if (event is CreateAddRowEvent) {
      _diceForCollection.add(DiceInputRow(false, _onDismiss));
      _inCreateScreenState.add(_diceForCollection);
    } else if (event is CreateClearScreenEvent) {
      _diceForCollection = [DiceInputRow(false, _onDismiss)];
      _inCreateScreenState.add(_diceForCollection);
    } else if (event is SaveCollectionEvent) {
      List<String> names = await controller.viewSpecialsBloc.savedFileList;
      String path = await controller.viewSpecialsBloc.localPath;
      if (!names.contains('$path/${event.name}.txt')) {
        CollectionOfDice toSave = _createCollectionOfDice(event.name);
        if (toSave != null) {
          try {
            controller.viewSpecialsBloc
                .getFutureFile(name: toSave.name)
                .then((file) {
              file.writeAsString(toSave.toString());
              _inSaveStatus.add(SaveSucceeded());
            });
          } catch (e) {
            _inSave.add(false);
          }
        }
      } else {
        _inSaveStatus.add(SaveFailed(description: 'A File With This Name Already Exists'));
      }
    } else {
      _inSaveStatus
          .add(SaveFailed(description: 'A File With This Name Already Exists'));
    }
  }

  CollectionOfDice _createCollectionOfDice(String name) {
    List<Dice> list = _prepareSaveList();
    if (list == null) {
      return null;
    }
    return CollectionOfDice(listOfDice: list, name: name);
  }

  List<Dice> _prepareSaveList() {
    var saveList = _diceForCollection.where((dice) {
      DiceRowState diceRowState = dice.diceRowState;
      bool test = dice.numOfDiceController.text.isNotEmpty &&
          diceRowState.dropdownValue != null;
      return test;
    }).toList();
    if (saveList != null) {
      if (saveList.isEmpty) {
        return null;
      }
    } else if (saveList == null) {
      return null;
    }
    return _createDiceCollectionList(saveList);
  }

  List<Dice> _createDiceCollectionList(List<DiceInputRow> saveList) {
    var collection = saveList.map((dice) => _mapToDice(dice)).toList();
    return collection;
  }

  Dice _mapToDice(DiceInputRow dice) {
    int numberOfDice;
    String type;
    int modifier;
    DiceRowState diceRowState = dice.diceRowState;
    if (diceRowState.rollBox) {
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
