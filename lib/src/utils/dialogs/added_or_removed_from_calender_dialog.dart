import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../views/widgets/common_widgets/custom_container_widget.dart';
import '../constants/colors.dart';

void showAddedOrRemovedSnackbar({
  required BuildContext context,
  required String content
})
  => Future.delayed(const Duration(seconds: 1)).then(
    (_) => ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(
        backgroundColor: AmptiveColors.snackBarBgColor,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        duration: const Duration(seconds: 5),
        content: AmptiveCustomContainer(
          alignment: Alignment.center,
          height: 40,
          child: Row(
            children: [
              const Icon(Icons.check_circle), 
              Gap(10.w),
              Text(
                content,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              GestureDetector(
                onTap: (){},
                child: Row(
                  children: [
                    Text(
                      AmptiveOtherStrings.view,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AmptiveColors.brandBlue
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right_sharp, color: AmptiveColors.brandBlue)
                  ],
                ),
              )
            ],
          ),
        ),
      )
    )
  );