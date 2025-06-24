import 'package:flutter/material.dart';

class ATSliverHDelegate extends SliverPersistentHeaderDelegate {
  ATSliverHDelegate({
    required this.child,
    required this.maxExt,
    required this.minExt,
    this.rebuild
  });

  final Widget child;
  final bool? rebuild;
  final double minExt, maxExt;

  @override
  double get minExtent => minExt;

  @override
  double get maxExtent => maxExt;

  @override
  Widget build(_, __, ___) => child;

  @override
  bool shouldRebuild(_) => rebuild ?? false;
}

