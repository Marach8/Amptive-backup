import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../common_widgets/circle_avatar.dart';
import '../../../../common_widgets/custom_container_widget.dart';
import '../../../../common_widgets/custom_rebuilder_widget.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class AmptiveCreateShowOrEventSelectionWidget extends StatelessWidget {
  final String onSelectedImagePath,
  title, subtitle, alphabet;
  final  ValueNotifier<bool> activateBtn,
  showSelected, eventSelected;
  const AmptiveCreateShowOrEventSelectionWidget({
    super.key,
    required this.activateBtn,
    required this.onSelectedImagePath,
    required this.subtitle,
    required this.alphabet,
    required this.title,
    required this.showSelected,
    required this.eventSelected
  });

  @override
  Widget build(BuildContext context) {
    final isShow = title == AmptiveStrings.CREATE_SHOW;
    return AmptiveRebuilderWidget(
      notifier: isShow ? showSelected : eventSelected,
      builder: (_, value, __) {
        return GestureDetector(
          onTap: (){
            if(isShow){
              eventSelected.value = false;
              activateBtn.value = !value;
              showSelected.value = !value;
            }
            else {
              showSelected.value = false;
              activateBtn.value = !value;
              eventSelected.value = !value;
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmptiveContainer(
                duration: 200,
                height: 120.h,
                width: double.infinity,
                radius: 5,
                color: value ? AmptiveColors.hex307FE2 : AmptiveColors.hex2D2D2D,
                child: AnimatedScale(
                  scale: value ? 1.1 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: AmptiveImageLoaderWidget(
                    key: UniqueKey(),
                    imagePath: onSelectedImagePath,
                    boxFit: BoxFit.fill,
                  ),
                )
              ),
              Gap(20.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AmptiveCircleAvatarWidget(
                    animationDuration: 200,
                    diameter: 15,
                    color: value ? AmptiveColors.orangeColor1 : AmptiveColors. hex2D2D2D,
                    child: FittedBox(child: Text(alphabet)),
                  ),
                  const Gap(5),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: AmptiveFontSizes.size13
                    ),
                  )
                ],
              ),
              const Gap(7),
              Text(
                maxLines: 2,
                subtitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AmptiveColors.hexC2C2C2
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
