import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:convert';

class Dice {
  String type;
  int numberOfDice;
  int modifier;
  Random random = Random.secure();
  List<String> diceTypes = <String>[
    'd2',
    'd4',
    'd6',
    'd8',
    'd10',
    'd12',
    'd20'
  ];

  Dice(this.type, this.numberOfDice, this.modifier);

  int rollOneDie() {
    int index = diceTypes.indexOf(type);
    int max;
    index++;
    if (index == 7) {
      index = 10;
    }
    max = 2 * index;
    return random.nextInt(max) + 1;
  }

  int rollDice() {
    int runningTotal = 0;
    for (int i = 0; i < numberOfDice; i++) {
      runningTotal = runningTotal + rollOneDie();
    }
    runningTotal += modifier;

    return runningTotal;
  }

  String rollDiceDetailed() {
    int runningTotal = 0;
    StringBuffer partial = StringBuffer();
    for (int i = 0; i < numberOfDice; i++) {
      int roll = rollOneDie();
      runningTotal += roll;
      partial.write(' + ');
      partial.write(roll.toString());
    }
    if (modifier != 0) {
      runningTotal += modifier;
      partial.write(' + $modifier');
    }
    partial.write(' = $runningTotal');
    String toEdit = partial.toString();
    return toEdit.substring(3, toEdit.length);
  }

  String rollDiceString() {
    return rollDice().toString();
  }

  @override
  String toString() {
    return modifier == 0
        ? '$numberOfDice x $type'
        : '$numberOfDice x $type + $modifier';
  }

  String toJSON() {
    String value = '{\n \"numberOfDice\" : $numberOfDice,'
        ' \n\"typeOfDice\": \"$type\",\n\"modifier\":$modifier\n}';
    return value;
  }

  static Dice parseJSON(String jsonString) {
    Map jsonMap = json.decode(jsonString);
    int numOfDice = jsonMap['numberOfDice'];
    int mod = jsonMap['modifier'];
    String type = jsonMap['typeOfDice'];
    return Dice(type, numOfDice, mod);
  }
}

class CollectionOfDice {
  List<Dice> listOfDice;
  String name;
  bool isSelected = false;

  CollectionOfDice({@required this.listOfDice, this.name});

  @override
  String toString() {
    StringBuffer buffer =
        StringBuffer('{\n\"name\":\"$name\", \n\"listOfDice\": [');
    for (Dice dice in listOfDice) {
      buffer.write(dice.toJSON());
      buffer.write(', ');
    }
    String partial = buffer.toString();
    partial = partial.substring(0, partial.length - 2);
    buffer = StringBuffer(partial);
    buffer.write(']\n}');
    return buffer.toString();
  }

  static CollectionOfDice parseFromJSON(String jsonString) {
    Map jsonMap = json.decode(jsonString);
    String collectionName = jsonMap['name'];
    List list = jsonMap['listOfDice'];
    List<Dice> listOfDice = List<Dice>();
    for (Map item in list) {
      int numberOfDice = item['numberOfDice'];
      String typeOfDice = item['typeOfDice'];
      int modifier = item['modifier'];
      listOfDice.add(Dice(typeOfDice, numberOfDice, modifier));
    }

    return CollectionOfDice(name: collectionName, listOfDice: listOfDice);
  }

  String createSubtitle() {
    StringBuffer subtitle = StringBuffer();
    for (Dice dice in listOfDice) {
      subtitle.write(', ');
      subtitle.write(dice.toString());
    }
    String toReturn = subtitle.toString();
    toReturn = toReturn.replaceFirst(', ', '');
    return toReturn;
  }

  Map<String, List<String>> rollCollections() {
    List<String> descriptions = [];
    List<String> rolls = [];
    for (Dice dice in listOfDice) {
      descriptions.add(dice.toString());
      rolls.add(dice.rollDice().toString());
    }
    Map<String, List<String>> rollInfo = {
      'descriptions': descriptions,
      'rolls': rolls
    };
    return rollInfo;
  }

  Map<String, List<String>> rollCollectionsDetailed(){
    List<String> descriptions = [];
    List<String> rolls = [];
    for(Dice dice in listOfDice){
      descriptions.add(dice.toString());
      rolls.add(dice.rollDiceDetailed());
    }
    Map<String, List<String>> rollInfo = {
      'descriptions': descriptions,
      'rolls': rolls
    };
    return rollInfo;
  }

//  int rollCollection() {
//    int runningTotal = 0;
//    for (Dice dice in listOfDice) {
//      runningTotal += dice.rollDice();
//    }
//    return runningTotal;
//  }



}

class SpecialCollection {
  List<CollectionOfDice> listOfCollections;
  String name;

  SpecialCollection(this.name, this.listOfCollections);
}
