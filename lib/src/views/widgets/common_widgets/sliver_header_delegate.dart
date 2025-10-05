import 'package:flutter/material.dart';

class ATSliverHDelegate extends SliverPersistentHeaderDelegate {
  ATSliverHDelegate({
    required this.child,
    required this.maxExt,
    required this.minExt,
    this.rebuild,
    this.onPinned,
    this.onUnpinned,
  });

  final Widget child;
  final bool? rebuild;
  final double minExt, maxExt;

  final VoidCallback? onPinned;
  final VoidCallback? onUnpinned;

  bool _isPinned = false;

  @override
  double get minExtent => minExt;

  @override
  double get maxExtent => maxExt;

  @override
  Widget build(_, double shrinkOffset, bool overlapsContent) {
    bool pinnedNow;

    if (maxExtent == minExtent) {
      pinnedNow = overlapsContent;
    } 
    else {
      pinnedNow = shrinkOffset >= (maxExtent - minExtent);
    }

    if (pinnedNow != _isPinned) {
      _isPinned = pinnedNow;
      if (_isPinned) {
        onPinned?.call();
      } else {
        onUnpinned?.call();
      }
    }

    return child;
  }

  @override
  bool shouldRebuild(_) => rebuild ?? false;
}
