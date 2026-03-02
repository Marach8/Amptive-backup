import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/routing/route_strings.dart';
import '../../../../shared/back_button.dart';

class ATAccountLandingScreen extends StatelessWidget {
  const ATAccountLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.ACCT,
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATContainer(
                onTap: () => context.pushNamed(
                  ATRoutes.ACCT_INFO_SCREEN,
                  extra: <String?>['nnanna@gmail.com', '', '']
                ),
                padding: const EdgeInsets.all(15),
                color: ATColors.white.withValues(alpha: 0.1),
                radius: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ATStrings.ACCT_INFO,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            ATStrings.SET_UP_ACCT_DETAILS, maxLines: 2,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: ATColors.white.withValues(alpha: 0.4)
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right, color: ATColors.white.withValues(alpha: 0.4)),
                  ],
                )
              ),
        
              const SizedBox(height: 20),
        
              ATContainer(
                onTap: (){},
                color: ATColors.white.withValues(alpha: 0.1),
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      ATStrings.DEACTIVATE_ACCT,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Icon(Icons.keyboard_arrow_right, color: ATColors.white.withValues(alpha: 0.4)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}