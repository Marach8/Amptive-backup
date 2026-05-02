import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/extensions/context_extensions.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/circular_image.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';

class SpeakingNotification extends StatelessWidget {
  const SpeakingNotification({super.key, required this.speaker});
  final LivestreamParticipant speaker;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: <Color>[
            ATColors.hexF91880.withValues(alpha: 1.0),
            ATColors.orangeColor2.withValues(alpha: 0.0),
          ]
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATCircularImage(diameter: 30,
            imagePath: speaker.profilePicture ?? ''),
          const SizedBox(width: 5),
          Text(
            speaker.name ?? '',
            style: context.textTheme.bodyMedium
              ?.copyWith(fontSize: ATSizes.size12),
          ),
          const SizedBox(width: 5),
          Text(
            ATStrings.isTalking,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(width: 10),
          const ATImgLoader(imgPath: ATImgStrings.micIcon)
        ],
      ),
    );
  }
}


class GiftNotification extends StatelessWidget {
  const GiftNotification({
    super.key, required this.gifter,
    required this.amountGifted,
  });

  final LivestreamParticipant gifter;
  final String amountGifted;

  @override
  Widget build(BuildContext context) {
    final Map<String, Gift>? gifts = 
    context.select<LiveStreamCubit1, Map<String, Gift>?>(
      (LiveStreamCubit1 cubit) => cubit.state.gifts,
    );
    return Container(
      padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: <Color>[
            ATColors.green1.withValues(alpha: 1.0),
            ATColors.hex009C80.withValues(alpha: 0.0)
          ]
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ATCircularImage(diameter: 30,
            imagePath: gifter.profilePicture ?? ''),
          const SizedBox(width: 5),
          Text(
            gifter.name ?? '',
            style: context.textTheme.bodyMedium
              ?.copyWith(fontSize: ATSizes.size12),
          ),
          const SizedBox(width: 5),
          Text(
            '${ATStrings.gifted} ${ATStrings.nairaText}$amountGifted',
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(width: 10),
          const ATImgLoader(imgPath: ATImgStrings.moneyIcon)
        ],
      ),
    );
  }
}

// class AmptiveGoLivePinnedMsgNtfctnWidget extends StatelessWidget {
//   const AmptiveGoLivePinnedMsgNtfctnWidget({super.key, required this.state});
//   final AmptiveGoLiveNotificationModel state;

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, String>? extraDetails =
//         state.extraDetail as Map<String, String>?;
//     final String? role = extraDetails?[ATStrings.ROLE];
//     final String? msgTitle = extraDetails?[ATStrings.MSG_TITLE];
//     final String? msgContent = extraDetails?[ATStrings.MSG_CONTENT];

//     return ATContainer(
//       padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
//       margin: const EdgeInsets.only(left: 15, right: 15),
//       color: ATColors.white.withOpacity(0.15),
//       boxShadow: <BoxShadow>[
//         BoxShadow(
//           color: ATColors.black,
//         )
//       ],
//       radius: 10,
//       child: Row(
//         children: <Widget>[
//           ATCircularImage(diameter: 30, imagePath: user.profilePicture ?? ''),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: Text(user.name ?? '',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodySmall
//                               ?.copyWith(
//                                   color: ATColors.white.withOpacity(0.7))),
//                     ),
//                     ATContainer(
//                       color: ATColors.white.withOpacity(0.2),
//                       padding: const EdgeInsets.all(2),
//                       radius: 4,
//                       child: Text((role ?? '').toUpperCase(),
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyMedium
//                               ?.copyWith(fontSize: ATSizes.size10)),
//                     ),
//                     const SizedBox(width: 5),
//                     ATContainer(
//                       color: ATColors.white.withOpacity(0.2),
//                       padding: const EdgeInsets.all(2),
//                       radius: 4,
//                       child: Row(
//                         children: <Widget>[
//                           Transform.rotate(
//                               angle: 44.5,
//                               child: const Icon(Icons.push_pin, size: 14)),
//                           const SizedBox(width: 2),
//                           Text(ATStrings.PINNED.toUpperCase(),
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium
//                                   ?.copyWith(fontSize: ATSizes.size10)),
//                         ],
//                       ),
//                     ),
//                     const Spacer()
//                   ],
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: <Widget>[
//                     Text(
//                       '$msgTitle: ',
//                       style: Theme.of(context)
//                           .textTheme
//                           .titleMedium
//                           ?.copyWith(fontSize: ATSizes.size13),
//                     ),
//                     Expanded(
//                       child: Text(
//                         //'the name of jesus is greater than any other name',
//                         msgContent ?? '',
//                         style: Theme.of(context).textTheme.titleSmall,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
