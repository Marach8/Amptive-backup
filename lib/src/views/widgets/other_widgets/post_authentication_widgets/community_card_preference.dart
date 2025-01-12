import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/preference/bloc.dart';
import '../../../../bloc/preference/events.dart';
import '../../../../bloc/preference/states.dart';
import '../../../../utils/constants/colors.dart';
import '../../../screens/post_authentication_screens/single_community_card.dart';

class CommunityCardPreferenceWidget extends StatelessWidget {
  const CommunityCardPreferenceWidget({
    super.key,
    required this.index,
    required this.height,
    required this.width,
    required this.isOpaque,
  });

  final int index;
  final double height;
  final double width;
  final bool isOpaque;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AmptivePreferenceBloc, AmptivePreferenceState>(
        builder: (context, state) {
      return Opacity(
        opacity: !state.items[index].isSelected && isOpaque ? 0.6 : 1.0,
        child: GestureDetector(
          onTap: () {
            if (!state.items[index].isSelected && isOpaque) {
              return;
            }

            context
                .read<AmptivePreferenceBloc>()
                .add(SelectPreferenceEvent(selectedIndex: index));
          },
          child: Stack(
            children: [
              SingleCommunityCardWidget(
                height: height,
                width: width,
                index: index,
                preference: state.items[index],
                showCheckBox: state.items[index].isSelected,
              ),
              Visibility(
                visible: state.items[index].isSelected,
                child: Positioned(
                  left: 2.w,
                  top: 2.h,
                  child: Container(
                    width: 166.w,
                    height: 119.h,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 2.w,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: AmptiveColors.brandBlue,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
