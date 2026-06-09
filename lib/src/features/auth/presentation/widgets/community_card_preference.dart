import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/preference/bloc.dart';
import '../../../../bloc/preference/events.dart';
import '../../../../bloc/preference/states.dart';
import '../../../../config/utils/colors.dart';
import '../../../post_auth/presentation/views/single_community_card.dart';

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
        builder: (BuildContext context, AmptivePreferenceState state) {
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
            children: <Widget>[
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
                          color: ATColors.hex307FE2,
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

class RenderACommunityCard extends StatelessWidget {
  const RenderACommunityCard({super.key, required this.community});
  final Community community;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ATImgLoader(
            imgPath: community.image ?? '',
            boxFit: BoxFit.cover,
            height: 120,
            width: 170,
          ),
        ),
      );
    });
  }
}
