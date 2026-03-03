import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/accounts/v_models/select_country_bloc.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/shared/cupertino_country_picker.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


class ATAccountInfoScreen extends StatelessWidget {
  const ATAccountInfoScreen({
    super.key,
    this.email,
    this.phone,
    this.country
  });
  final String? email, phone, country;

  @override
  Widget build(BuildContext context) {
    Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('NG');
    return BlocProvider<ATSelectCountryBloc>(
      create: (_) => ATSelectCountryBloc(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
            leadingWidth: 30,
            padding: EdgeInsets.only(left: 7),
            leading: ATRoundedBackBtn(),
            titleText: ATStrings.ACCT_INFO,
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
              builder: (_, ATAppState<CachedUserData> state) {
                final CachedUserData? userData = context.read<LocalUserDataCubit>().currentUserData;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RenderRowInfo(
                    title: ATStrings.email,
                    value: userData?.email ?? ATStrings.ADD_UR_EMAIL,
                    onTap: ()async{
                      bool? shouldUpdateEmail;
              
                      if(email != null){
                        shouldUpdateEmail = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.WANT_2_CHANGE_EMAIL,
                          content: '',
                          yesString: ATStrings.CHANGE,
                          noString: ATStrings.cancel
                        );
                      }
                      else{
                        shouldUpdateEmail = true;
                      }
              
                      if(context.mounted && (shouldUpdateEmail ?? false)){
                        final String? newEmail = await context.pushNamed(
                          ATRoutes.updateEmailScreen, 
                          extra: email == null ? ATStrings.ADDING_EMAIL : ATStrings.CHANGING_EMAIL,
                        ) as String?;
              
                        if(context.mounted && (newEmail != null)){
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
                      title: ATStrings.name,
                      value: userData?.name ?? ATStrings.addYourName,
                      onTap: ()async{
                        bool? shouldUpdateName;
                
                        if(userData?.name != null){
                          shouldUpdateName = await showConfirmationDialog(
                            context: context,
                            title: ATStrings.want2ChangeName,
                            content: '',
                            yesString: ATStrings.CHANGE,
                            noString: ATStrings.cancel
                          );
                        }
                        else{
                          shouldUpdateName = true;
                        }
                
                        if(context.mounted && (shouldUpdateName ?? false)){
                          final String? newName = await context.pushNamed(
                            ATRoutes.addNameAuthScreen, 
                            extra: userData?.name == null ? ATStrings.addingName: ATStrings.changingName,
                          ) as String?;
                
                          if(context.mounted && (newName != null)){
                            showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: userData?.name == null ? ATStrings.usernameAdded : ATStrings.nameChanged,
                            );
                          }
                        }
                      }
                    ),
                    RenderRowInfo(
                      title: ATStrings.username,
                      value: userData?.username ?? ATStrings.addYourUsername,
                      onTap: ()async{
                        bool? shouldUpdateUsername;
                
                        if(userData?.username != null){
                          shouldUpdateUsername = await showConfirmationDialog(
                            context: context,
                            title: ATStrings.want2ChangeUserName,
                            content: '',
                            yesString: ATStrings.CHANGE,
                            noString: ATStrings.cancel
                          );
                        }
                        else{
                          shouldUpdateUsername = true;
                        }
                
                        if(context.mounted && (shouldUpdateUsername ?? false)){
                          final String? newUsername = await context.pushNamed(
                            ATRoutes.addUserNameScreen, 
                            extra: userData?.username == null ? ATStrings.addingUsername : ATStrings.changingUsername,
                          ) as String?;
                
                          if(context.mounted && (newUsername != null)){
                            showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: userData?.username == null ? ATStrings.usernameAdded : ATStrings.usernameChanged
                            );
                          }
                        }
                      }
                    ),
                    // 
                    // 
                  RenderRowInfo(
                    title: ATStrings.phoneNumber,
                    value: userData?.phoneNumber ?? ATStrings.ADD_UR_PHONE,
                    onTap: ()async{
                      bool? shouldUpdatePhone;
                      final bool noPhone = (phone ?? '').isEmpty;
              
                      if(!noPhone){
                        shouldUpdatePhone = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.WANT_2_CHANGE_FONE,
                          content: '',
                          yesString: ATStrings.CHANGE,
                          noString: ATStrings.cancel
                        );
                      }
                      else{
                        shouldUpdatePhone = true;
                      }
                      if(context.mounted && (shouldUpdatePhone ?? false)){
                        final String? newPhoneNumber = await context.pushNamed(
                          ATRoutes.updatePhoneNoScreen,
                          extra: noPhone ? ATStrings.ADDING_PHONE : ATStrings.CHANGING_PHONE,
                        ) as String?;
                        if(context.mounted && (newPhoneNumber != null)){
                          showAppNotification(
                            context: context,
                            icon: const Icon(Icons.check_circle),
                            text: noPhone ? ATStrings.FONE_ADDED : ATStrings.FONE_CHANGED,
                          );
                        }
                      }
                    },
                  ),
                  RenderRowInfo(
                      title: ATStrings.dob,
                      value: userData?.dob ?? ATStrings.whatIsYourDateOfBirth,
                      onTap: ()async{
                        bool? shouldUpdateDob;
                        final bool noDob = (userData?.dob ?? '').isEmpty;
                
                        if(!noDob){
                          shouldUpdateDob = await showConfirmationDialog(
                            context: context,
                            title: ATStrings.WANT_2_CHANGE_DOB,
                            content: '',
                            yesString: ATStrings.CHANGE,
                            noString: ATStrings.cancel
                          );
                        }
                        else{
                          shouldUpdateDob = true;
                        }
                        if(context.mounted && (shouldUpdateDob ?? false)){
                          final String? newDob = await context.pushNamed(
                             ATRoutes.dobAuthScreen,
                          //   extra: noDob ? ATStrings.ADDING_DOB : ATStrings.CHANGING_DOB,
                           );
                          if(context.mounted && (newDob != null)){
                            showAppNotification(
                              context: context,
                              icon: const Icon(Icons.check_circle),
                              text: noDob ? ATStrings.dobAdded : ATStrings.dobChanged,
                            );
                          }
                        }
                      },
                    ),
                    RenderRowInfo(
                      title: ATStrings.followers,
                      value: userData?.followersCount ?? '0',
                      onTap: () {}
                    ),
                    RenderRowInfo(
                      title: ATStrings.following,
                      value: userData?.followingCount ?? '0',
                      onTap: () {}
                    ),
                  
                  StatefulBuilder(
                    builder: (_, StateSetter setter) {
                      return RenderRowInfo(
                        title: ATStrings.COUNTRY,
                        value: selectedCountry.name,
                        onTap: ()async{
                          final Country? newSelectedCountry = await showCupertinoCountryPickerModal(
                            context: context,
                            initialCountry: selectedCountry,
                          );
                          if(newSelectedCountry != null){
                            setter((){
                              selectedCountry = newSelectedCountry;
                            });
                          }
                        }
                      );
                    }
                  ),
                ],
              ); 
              }
        ),
      ),
        )
      )
      );
    
  }
}


class RenderRowInfo extends StatelessWidget {
  const RenderRowInfo({
    super.key,
    required this.title,
    required this.onTap,
    required this.value,
    this.valueLeading,
  });

  final String title, value;
  final VoidCallback onTap;
  final Widget? valueLeading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: context.textTheme.bodySmall,
          ),
          InkWell(
            onTap: onTap,
            child: Row(
              children: <Widget>[
                if(valueLeading != null)...<Widget>[
                  valueLeading!, const SizedBox(width: 5,)
                ],
                Text(
                  value,
                  style: context.textTheme.bodySmall?.copyWith(
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
