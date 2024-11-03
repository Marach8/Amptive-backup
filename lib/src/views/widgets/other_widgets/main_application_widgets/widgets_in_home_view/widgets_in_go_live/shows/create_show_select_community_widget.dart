import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/font_sizes.dart';
import '../../../../../../../utils/dialogs/add_communities_dialog.dart';
import '../../../../../common_widgets/custom_container_widget.dart';
import '../../../../../common_widgets/custom_rebuilder_widget.dart';
import '../../../../../common_widgets/image_loader_widget.dart';

class AmptiveCreateShowSelectCommunityWidget extends StatelessWidget {
  const AmptiveCreateShowSelectCommunityWidget({super.key});

  @override
  Widget build(context) {
    final selectCommunityNotifier = ValueNotifier<List<String>>([]);
    return AmptiveCustomContainer(
      radius: 14,
      padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
      color: AmptiveColors.whiteColor.withOpacity(0.1),
      child: AmptiveRebuilderWidget(
        notifier: selectCommunityNotifier,
        builder: (_, selectedCommunity, __){
          if(selectedCommunity.isEmpty){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select a community for your show",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AmptiveColors.whiteColor.withOpacity(0.4),
                  ),
                ),
                GestureDetector(
                  onTap: () => showAddCommunitiesDialog(
                    context: context,
                    notifier: selectCommunityNotifier
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios, size: 20.w,
                    color: AmptiveColors.whiteColor.withOpacity(0.4),
                  ),
                ),
              ],
            );
          }
    
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [                    
              SizedBox(
                height: 60, width: 67,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: AmptiveImageLoaderWidget(imagePath: selectedCommunity.first)
                )
              ),
              const Gap(30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedCommunity.last,
                    style: Theme.of(context).textTheme.bodySmall
                  ),
                  const Gap(5),
                  AmptiveCustomContainer(
                    padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                    radius: 5,
                    color: AmptiveColors.grey2Color,
                    child: Text(
                      'View community',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: AmptiveFontSizes.size12,
                        color: AmptiveColors.grey5Color
                      )
                    ),
                  )
                ],
              ),
              const Spacer(),
    
              GestureDetector(
                onTap: () => selectCommunityNotifier.value = [],
                child: Icon(Icons.close, size: 20.w),
              ),
            ],
          );
        },
      ),
    );
  }
}