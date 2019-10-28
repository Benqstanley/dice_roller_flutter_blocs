import 'dart:async';
import './bloc_parent.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../events/events.dart';
import '../events/view_events.dart';
import '../classes/dice.dart';
import './bloc_controller.dart';



class ViewSpecialsBloc extends BlocParent {
  final BlocController controller;
  List<String> _savedFileNames = List<String>();
  List<CollectionOfDice> _savedCollections = List<CollectionOfDice>();
  List<CollectionOfDice> _collectionsToDisplayOnHome = List<CollectionOfDice>();


  List<File> _savedFiles;
  String _localFilePath;

  ViewSpecialsBloc(this.controller){
    _viewEventsController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _viewScreenStateController.close();
    _viewEventsController.close();
  }

  final _viewScreenStateController =
      StreamController<List<CollectionOfDice>>.broadcast();

  Stream<List<CollectionOfDice>> get savedListStream =>
      _viewScreenStateController.stream;

  StreamSink<List<CollectionOfDice>> get _inSavedCollections =>
      _viewScreenStateController.sink;

  final _viewEventsController =
  StreamController<Events>.broadcast();

  StreamSink<Events> get inViewEvents => _viewEventsController.sink;

  void _mapEventToState(Events event) {
    if (event is ViewPopulateScreenEvents) {
      populateListsForViewScreen()
          .then((values) => _inSavedCollections.add(values));
    } else if (event is ViewSendSpecialsToHomeBlocEvents) {
      _collectionsToDisplayOnHome.addAll(event.payload);
      print('trying');
      controller.homeBloc.specialsToDisplayOnHome.addAll(event.payload);
    } else if(event is ViewDeleteSpecialEvents){
      int index = event.index;
      _savedFileNames.removeAt(index);
      _savedCollections.removeAt(index);
      File toDelete = _savedFiles[index];
      _savedFiles.removeAt(index);
      toDelete.delete();
    }
  }


  Future<List<CollectionOfDice>> populateListsForViewScreen() async{
    _savedCollections != null ? _savedCollections.clear() : _savedCollections = List<CollectionOfDice>();
    _savedFiles != null ? _savedFiles.clear() : _savedFiles = List<File>();
    _savedFileNames != null ? _savedFileNames.clear() : _savedFileNames = List<String>();
    await getDocList();
    await getSavedCollections(_savedFiles);
    return _savedCollections;
  }

  Future<List<String>> get savedFileList async{
    if(_savedFiles != null){
      if(_savedFileNames.isEmpty){
        await getDocList();
      }
    }else{
      await getDocList();
    }
    return _savedFileNames;
  }

  Future<String> get localPath async {
    if(_localFilePath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _localFilePath = directory.path;
    }
    return _localFilePath;
  }

  Future<File> getFutureFile({String name, String pathName}) async {
    if (pathName != null) {
      try {
        return File(pathName);
      }catch(e){
        print(e);
      }
    }
    final path = await localPath;
    try {
      return File('$path/$name.txt');
    }catch(e){
      print(e);
    }
    return null;
  }

  Future<List<File>> getDocList() async {
    try {
      final path = await localPath;
      final directory = Directory(path);
      _savedFileNames = List<String>();
      List<FileSystemEntity> listFSE = directory.listSync();
      listFSE = listFSE.where((test) => test.path.contains('.txt')).toList();
      _savedFiles = listFSE.map((fSE) => File(fSE.path)).toList();
      _savedFileNames = listFSE.map((file) => file.path).toList();
      print(_savedFileNames);
      return _savedFiles;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<CollectionOfDice>> getSavedCollections(List<File> files) async {
    for(File file in files){
      String contents = await file.readAsString();
      _savedCollections.add(CollectionOfDice.parseFromJSON(contents));
    }
    return _savedCollections;
  }

  Future<String> getJSONDescriptionsFromFiles(String pathName) async{
    print('trying');
    File file = await getFutureFile(pathName: pathName);
    String contents = await file.readAsString();
    return contents;

  }
}
