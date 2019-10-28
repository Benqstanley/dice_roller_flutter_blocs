import 'package:flutter/material.dart';
import 'dart:async';


import './bloc_parent.dart';

import '../events/history_events.dart';
import '../events/events.dart';



class HistoryBloc extends BlocParent {
  List<Widget> history = [];

  final _historyScreenStateController =
      StreamController<List<Widget>>.broadcast();

  StreamSink<List<Widget>> get _inHistoryScreenState =>
      _historyScreenStateController.sink;

  Stream<List<Widget>> get historyListStream =>
      _historyScreenStateController.stream;

  final _historyEventsStreamController =
      StreamController<HistoryEvents>.broadcast();

  StreamSink<HistoryEvents> get historyEventsSink =>
      _historyEventsStreamController.sink;

  HistoryBloc() {
    _historyEventsStreamController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _historyScreenStateController.close();
    _historyEventsStreamController.close();
  }

  void _mapEventToState(Events event) {
    if (event is UpdateHistory) {
      history.addAll(event.newHistory);
    } else if (event is RetrieveHistory) {
      _inHistoryScreenState.add(history);
    } else if (event is DeleteHistory){
      history.clear();
    }
  }
}
