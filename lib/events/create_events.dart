
import './events.dart';
import 'package:flutter/material.dart';

mixin CreateEvents on Events {}

class CreateClearScreenEvent extends Events with CreateEvents {}

class CreateAddRowEvent extends Events with CreateEvents {}

class SaveCollectionEvent extends Events with CreateEvents {
  String name;
  Function onInvalidCollection;
  BuildContext context;

  SaveCollectionEvent(
      {@required this.name,
      @required this.onInvalidCollection,
      @required this.context});
}

class SaveFailed extends Events with CreateEvents{
  String description;
  SaveFailed({this.description});
}

class SaveSucceeded extends Events with CreateEvents{

}
