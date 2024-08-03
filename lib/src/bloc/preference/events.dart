abstract class AmptivePreferenceEvent {}

class LoadPreferencesEvent extends AmptivePreferenceEvent {}

class SelectPreferenceEvent extends AmptivePreferenceEvent {
  final int selectedIndex;

  SelectPreferenceEvent({required this.selectedIndex});
}

class SelectPreferenceCompletedEvent extends AmptivePreferenceEvent {}
