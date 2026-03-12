import 'dart:ui';

class Preferences {
  Preferences.card(this.name, this.primary, this.secondary);
  late String name;
  late Color primary;
  late Color secondary;
  bool isSelected = false;
}
