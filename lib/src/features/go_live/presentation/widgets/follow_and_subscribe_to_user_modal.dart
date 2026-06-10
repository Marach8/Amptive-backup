import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/profile/presentation/profile_prez_export.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/audience_view/subscription_bloc.dart';
import '../../../../shared/modal_dismisser.dart';
import '../../../../config/utils/other_strings.dart';

Future<void> showFollowAndSubscribeToUserModal({
  required BuildContext context,
  required User user,
}) async {
  return await showModalBottomSheet(
      backgroundColor: ATColors.hex202020,
      context: context,
      useRootNavigator: true,
      barrierColor: ATColors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      )),
      builder: (BuildContext context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Container(
            width: context.screenWidth,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 30),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Center(child: ATModalDismisser()),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      ATCircularImage(
                        imagePath: user.profilePicture ?? '',
                        diameter: 70,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              user.name ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: ATSizes.size20),
                            ),
                            Text(
                              user.username ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: ATColors.hexC2C2C2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 50),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(
                          Icons.more_horiz,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 20,
                    children: <Widget>[
                      NoOfFollowers(noOfFollowers: 10),
                      NoOfSubscribers(noOfSubscribers: 20,),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    maxLines: 5,
                    'Author of UNTAMED AND LOVE WARRIOR, Host ofWE CAN DO HARD THINGS Podcast Founder of @together jfjdkfjkdjkajkfdkakkdafdadfjkajkfa',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 13,
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      // Flexible(
                      //   child: ATPlainElevatedBtn(
                      //       onPressed:  ()  async {
                      //         // if (isLoading)
                      //         // return;
                      //         // if (notFollowing)
                      //         // {
                      //         //   context
                      //         //       .read<ToggleFollowingCreatorCubit>()
                      //         //       .followCreator( targetUserId: host.obj.name ?? '');
                      //         // } else if (isFollowing) {
                      //         //   final bool? shouldUnfollow =
                      //         //       await showConfirmationDialog(
                      //         //           context: context,
                      //         //           title:
                      //         //               'Unfollowing ${host.obj.name ?? ''}?',
                      //         //           content:
                      //         //               'Unfollowing will automatically cancell your subscription to their content.',
                      //         //           yesString: 'Unfollow',
                      //         //           noString: ATStrings.cancel);
                      //         //   if (context.mounted &&
                      //         //       (shouldUnfollow ?? false)) {
                      //         //     context
                      //         //         .read<AmptiveFollowingBloc>()
                      //         //         .add(ShouldUnFollowEvent());
                      //         //   }
                      //         // }
                      //       },
                      //       padding:
                      //           const EdgeInsets.fromLTRB(5, 10, 5, 10),
                      //       bgColor: ATColors.white,
                      //       fgColor: ATColors.hex0D0D0D,
                      //       btnTitle: notFollowing ? ATStrings.FOLLOW : '',
                      //       child: isFollowing
                      //           ? const ATImgLoader(
                      //               imgPath: ATImgStrings.USER_FOLLOW)
                      //           : isLoading
                      //               ? const ATLoadingIndicator(
                      //                   size: 20,
                      //                 )
                      //               : null),
                      // ),
                      const SizedBox(width: 10),
                      BlocBuilder<AmptiveSubscriptionBloc, SubscriptionState>(
                          builder: (_, SubscriptionState state) {
                        final bool isSubscribed = state is SubscribedState;
                        final bool isLoading =
                            state is SubscriptionLoadingState;
                        final bool unSubscribed = state is Ready2SubscribeState;
                        final bool initialState = state is InitialSubState;

                        if (initialState) {
                          return const SizedBox.shrink();
                        }

                        return Expanded(
                          flex: 4,
                          child: ATPlainElevatedBtn(
                            onPressed: () async {
                              if (unSubscribed) {
                                context
                                    .read<AmptiveSubscriptionBloc>()
                                    .add(ShouldSubscribeEvent());
                              } else if (isSubscribed) {
                                final bool? shouldUnSubscribe =
                                    await showConfirmationDialog(
                                        context: context,
                                        title:
                                            "Are your sure you want to unsubscribe from ${user.name ?? ''}'s content?",
                                        content:
                                            'Unsubscribing will remove your access to "subscribers-only" live shows!',
                                        yesString: ATStrings.UNSUBSCRIBE,
                                        noString: ATStrings.cancel);

                                if (context.mounted &&
                                    (shouldUnSubscribe ?? false)) {
                                  context
                                      .read<AmptiveSubscriptionBloc>()
                                      .add(UnSubscribeEvent());
                                }
                              }
                            },
                            bgColor: ATColors.hexFED601,
                            fgColor: ATColors.hex0D0D0D,
                            btnTitle: isSubscribed ? ATStrings.UNSUBSCRIBE : '',
                            child: isLoading
                                ? ATLoadingIndicator(
                                    color: ATColors.white,
                                  )
                                : unSubscribed
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            ATStrings.SUBSCRIBE,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color: ATColors.hex0D0D0D,
                                                    fontSize: ATSizes.size17),
                                          ),
                                          const SizedBox(width: 2),
                                          ATCircleAvatar(
                                            diameter: 4,
                                            color: ATColors.hex0D0D0D,
                                          ),
                                          const SizedBox(width: 2),
                                          Expanded(
                                            child: Text(
                                              'N1,900/month',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                      color: ATColors.hex0D0D0D,
                                                      fontSize: ATSizes.size17),
                                            ),
                                          ),
                                        ],
                                      )
                                    : null,
                          ),
                        );
                      }),
                    ],
                  )
                ]),
          ),
        );
      });
}
