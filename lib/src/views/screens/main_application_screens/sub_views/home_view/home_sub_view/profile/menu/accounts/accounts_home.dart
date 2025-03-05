import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../../../widgets/common_widgets/circle_avatar.dart';



class ATAccountScreen extends StatelessWidget {
  const ATAccountScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: [
                  AmptiveCircleAvatarWidget(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.transparentColor,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.ACCT,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.transparentColor),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ATContainer(
                    onTap: () => context.pushNamed(
                      ATRoutes.ACCT_INFO_SCREEN,
                      extra: <String?>['nnanna@gmail.com', '+2348022935013']
                    ),
                    padding: const EdgeInsets.all(15),
                    color: ATColors.whiteColor.withValues(alpha: 0.1),
                    radius: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ATStrings.ACCT_INFO,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                ATStrings.SET_UP_ACCT_DETAILS, maxLines: 2,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: ATColors.whiteColor.withValues(alpha: 0.4)
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.keyboard_arrow_right, color: ATColors.whiteColor.withValues(alpha: 0.4)),
                      ],
                    )
                  ),

                  const SizedBox(height: 20),

                  ATContainer(
                    color: ATColors.whiteColor.withValues(alpha: 0.1),
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    radius: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ATStrings.DEACTIVATE_ACCT,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Icon(Icons.keyboard_arrow_right, color: ATColors.whiteColor.withValues(alpha: 0.4)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}