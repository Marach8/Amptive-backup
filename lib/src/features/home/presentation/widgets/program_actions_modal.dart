import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

import '../../../../config/utils/colors.dart';
import '../../../../shared/custom_container_widget.dart';

enum SelectedProgramAction {
  subscribe,
  unsubscribe,
  follow,
  unfollow,
  shareLive,
  notInterested,
  report,
}

Future<SelectedProgramAction?> showProgramOptions({
  required BuildContext context,
  required ToggleFollowingCubit toggleFollowingCubit,
  required String targetUserName,
  required String targetUserId,
}) async =>
    await showModalBottomSheet<SelectedProgramAction>(
        context: context,
        barrierColor: ATColors.black.withValues(alpha: 0.5),
        backgroundColor: ATColors.containerGradientColorB,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        builder: (
          _,
        ) {
          return MultiBlocProvider(
            providers: <SingleChildWidget>[
              BlocProvider<ToggleFollowingCubit>.value(
                value: toggleFollowingCubit,
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                const ATModalDismisser(),
                const SizedBox(height: 10),
                _RenderIconAndText(
                  text: 'Subscribe to $targetUserName',
                  leading: const Icon(Icons.favorite_border_outlined),
                  onTap: () {},
                ),
                BlocBuilder<ToggleFollowingCubit, ATAppState<FollowingStatus>>(
                    builder: (BuildContext ctx, __) {
                  final FollowingStatus? currentState =
                      ctx.read<ToggleFollowingCubit>().currentFollowStatus;
                  final bool isFollowing = currentState?.isFollowing ?? false;
                  return _RenderIconAndText(
                    text: isFollowing
                        ? 'Unfollow $targetUserName'
                        : 'Follow $targetUserName',
                    leading: ATImgLoader(
                      imgPath: isFollowing
                          ? ATImgStrings.followIcon
                          : ATImgStrings.unFollowIcon,
                      height: 24,
                      width: 24,
                    ),
                    onTap: () {
                      ctx.read<ToggleFollowingCubit>().toggleIsFollowing(
                            targetUserId: targetUserId,
                          );
                    },
                  );
                }),
                _RenderIconAndText(
                  text: 'Share live',
                  leading: const RotatedBox(
                    quarterTurns: -1,
                    child: Icon(Icons.logout_outlined),
                  ),
                  onTap: () {},
                ),
                _RenderIconAndText(
                  text: 'Not interested',
                  leading: const Icon(Icons.visibility_off_outlined),
                  onTap: () {},
                ),
                _RenderIconAndText(
                  text: 'Report $targetUserName',
                  leading: const Icon(Icons.flag_outlined),
                  onTap: () {},
                ),
                const SizedBox(height: 50),
              ],
            ),
          );
        });

class _RenderIconAndText extends StatelessWidget {
  const _RenderIconAndText({
    required this.text,
    required this.leading,
    required this.onTap,
  });

  final String text;
  final Widget leading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          leading,
          const SizedBox(width: 15),
          Text(
            text,
            style: context.textTheme.labelMedium
                ?.copyWith(color: ATColors.white, fontSize: ATSizes.size17),
          )
        ],
      ),
    );
  }
}
