
import './events.dart';

import '../classes/dice.dart';

mixin ViewEvents on Events{

}

class ViewPopulateScreenEvents extends Events with ViewEvents{

}

class ViewSendSpecialsToHomeBlocEvents extends Events with ViewEvents{
  final List<CollectionOfDice> payload;
  ViewSendSpecialsToHomeBlocEvents(this.payload);
}

class ViewDeleteSpecialEvents extends Events with ViewEvents{
  int index;
  ViewDeleteSpecialEvents(this.index);
}