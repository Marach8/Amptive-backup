import 'package:flutter/material.dart' show BuildContext, MediaQuery;

extension ContextExt on BuildContext {
  
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;
}
