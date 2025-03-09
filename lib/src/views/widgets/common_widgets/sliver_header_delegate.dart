import 'package:flutter/material.dart';

class ATSliverHDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool? rebuild;
  final double minExt, maxExt;

  ATSliverHDelegate({
    required this.child,
    required this.maxExt,
    required this.minExt,
    this.rebuild
  });

  @override
  double get minExtent => minExt;

  @override
  double get maxExtent => maxExt;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) => child;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return rebuild ?? false;
  }
}

