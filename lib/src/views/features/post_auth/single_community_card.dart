import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/preferences.dart';

class SingleCommunityCardWidget extends StatelessWidget {
  const SingleCommunityCardWidget({
    super.key,
    required this.height,
    required this.width,
    required this.index,
    this.showCheckBox = false,
    required this.preference,
  });

  final double height;
  final double width;
  final int index;
  final Preferences preference;
  final bool showCheckBox;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: preference.primary,
        borderRadius: BorderRadius.circular(5.h),
        gradient: LinearGradient(
            begin: const Alignment(0.00, -1.00),
            end: const Alignment(0, 1),
            colors: [preference.primary, preference.secondary]),
      ),
      margin: EdgeInsets.only(
        top: 4.h,
        left: 4.w,
        bottom: 4.h,
        right: index % 2 == 0 ? 4.w : 4.w,
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80.h,
            left: 16.w,
            child: Text(
              preference.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: ATFontWeights.w600,
              ),
            ),
          ),
          Visibility(
            visible: showCheckBox,
            child: Positioned(
              left: 127.w,
              top: 9.h,
              child: SizedBox(
                width: 28.w,
                height: 28.h,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 28.h,
                        height: 28.h,
                        decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: OvalBorder(),
                        ),
                        child: Icon(
                          color: ATColors.brandBlack,
                          Icons.check,
                          size: 20.h,
                          weight: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
