import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:amptive/src/bloc/main_app/go_live_bloc/audience_view/following_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../bloc/main_app/go_live_bloc/audience_view/subscription_bloc.dart';
import '../../../models/host.dart';
import '../../constants/strings/other_strings.dart';

Future<void> showFollowHostOrCohostDialog({
  required BuildContext context,
  required ObjectWithNotifier<Host> host
}) async {
  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AmptiveColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: AmptiveCustomContainer(
            width: AmptiveHelperFunctions.getScreenWidth(context),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Platform.isAndroid
                        ? Icon(
                            Icons.keyboard_arrow_down,
                            color: AmptiveColors.whiteColor.withOpacity(0.6),
                          )
                        : AmptiveCustomContainer(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            radius: 5, height: 4, width: 30,
                            color: AmptiveColors.whiteColor.withOpacity(0.6),
                            child: const SizedBox.shrink(),
                          ),
                    ),
                ),
                  const Gap(10),
                  Row(
                    children: [
                      AmptiveCircularContainerWithPictureWidget(
                        imagePath: host.obj.profilePicture ?? '',
                        diameter: 70,
                      ),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              host.obj.name ?? '',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: AmptiveFontSizes.size20
                              ),
                            ),
                            Text(
                              host.obj.username ?? '',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AmptiveColors.hexC2C2C2
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(50),
                      GestureDetector(
                        onTap: (){},
                        child: const Icon(Icons.more_horiz,),
                      )
                    ],
                  ),
                    
                  const Gap(15),
                    
                  Row(
                    children: [
                      CustomPaint(
                        size: const Size(16, 16),
                        painter: RoundedScallopedPainter(
                          color: AmptiveColors.dimWhiteColor1
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(Icons.star, color: AmptiveColors.black, size: 12),
                        ),
                      ),
                      Text(
                        '1.1m',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size16
                        ),
                      ),
                      const Gap(5),
                      Text(
                        AmptiveStrings.FOLLOWERS,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size16
                        ),
                      ),
                      const Gap(20),
                    
                      CustomPaint(
                        size: const Size(16, 16),
                        painter: RoundedScallopedPainter(
                          color: AmptiveColors.yellowColor
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Icon(Icons.favorite, color: AmptiveColors.black, size: 12),
                        ),
                      ),
                      Text(
                        '150k',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size16
                        ),
                      ),
                      const Gap(5),
                      Text(
                        AmptiveStrings.SUBSCRIBERS,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size16
                        ),
                      ),
                    ],
                  ),
                    
                  const Gap(10),
                    
                  Text(
                    maxLines: 2,
                    'Author of UNTAMED AND LOVE WARRIOR, Host ofWE CAN DO HARD THINGS Podcast Founder of @together jfjdkfjkdjkajkfdkakkdafdadfjkajkfa',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: AmptiveFontSizes.size13,
                      color: AmptiveColors.hexC2C2C2.withOpacity(0.76)
                    ),
                  ),
                    
                  const Gap(30),
                  Row(
                    children: [
                      BlocConsumer<AmptiveFollowingBloc, FollowingState>(
                        listener: (_, state){
                          if(state is IsFollowingState){
                            context.read<AmptiveSubscriptionBloc>().add(
                              ReadyToSubscribeEvent()
                            );
                          }
                          else if(state is IsNotFollowingState){
                            context.read<AmptiveSubscriptionBloc>().add(
                              Restet2InitialSubStateEvent()
                            );
                          }
                        },
                        builder: (_, state) {
                          final isFollowing = state is IsFollowingState;
                          final isLoading = state is FollowLoadingState;
                          final notFollowing = state is IsNotFollowingState;

                          return Flexible(
                            child: AmptivePlainElevatedBtnWidget(
                              onPressed: () async{
                                if(notFollowing){
                                  context.read<AmptiveFollowingBloc>().add(ShouldFollowEvent());
                                }
                                else if(isFollowing){
                                  final shouldUnfollow = await showConfirmationDialog(
                                    context: context,
                                    title: 'Unfollowing ${host.obj.name ?? ''}?',
                                    content: 'Unfollowing will automatically cancell your subscription to their content.',
                                    yesString: 'Unfollow',
                                    noString: AmptiveStrings.CANCEL
                                  );
                                  if(context.mounted && (shouldUnfollow ?? false)){
                                    context.read<AmptiveFollowingBloc>().add(ShouldUnFollowEvent());
                                  }
                                }
                              },
                              bgColor: AmptiveColors.whiteColor,
                              fgColor: AmptiveColors.brandBlack,
                              buttonTitle:notFollowing ? AmptiveStrings.FOLLOW : '',
                              child: isFollowing ? const AmptiveImageLoaderWidget(
                                imagePath: AmptiveImageStrings.USER_FOLLOW
                              ): isLoading ? const AmptiveLoadingIndicatorWidget(size: 20,) : null
                            ),
                          );
                        }
                      ),
                      const Gap(10),

                      BlocBuilder<AmptiveSubscriptionBloc, SubscriptionState>(
                        builder: (_, state) {
                          final isSubscribed = state is SubscribedState;
                          final isLoading = state is SubscriptionLoadingState;
                          final unSubscribed = state is Ready2SubscribeState;
                          final initialState = state is InitialSubState;

                          if(initialState){
                            return const SizedBox.shrink();
                          }

                          return Expanded(
                            flex: 4,
                            child: AmptivePlainElevatedBtnWidget(
                              onPressed: ()async{
                                if(unSubscribed){
                                  context.read<AmptiveSubscriptionBloc>().add(ShouldSubscribeEvent());
                                }
                                else if(isSubscribed){
                                  final shouldUnSubscribe = await showConfirmationDialog(
                                    context: context,
                                    title: "Are your sure you want to unsubscribe from ${host.obj.name ?? ''}'s content?",
                                    content: 'Unsubscribing will remove your access to "subscribers-only" live shows!',
                                    yesString: AmptiveStrings.UNSUBSCRIBE,
                                    noString: AmptiveStrings.CANCEL
                                  );

                                  if(context.mounted && (shouldUnSubscribe ?? false)){
                                    context.read<AmptiveSubscriptionBloc>().add(UnSubscribeEvent());
                                  }
                                }
                              },
                              bgColor: AmptiveColors.yellowColor1,
                              fgColor: AmptiveColors.brandBlack,
                              buttonTitle: isSubscribed ? AmptiveStrings.UNSUBSCRIBE : '',
                              child: isLoading ? AmptiveLoadingIndicatorWidget(color: AmptiveColors.whiteColor,) 
                                : unSubscribed ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AmptiveStrings.SUBSCRIBE,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AmptiveColors.brandBlack,
                                        fontSize: AmptiveFontSizes.size17
                                      ),
                                    ),
                                    const Gap(2),
                                    AmptiveCircleAvatarWidget(
                                      diameter: 4,
                                      color: AmptiveColors.brandBlack,
                                    ),
                                    const Gap(2),
                                    Expanded(
                                      child: Text(
                                        'N1,900/month',
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          color: AmptiveColors.brandBlack,
                                          fontSize: AmptiveFontSizes.size17
                                        ),
                                      ),
                                    ),
                                  ],
                                ) : null,
                            ),
                          );
                        }
                      ),
                    ],
                  )
                ]
              ),
            )
          ),
        );
      }
    );
}





