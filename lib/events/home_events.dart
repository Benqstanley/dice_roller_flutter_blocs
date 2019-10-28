
import '../widgets/dice_input_row.dart';
import './events.dart';

mixin HomeEvents on Events{

}

class HomeRollDiceEvent extends Events with HomeEvents{

}

class HomeClearScreenEvent extends Events with HomeEvents{

}

class HomeAddRowEvent extends Events with HomeEvents{

}

class HomeInitializeScreenEvent extends Events with HomeEvents{

}

class HomeDetailedRollEvent extends Events with HomeEvents{
  final bool payload;
  HomeDetailedRollEvent(this.payload);
}

class HomeDeleteNormalRowEvent extends Events with HomeEvents{
  final DiceInputRow payload;
  HomeDeleteNormalRowEvent(this.payload);
}