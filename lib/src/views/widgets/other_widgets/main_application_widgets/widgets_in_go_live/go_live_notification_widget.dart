import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../models/go_live_notification_model.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../common_widgets/circular_container_with_picture_widget.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveGoLiveNotificationsWidget extends StatelessWidget {
  final AmptiveGoLiveNotificationModel state;
  const AmptiveGoLiveNotificationsWidget({super.key, required this.state});

  @override
  Widget build(context) {
    final user = state.user.obj;
    final isTalking = state.notificationType == AmptiveOtherStrings.IS_TALKING;
    final isGifting = state.notificationType == AmptiveOtherStrings.IS_GIFTING;
    final giftedAmount = (state.extraDetail as Map<String, String>?)?.values.first;

    return AmptiveCustomContainer(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      height: 35, radius: 30,
      gradient: isTalking ? LinearGradient(
        colors: [
          AmptiveColors.orangeColor1.withOpacity(1),
          AmptiveColors.orangeColor2.withOpacity(0),
        ]
      ) :  isGifting ? LinearGradient(
        colors: [
          AmptiveColors.green1.withOpacity(1),
          AmptiveColors.green2.withOpacity(0)
        ]
      ) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AmptiveCircularContainerWithPictureWidget(
            diameter: 30,
            imagePath: user.profilePicture ?? ''
          ),
          const Gap(5),
          Text(
            user.name ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: AmptiveFontSizes.size12
            ),
          ),
          const Gap(5),
          Text(
            isGifting ? '${AmptiveOtherStrings.GIFTED} $giftedAmount' : AmptiveOtherStrings.IS_TALKING,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Gap(10),
          AmptiveImageLoaderWidget(
            imagePath: isTalking ? AmptiveImageStrings.MIC_ICON
              : isGifting ? AmptiveImageStrings.MONEY_ICON : ''
          )
        ],
      ),
    );
  }
}






class AmptiveGoLivePinnedMsgNtfctnWidget extends StatelessWidget {
  final AmptiveGoLiveNotificationModel state;
  const AmptiveGoLivePinnedMsgNtfctnWidget({super.key, required this.state});

  @override
  Widget build(context) {
    final user = state.user.obj;
    final extraDetails = state.extraDetail as Map<String, String>?;
    final role = extraDetails?[AmptiveOtherStrings.ROLE];
    final msgTitle = extraDetails?[AmptiveOtherStrings.MSG_TITLE];
    final msgContent = extraDetails?[AmptiveOtherStrings.MSG_CONTENT];

    return AmptiveCustomContainer(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      margin: const EdgeInsets.only(left: 15, right: 15),
      color: AmptiveColors.whiteColor.withOpacity(0.15),
      boxShadow: [
        BoxShadow(
          color: AmptiveColors.black,
        )
      ],
      radius: 10,
      child: Row(
        children: [
          AmptiveCircularContainerWithPictureWidget(
            diameter: 30,
            imagePath: user.profilePicture ?? ''
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AmptiveColors.whiteColor.withOpacity(0.7)
                        )
                      ),
                    ),
    
                    AmptiveCustomContainer(
                      color: AmptiveColors.whiteColor.withOpacity(0.2),
                      padding: const EdgeInsets.all(2), radius: 4,
                      child: Text(
                        (role ?? '').toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: AmptiveFontSizes.size10
                        )
                      ),
                    ),
                    const Gap(5),
                    AmptiveCustomContainer(
                      color: AmptiveColors.whiteColor.withOpacity(0.2),
                      padding: const EdgeInsets.all(2), radius: 4,
                      child: Row(
                        children: [
                          Transform.rotate(
                            angle: 44.5,
                            child: const Icon(Icons.push_pin, size: 14)
                          ),
                          const Gap(2),
                          Text(
                            AmptiveOtherStrings.PINNED.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: AmptiveFontSizes.size10
                            )
                          ),
                        ],
                      ),
                    ),
                    const Spacer()
                  ],
                ),
            
                const Gap(5),
            
                Row(
                  children: [
                    Text(
                      '$msgTitle: ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: AmptiveFontSizes.size13
                      ),
                    ),
                    Expanded(
                      child: Text(
                        //'the name of jesus is greater than any other name',
                        msgContent ?? '',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}