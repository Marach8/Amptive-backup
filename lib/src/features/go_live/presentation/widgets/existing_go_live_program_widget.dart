import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';


class ExistingGoLiveProgramWidget extends StatelessWidget {
  const ExistingGoLiveProgramWidget({
    super.key,
    required this.imagePic,
    required this.onTap,
    required this.isSelected
  });

  final String imagePic;
  final void Function(bool) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
        return ATContainer(
          duration: 200,
          onTap: () => onTap(isSelected),
          radius: 5,
          border: Border.all(
            color: isSelected ? ATColors.hex307FE2 : ATColors.trsprnt,
            width: 3,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATContainer(
                radius: 5,
                height: kst.maxHeight * 0.65,
                width: context.screenWidth,
                clipBehavior: Clip.hardEdge,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: ATImgLoader(
                    boxFit: BoxFit.fill,
                    imgPath: imagePic
                  ),
                ),
              ),
              ATContainer(
                padding: const EdgeInsets.only(top: 5),
                color: isSelected ? ATColors.hex1F1F23 : ATColors.trsprnt,
                child: Column(
                  children: <Widget>[
                    Text(
                      maxLines: 2,
                      "We Can Do Hard Things",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'Created',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: ATFontSizes.size13,
                            color: ATColors.hexA8A8A8,
                          ),
                        ),
                        const SizedBox(width: 5,),
                        
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ATCircleAvatar(
                            diameter: 5,
                            color: ATColors.hexA8A8A8,
                          ),
                        ),
                        const SizedBox(width: 5,),
                        Flexible(
                          child: Text(
                            '26 March 2024',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: ATColors.hexA8A8A8,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}