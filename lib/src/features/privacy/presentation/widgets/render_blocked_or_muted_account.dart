import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class RenderBlockedOrMutedAccount extends StatelessWidget {
  const RenderBlockedOrMutedAccount(
      {super.key,
      required this.onTap,
      required this.subscriber,
      required this.text});
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> subscriber;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: ATImgLoader(
              imgPath: subscriber.obj.profilePicture!,
              height: 50,
              width: 50,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(subscriber.obj.username ?? '',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          ATContainer(
            onTap: () => onTap(subscriber, subscriber.notifier.value),
            border: Border.all(color: ATColors.white),
            radius: 30,
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: ATSizes.size13,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
