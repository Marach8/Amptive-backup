import 'dart:ui';

class Preferences {
  late String name;
  late Color primary;
  late Color secondary;
  bool isSelected = false;

  Preferences.card(this.name, this.primary, this.secondary);
}