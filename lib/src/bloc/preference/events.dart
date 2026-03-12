abstract class AmptivePreferenceEvent {}

class LoadPreferencesEvent extends AmptivePreferenceEvent {}

class SelectPreferenceEvent extends AmptivePreferenceEvent {
  SelectPreferenceEvent({required this.selectedIndex});
  final int selectedIndex;
}

class SelectPreferenceCompletedEvent extends AmptivePreferenceEvent {}
