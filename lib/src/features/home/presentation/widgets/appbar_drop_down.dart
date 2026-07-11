import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/extensions/context_extensions.dart';

class ATHomeDropDown extends StatelessWidget {
  const ATHomeDropDown({super.key, required this.child, this.offset});
  final Widget child;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
        offset: offset ?? const Offset(-80, 35),
        padding: EdgeInsets.zero,
        onSelected: (String selectedSearchChoice) {},
        color: ATColors.containerGradientColorB,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: child,
        itemBuilder: (_) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  height: 40,
                  onTap: () {
                    context.pushNamed(
                      ATRoutes.scheduledProgramsScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ATStrings.scheduled,
                        style: context.textTheme.bodySmall
                            ?.copyWith(fontSize: ATSizes.size15),
                      ),
                      const ATImgLoader(
                        imgPath: ATImgStrings.calenderIcon,
                        height: 24, width: 24,
                      )
                    ],
                  )),
              PopupMenuItem<String>(
                  height: 40,
                  onTap: () {
                    context.pushNamed(ATRoutes.subscribedProgramsScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ATStrings.subscribed,
                        style: context.textTheme.bodySmall
                            ?.copyWith(fontSize: 15),
                      ),
                      const Icon(Icons.favorite_border_outlined)
                    ],
                  )),
              PopupMenuItem<String>(
                  height: 40,
                  onTap: () {
                    context.pushNamed(
                      ATRoutes.followingProgramsScreen);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        ATStrings.following,
                        style: context.textTheme.bodySmall
                          ?.copyWith(fontSize: ATSizes.size15),
                      ),
                      const ATImgLoader(
                        imgPath: ATImgStrings.personChecked,
                        height: 24, width: 24,
                      )
                    ],
                  ))
            ]);
  }
}


class ATStringsDropDown extends StatelessWidget {
  const ATStringsDropDown({
    super.key,
    this.child,
    required this.items,
    required this.onSelected,
    this.width,
    this.selectedItem,
    this.offset,
  });

  final Widget? child;
  final List<String> items;
  final void Function(String) onSelected;
  final double? width;
  final String? selectedItem;
  final Offset? offset;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: offset ?? const Offset(0, 50),
      onSelected: onSelected,
      constraints: width != null ? BoxConstraints.tightFor(width: width) : null,
      color: ATColors.containerGradientColorB,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ATColors.hex2D2D2D, width: 0.5),
      ),
      padding: EdgeInsets.zero,
      child: child,
      itemBuilder: (_) => items
          .map(
            (String item) => PopupMenuItem<String>(
              height: 30,
              value: item,
              child: Text(
                item,
                style: context.textTheme.bodySmall
              ),
            ),
          )
          .toList(),
    );
  }
}
