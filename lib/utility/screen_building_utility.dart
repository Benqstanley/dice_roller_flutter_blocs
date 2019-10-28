import 'package:flutter/material.dart';
import 'dart:io';

Widget platformSpecificWidget(Widget bodyOfApp){
  return Platform.isIOS ? SafeArea(child: bodyOfApp): Container(child: bodyOfApp,);
}