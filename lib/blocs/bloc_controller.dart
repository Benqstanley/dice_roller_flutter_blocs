

import './history_bloc.dart';
import './create_collection_bloc.dart';
import './home_bloc.dart';
import './view_specials_bloc.dart';

import 'dart:async';


import '../events/events.dart';

import '../events/history_events.dart';

class BlocController{
  HomeBloc homeBloc;
  final HistoryBloc historyBloc = HistoryBloc();
  CreateCollectionBloc createCollectionBloc;
  ViewSpecialsBloc viewSpecialsBloc;


  final StreamController<Events> _eventsController = StreamController<Events>.broadcast();
  StreamSink<Events> get eventsSink => _eventsController.sink;

  BlocController(){
    _eventsController.stream.listen(_mapEventToBloc);
    homeBloc = HomeBloc(this);
    createCollectionBloc = CreateCollectionBloc(this);
    viewSpecialsBloc = ViewSpecialsBloc(this);
  }

  void _mapEventToBloc(Events event){
    if(event is HistoryEvents){
      historyBloc.historyEventsSink.add(event);
    }
  }

  void dispose(){
    _eventsController.close();
  }

}