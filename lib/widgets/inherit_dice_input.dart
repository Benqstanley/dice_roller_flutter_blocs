import 'package:flutter/material.dart';


class InheritDiceInput extends InheritedWidget {
  final bool rollBox;
  final String dropdownValue;
  final TextStyle style;
  const InheritDiceInput({
    Key key,
    this.rollBox,
    this.dropdownValue,
    this.style,
    @required Widget child,
  })
      : assert(child != null),
        super(key: key, child: child);

  static InheritDiceInput of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(
        InheritDiceInput) as InheritDiceInput;
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toString
    return 'Roll Box is $rollBox and dropdownValue is $dropdownValue';
  }

  @override
  bool updateShouldNotify(InheritDiceInput old) {
  return old.rollBox != rollBox || old.dropdownValue != dropdownValue;
  }
}
