import 'package:flutter/material.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../common_widgets/custom_container_widget.dart';

class AmptiveSocietySliverHeader extends SliverPersistentHeaderDelegate{
  final TabController tabController;
  final ValueNotifier<int> notifier;
  final TabBar? tabBar;

  AmptiveSocietySliverHeader({
    required this.tabController,
    required this.notifier,
    this.tabBar
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ATContainer(
      color: ATColors.hex0D0D0D,
      height: kToolbarHeight,
      child: TabBar(
        controller: tabController,
        physics: const BouncingScrollPhysics(),
        splashFactory: NoSplash.splashFactory,
        tabAlignment: TabAlignment.start,
        labelPadding: EdgeInsets.zero,
        indicatorColor: ATColors.trsprnt,
        padding: const EdgeInsets.only(left: 15),
        isScrollable: true,
        dividerColor: ATColors.hex0D0D0D,
        tabs: ['All', 'Shows', 'Events'].asMap().entries.map(
          (tab){              
            return Tab(
              child: ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, value, __) {
                final isSelected = tab.key == value;
                  return ATContainer(
                    radius: 20,
                    margin: const EdgeInsets.only(right: 10),
                    color: isSelected ? 
                      ATColors.white : ATColors.hex9E9E9E.withOpacity(0.3),
                    padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                    child: Text(
                      tab.value,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isSelected ? ATColors.hex0D0D0D : ATColors.white                           
                      ),
                    ),
                  );
                }
              ),
            );
          }
        ).toList()
      ),
    );
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) 
    => false;
}
