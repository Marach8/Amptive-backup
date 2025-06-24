import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/nav_bar_item.dart';
import 'package:flutter/material.dart';
import '../../common_widgets/custom_container_widget.dart';

class MainAppBottomNav extends StatelessWidget {
  const MainAppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      color: ATColors.black,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: listOfIcons.map(
          (List<String> list){
            final int index = listOfIcons.indexOf(list);
            if(index == 3){
              return Stack(
                children: <Widget>[
                  ATBottomNavItem(
                    selectedImagePath: list.first,
                    unselectedImagePath: list.last,
                    itemIdentityIndex: index,
                  ),
                  Positioned(
                    top: 0, right: 0,
                    child: ATContainer(
                      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                      constraints: const BoxConstraints(minWidth: 15),
                      height: 15, radius: 100,
                      color: ATColors.hexECO404,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '3', textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: ATFontSizes.size10
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }

            return ATBottomNavItem(
              selectedImagePath: list.first,
              unselectedImagePath: list.last,
              itemIdentityIndex: index,
            );
          }
        ).toList()
      ),
    );
  }
}



final listOfIcons = [
  [ATImgStrings.filledHome, ATImgStrings.outlinedHome],
  [ATImgStrings.filledSearch, ATImgStrings.OUTLINED_SEARCH],
  [ATImgStrings.filledBroadCast, ATImgStrings.outlinedBroadCast],
  [ATImgStrings.filledBell, ATImgStrings.outlinedBell],
];