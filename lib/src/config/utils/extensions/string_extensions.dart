import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:intl/intl.dart';

extension ExtString on String {
  bool get isValidEmail {
    final RegExp emailRegExp =
        RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final RegExp nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final RegExp phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }

  bool get isValidUsername {
    // Regular expression to match only letters, numbers, periods, and underscores
    final RegExp validCharacters = RegExp(r'^[a-z0-9._]+$');
    return validCharacters.hasMatch(this);
  }

  bool get emailContainsEmailSymbol => contains(ATStrings.emailSymbol);

  String formatPrice() {
    final double number = double.tryParse(this) ?? 0.0;
    final NumberFormat formatter = NumberFormat('#,###.##');
    return formatter.format(number);
  }

  String get addSlash => '/$this';

  String get capitalize => this[0].toUpperCase() + substring(1).toLowerCase();
  String get toLocalTime {
    if (isEmpty) return 'Just now';
    try {
      DateTime dateTime = DateTime.parse(this).toLocal();
      return DateFormat.jm().format(dateTime);
    } catch (e) {
      return 'Just now';
    }
  }

  String get toTimeAgo {
    if (isEmpty) return 'now';
    try {
      DateTime dateTime = DateTime.parse(this).toLocal();
      Duration diff = DateTime.now().difference(dateTime);

      if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y';
      if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo';
      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'now';
    } catch (e) {
      return 'now';
    }
  }
}
