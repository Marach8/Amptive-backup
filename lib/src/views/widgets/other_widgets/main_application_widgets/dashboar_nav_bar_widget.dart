import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/nav_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/icons/custom_icon_icons.dart';

class AmptiveDashboardBottomNavBarWidget extends StatelessWidget {
  const AmptiveDashboardBottomNavBarWidget({
    super.key,
    required this.pageIndexNotifier,
    required this.pageController,
  });

  final ValueNotifier<int> pageIndexNotifier;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AmptiveColors.brandBlackColor,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AmptiveBottomAppBarItem(
            icon: Iconsax.home,
            itemIdentityIndex: 0,
            pageIndexNotifier: pageIndexNotifier,
            pageController: pageController,
          ),
          AmptiveBottomAppBarItem(
            icon: Iconsax.search_normal_1,
            itemIdentityIndex: 1,
            pageIndexNotifier: pageIndexNotifier,
            pageController: pageController,
          ),
          AmptiveBottomAppBarItem(
            icon: CustomIcon.wifil,
            itemIdentityIndex: 2,
            pageIndexNotifier: pageIndexNotifier,
            pageController: pageController,
          ),
          AmptiveBottomAppBarItem(
            icon: Iconsax.notification,
            itemIdentityIndex: 3,
            pageIndexNotifier: pageIndexNotifier,
            pageController: pageController,
          ),
        ],
      ),
    );
  }
}