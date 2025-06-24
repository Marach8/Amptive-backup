import 'package:amptive/src/bloc/main_app/profile/profile_menu/select_country_bloc.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../../views/widgets/common_widgets/circle_avatar.dart';


class ATAccountInfoScreen extends StatelessWidget {
  const ATAccountInfoScreen({
    super.key,
    this.email,
    this.phone,
    this.country
  });
  final String? email, phone, country;

  @override
  Widget build(context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(7, kToolbarHeight, 15, 15),
              child: Row(
                children: [
                  ATCircleAvatar(
                    onTap: () => context.pop(),
                    diameter: 30, color: ATColors.trsprnt,
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  const Spacer(),
                  Text(
                    ATStrings.ACCT,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Icon(Icons.keyboard_arrow_left, color: ATColors.trsprnt),
                ],
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RenderRowInfo(
                    title: ATStrings.EMAIL,
                    value: email ?? ATStrings.ADD_UR_EMAIL,
                    onTap: ()async{
                      if(email != null){
                        final shouldChangeEmail = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.WANT_2_CHANGE_EMAIL,
                          content: '',
                          yesString: ATStrings.CHANGE,
                          noString: ATStrings.CANCEL
                        );
                        if(!(shouldChangeEmail ?? true)){return;}
                      }
                      if(context.mounted){
                        final emailResult = await context.pushNamed(
                          ATRoutes.EMAIL_SCREEN, 
                          extra: email == null ? ATStrings.ADDING_EMAIL : ATStrings.CHANGING_EMAIL,
                        ) as bool?;
                        if(context.mounted && (emailResult ?? false)){
                          showAppNotification(
                            context: context,
                            icon: const Icon(Icons.check_circle),
                            text: email == null ? ATStrings.EMAIL_ADDED : ATStrings.EMAIL_CHANGED,
                          );
                        }
                      }
                    }
                  ),
                  RenderRowInfo(
                    title: ATStrings.FONE_NO,
                    value: phone ?? ATStrings.ADD_UR_PHONE,
                    onTap: ()async{
                      if(phone != null){
                        final shouldChangeEmail = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.WANT_2_CHANGE_FONE,
                          content: '',
                          yesString: ATStrings.CHANGE,
                          noString: ATStrings.CANCEL
                        );
                        if(!(shouldChangeEmail ?? true)){return;}
                      }
                      if(context.mounted){
                        final phoneResult = await context.pushNamed(
                          ATRoutes.ADD_FONE_NO_SCREEN,
                          extra: phone == null ? ATStrings.ADDING_PHONE : ATStrings.CHANGING_PHONE,
                        ) as bool?;
                        if(context.mounted && (phoneResult ?? false)){
                          showAppNotification(
                            context: context,
                            icon: const Icon(Icons.check_circle),
                            text: phone == null ? ATStrings.FONE_ADDED : ATStrings.FONE_CHANGED,
                          );
                        }
                      }
                    },
                  ),
                  
                  BlocBuilder<ATSelectCountryBloc, String?>(
                    builder: (_, state) {
                      return RenderRowInfo(
                        title: ATStrings.COUNTRY,
                        value: state ?? 'Nigeria',
                        onTap: () => context.pushNamed(
                          ATRoutes.SELECT_COUNTRY_SCREEN,
                          extra: [
                            'Nigeria',
                            _listOfCountries
                          ]
                        ),
                      );
                    }
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


class RenderRowInfo extends StatelessWidget {
  const RenderRowInfo({
    super.key,
    required this.title,
    required this.onTap,
    required this.value
  });

  final String title, value;
  final VoidCallback onTap;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ATColors.white.withValues(alpha: 0.4)
                  ),
                ),
                Icon(Icons.keyboard_arrow_right, color: ATColors.white.withValues(alpha: 0.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



final _listOfCountries = [
  'Afghanistan', 'Albania', 'Algeria', 'Angola', 'Antigua and Barbuda',
  'Austria', 'Azerbaijan', 'Bahamas', 'Nigeria', 'Bangladesh'
];