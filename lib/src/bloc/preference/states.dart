import 'package:amptive/src/models/preferences.dart';

abstract class AmptivePreferenceState {
  AmptivePreferenceState({required this.items, required this.selectedItems});
  final List<Preferences> items;
  List selectedItems = <dynamic>[];
}

class InitialState extends AmptivePreferenceState {
  InitialState({required super.items}) : super(selectedItems: <dynamic>[]);
}

class SelectPreferenceState extends AmptivePreferenceState {
  SelectPreferenceState({required super.items, required super.selectedItems});
}

class SelectPreferenceCompletedState extends AmptivePreferenceState {
  SelectPreferenceCompletedState()
      : super(items: <Preferences>[], selectedItems: <dynamic>[]);
}

class PreferencePersonalizedState extends AmptivePreferenceState {
  PreferencePersonalizedState()
      : super(items: <Preferences>[], selectedItems: <dynamic>[]);
}
