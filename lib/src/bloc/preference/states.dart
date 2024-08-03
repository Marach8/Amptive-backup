import 'package:amptive/src/models/preferences.dart';

abstract class AmptivePreferenceState {
  final List<Preferences> items;
  List selectedItems = [];

  AmptivePreferenceState({required this.items, required this.selectedItems});
}

class InitialState extends AmptivePreferenceState {
  InitialState({required super.items}) : super(selectedItems: []);
}

class SelectPreferenceState extends AmptivePreferenceState {
  SelectPreferenceState({required super.items, required super.selectedItems});
}

class SelectPreferenceCompletedState extends AmptivePreferenceState {
  SelectPreferenceCompletedState() : super(items: [], selectedItems: []);
}

class PreferencePersonalizedState extends AmptivePreferenceState {
  PreferencePersonalizedState() : super(items: [], selectedItems: []);
}
