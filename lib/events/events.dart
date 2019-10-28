import '../classes/dice.dart';

abstract class Events{
  
}

class InitializeHomeScreenEvent extends Events{

}

class AddRowEvent extends Events{
  bool includeRollBox;

  AddRowEvent(this.includeRollBox);
}

class RollDiceEvent extends Events{
  
}


class ClearScreenEvent extends Events{
  bool isHomeScreen;

  ClearScreenEvent(this.isHomeScreen);
}

class InitializeCreateScreenEvent extends Events{

}

class PopulateCollectionsScreenEvent extends Events{

}

class SendSpecialsHomeEvent extends Events{
  final List<CollectionOfDice> payload;
  SendSpecialsHomeEvent(this.payload);
}