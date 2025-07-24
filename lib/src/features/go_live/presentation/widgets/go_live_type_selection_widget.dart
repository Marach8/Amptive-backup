import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/font_sizes.dart';
import '../../../../views/widgets/common_widgets/circle_avatar.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class GoLiveTypeSelectionWidget extends StatelessWidget {
  const GoLiveTypeSelectionWidget({
    super.key,
    required this.selectedImgPath,
    required this.unselectedImgPath,
    required this.subtitle,
    required this.alphabet,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String selectedImgPath, unselectedImgPath,
  title, subtitle, alphabet;
  final bool isSelected;
  final void Function(bool) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(isSelected),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ATContainer(
            duration: 200, height: 120,
            width: double.infinity, radius: 5,
            clipBehavior: Clip.hardEdge,
            color: isSelected ? ATColors.hex307FE2 : ATColors.hex2D2D2D,
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 0.5,
              duration: const Duration(milliseconds: 200),
              child: ATImgLoader(
                key: ValueKey<String>(selectedImgPath),
                imgPath: isSelected ? selectedImgPath : unselectedImgPath,
                boxFit: BoxFit.fill,
              ),
            )
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ATCircleAvatar(
                animationDuration: 200,
                diameter: 15,
                color: isSelected ? ATColors.hexF91880 : ATColors. hex2D2D2D,
                child: FittedBox(child: Text(alphabet)),
              ),
              const SizedBox(width: 5,),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: ATFontSizes.size13
                ),
              )
            ],
          ),
          const SizedBox(height: 7),
          Text(
            maxLines: 2,
            subtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ATColors.hexC2C2C2
            ),
          )
        ],
      ),
    );
  }
}