class RoundedScallopedPainter extends CustomPainter {
  final Color color;
  const RoundedScallopedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2; // Radius of the main circle
    const scallopCount = 10; // Number of scallops
    final scallopRadius = size.width / 10; // Radius of each scallop

    for (int i = 0; i < scallopCount; i++) {
      double theta1 = (2 * pi / scallopCount) * i; // Start angle of the scallop
      double theta2 = (2 * pi / scallopCount) * (i + 1); // End angle of the scallop

      // Points for the scallop curve
      Offset startPoint = Offset(
        center.dx + (radius - scallopRadius) * cos(theta1),
        center.dy + (radius - scallopRadius) * sin(theta1),
      );
      Offset endPoint = Offset(
        center.dx + (radius - scallopRadius) * cos(theta2),
        center.dy + (radius - scallopRadius) * sin(theta2),
      );

      // Control point for smooth curves between scallops
      Offset controlPoint = Offset(
        center.dx + radius * cos((theta1 + theta2) / 2),
        center.dy + radius * sin((theta1 + theta2) / 2),
      );

      // Add the scallop curve
      if (i == 0) {
        path.moveTo(startPoint.dx, startPoint.dy);
      }
      path.quadraticBezierTo(
        controlPoint.dx,
        controlPoint.dy,
        endPoint.dx,
        endPoint.dy,
      );
    }

    path.close(); // Connect the path back to the starting point
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
