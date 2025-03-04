import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../models/community.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/font_weights.dart';

class SelectedCommunity extends StatelessWidget {
  const SelectedCommunity({
    super.key,
    required Community selectedCommunity,
    required this.onClose,
    required this.onView,
  }) : _selectedCommunity = selectedCommunity;

  final Community _selectedCommunity;
  final Function() onClose;
  final Function() onView;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: ATColors.whiteColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.328.w,
            height: 72.h,
            child: Image.asset(
              _selectedCommunity.coverPic!,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 18.w,
          ),
          Container(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCommunity.name!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                ElevatedButton(
                  onPressed: onView,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ATColors.whiteColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  child: Text("View Community",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: ATColors.whiteColor.withOpacity(0.7),
                          fontWeight: AmptiveFontWeights.w500)),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 1.w,
            ),
          ),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close),
          )
        ],
      ),
    );
  }
}
