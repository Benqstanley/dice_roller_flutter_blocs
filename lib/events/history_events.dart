import 'package:flutter/material.dart';

import './events.dart';

mixin HistoryEvents on Events{

}

class UpdateHistory extends Events with HistoryEvents{
  final List<Widget> newHistory;
  UpdateHistory(this.newHistory);
}

class RetrieveHistory extends Events with HistoryEvents{

}
class DeleteHistory extends Events with HistoryEvents{

}