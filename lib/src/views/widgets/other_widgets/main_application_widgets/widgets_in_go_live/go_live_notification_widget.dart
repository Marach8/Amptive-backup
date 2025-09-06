import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../../config/utils/other_strings.dart';
import '../../../../../models/go_live_notification_model.dart';
import '../../../../../config/utils/colors.dart';
import '../../../../../config/utils/image_strings.dart';
import '../../../common_widgets/circular_image.dart';
import '../../../../../shared/custom_container_widget.dart';
import '../../../common_widgets/image_loader_widget.dart';

class AmptiveGoLiveNotificationsWidget extends StatelessWidget {
  const AmptiveGoLiveNotificationsWidget({super.key, required this.state});
  final AmptiveGoLiveNotificationModel state;

  @override
  Widget build(BuildContext context) {
    final Host user = state.user.obj;
    final bool isTalking = state.notificationType == ATStrings.IS_TALKING;
    final bool isGifting = state.notificationType == ATStrings.IS_GIFTING;
    final String? giftedAmount = (state.extraDetail as Map<String, String>?)?.values.first;

    return ATContainer(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      height: 35, radius: 30,
      gradient: isTalking ? LinearGradient(
        colors: <Color>[
          ATColors.hexF91880.withOpacity(1),
          ATColors.orangeColor2.withOpacity(0),
        ]
      ) :  isGifting ? LinearGradient(
        colors: <Color>[
          ATColors.green1.withOpacity(1),
          ATColors.hex009C80.withOpacity(0)
        ]
      ) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATCircularImage(
            diameter: 30,
            imagePath: user.profilePicture ?? ''
          ),
          const Gap(5),
          Text(
            user.name ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: ATSizes.size12
            ),
          ),
          const Gap(5),
          Text(
            isGifting ? '${ATStrings.GIFTED} $giftedAmount' : ATStrings.IS_TALKING,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Gap(10),
          ATImgLoader(
            imgPath: isTalking ? ATImgStrings.MIC_ICON
              : isGifting ? ATImgStrings.MONEY_ICON : ''
          )
        ],
      ),
    );
  }
}






class AmptiveGoLivePinnedMsgNtfctnWidget extends StatelessWidget {
  const AmptiveGoLivePinnedMsgNtfctnWidget({super.key, required this.state});
  final AmptiveGoLiveNotificationModel state;

  @override
  Widget build(BuildContext context) {
    final Host user = state.user.obj;
    final Map<String, String>? extraDetails = state.extraDetail as Map<String, String>?;
    final String? role = extraDetails?[ATStrings.ROLE];
    final String? msgTitle = extraDetails?[ATStrings.MSG_TITLE];
    final String? msgContent = extraDetails?[ATStrings.MSG_CONTENT];

    return ATContainer(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      margin: const EdgeInsets.only(left: 15, right: 15),
      color: ATColors.white.withOpacity(0.15),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: ATColors.black,
        )
      ],
      radius: 10,
      child: Row(
        children: <Widget>[
          ATCircularImage(
            diameter: 30,
            imagePath: user.profilePicture ?? ''
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        user.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: ATColors.white.withOpacity(0.7)
                        )
                      ),
                    ),
    
                    ATContainer(
                      color: ATColors.white.withOpacity(0.2),
                      padding: const EdgeInsets.all(2), radius: 4,
                      child: Text(
                        (role ?? '').toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size10
                        )
                      ),
                    ),
                    const Gap(5),
                    ATContainer(
                      color: ATColors.white.withOpacity(0.2),
                      padding: const EdgeInsets.all(2), radius: 4,
                      child: Row(
                        children: <Widget>[
                          Transform.rotate(
                            angle: 44.5,
                            child: const Icon(Icons.push_pin, size: 14)
                          ),
                          const Gap(2),
                          Text(
                            ATStrings.PINNED.toUpperCase(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: ATSizes.size10
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
                  children: <Widget>[
                    Text(
                      '$msgTitle: ',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: ATSizes.size13
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