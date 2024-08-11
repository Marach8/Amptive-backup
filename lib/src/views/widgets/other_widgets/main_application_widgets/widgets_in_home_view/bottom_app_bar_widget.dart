import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../common_widgets/container_for_rendering_other_widgets.dart';
import '../../../common_widgets/live_user_model_widget.dart';
import 'user_with_add_icon_widget.dart';

class AmptiveLiveUsersListView extends StatelessWidget implements PreferredSizeWidget{
  const AmptiveLiveUsersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height: 115.h,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.62.w),
                  child: const AmptiveUserWithAddIconWidget(),
                ),
                ...Iterable.generate(
                  20,
                  (_) => Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(14.w),
                      const AmptiveLiveUserModelWidget()
                    ],
                  )
                ),
              ]
            ),
          ),
          AmptiveCustomContainer(
            color: AmptiveColors.whiteColor,
            height: 0.15,
            width: double.infinity,
            child: const SizedBox.shrink(),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120.h);
}