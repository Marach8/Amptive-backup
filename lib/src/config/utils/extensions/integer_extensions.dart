extension CompactNumberFormatting on int {
    String get compact {
      if (this < 1000) {
        return toString();
      }

      if (this < 1000000) {
        return _format(this / 1000, 'k');
      }

      if (this < 1000000000) {
        return _format(this / 1000000, 'm');
      }

      return _format(this / 1000000000, 'b');
    }

    String _format(double value, String suffix) {
      final String formatted = value % 1 == 0
          ? value.toInt().toString()
          : value.toStringAsFixed(1);

      return '$formatted$suffix';
    }
  }
  