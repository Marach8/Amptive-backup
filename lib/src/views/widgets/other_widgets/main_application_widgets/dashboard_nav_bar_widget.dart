import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/nav_bar_item.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/custom_container_widget.dart';

class AmptiveDashboardBottomNavBarWidget extends StatelessWidget {
  const AmptiveDashboardBottomNavBarWidget({
    super.key,
    required this.pageIndexNotifier,
  });

  final ValueNotifier<int> pageIndexNotifier;

  @override
  Widget build(context) {
    return AmptiveCustomContainer(
      color: AmptiveColors.brandBlackColor,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: listOfIcons.map(
          (list){
            final index = listOfIcons.indexOf(list);
            if(index == 3){
              return Stack(
                children: [
                  AmptiveBottomAppBarItem(
                    selected: list.first,
                    unselected: list.last,
                    itemIdentityIndex: index,
                    pageIndexNotifier: pageIndexNotifier,
                  ),
                  Positioned(
                    top: 0, right: 0,
                    child: AmptiveCustomContainer(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      constraints: const BoxConstraints(minWidth: 15),
                      height: 15, radius: 100,
                      color: AmptiveColors.notifRed,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '3', textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: AmptiveFontSizes.size10
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
            return AmptiveBottomAppBarItem(
              selected: list.first,
              unselected: list.last,
              itemIdentityIndex: index,
              pageIndexNotifier: pageIndexNotifier,
            );
          }
        ).toList()
      ),
    );
  }
}



final listOfIcons = [
  [AmptiveImageStrings.filledHome, AmptiveImageStrings.outlinedHome],
  [AmptiveImageStrings.filledSearch, AmptiveImageStrings.outlinedSearch],
  [AmptiveImageStrings.filledBroadCast, AmptiveImageStrings.outlinedBroadCast],
  [AmptiveImageStrings.filledBell, AmptiveImageStrings.outlinedBell],
];