import 'package:flutter/material.dart';

enum ShowType { event, episode, show, all }

class ShowTypeVisibilityWidget extends StatelessWidget {
  final ShowType showType;
  final Widget child;
  final List<ShowType> allowedShowTypes;

  ShowTypeVisibilityWidget({
    super.key,
    required this.showType,
    required this.child,
    List<ShowType>? allowedShowTypes,
  }) : allowedShowTypes = allowedShowTypes ?? [];

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: allowedShowTypes.contains(showType) || showType == ShowType.all,
      child: child,
    );
  }
}
