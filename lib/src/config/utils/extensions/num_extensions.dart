import 'package:intl/intl.dart';

extension NumExt on num {
  /// Formats a number to a compact representation (e.g., 1000 -> 1K, 1500 -> 1.5K)
  String get compactFormat {
    final format = NumberFormat.compact();
    format.maximumFractionDigits = 1;
    return format.format(this).toLowerCase();
  }
}
