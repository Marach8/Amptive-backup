import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

class EditUsernameScreen extends StatefulWidget {
  const EditUsernameScreen({super.key, this.initialUsername});
  final String? initialUsername;

  @override
  State<EditUsernameScreen> createState() => _EditNameScreen();
}

class _EditNameScreen extends State<EditUsernameScreen> {
  late final TextEditingController _cntrl;

  //false => disabled, null => active, true => loading.
  final ValueNotifier<bool?> _buttonNotifier = ValueNotifier<bool?>(false);

  @override
  void initState() {
    super.initState();
    _cntrl = TextEditingController(
      text: widget.initialUsername?.toLowerCase())
      ..addListener((){
        if(_cntrl.text.trim() == widget.initialUsername){
          _buttonNotifier.value == false;
        }
      });
  }


  @override
  void dispose() {
    _cntrl.dispose();
    _buttonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CheckIdentityAvailabilityCubit>(
          create: (_) => CheckIdentityAvailabilityCubit(),
        ),
        BlocProvider<RemoteUserDataCubit>(
          create: (_) => RemoteUserDataCubit(),
        )
      ],
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: const ATAppBar(
                leadingWidth: 30,
                padding: EdgeInsets.only(left: 7),
                leading: ATRoundedBackBtn(),
                titleText: ATStrings.userName),
              body: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ATTextFormField(
                      controller: _cntrl,
                      maxLines: 1,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(ATStrings.emailSymbol,
                          style: context.textTheme.bodyMedium),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: BlocConsumer<CheckIdentityAvailabilityCubit,
                          ATAppState<bool>>(
                          listener: (_, ATAppState<bool> state) {
                            if (state is FailureState<bool>) {
                              _buttonNotifier.value = false;
                              showAppNotification2(
                                context: context,
                                text: state.message,
                                type: NotificationType.failure,
                              );
                            }
                            else if(state is SuccessState<bool>){
                              _buttonNotifier.value = null;
                            }
                            else if (state is LoadingState<bool>){
                              _buttonNotifier.value = false;
                            }
                          },
                          builder: (_, ATAppState<bool> state) =>
                            switch (state) {
                              InitialState<bool>() =>
                                const SizedBox.shrink(),
                              LoadingState<bool>() =>
                                const ATLoadingIndicator(
                                  size: 20,
                                ),
                              SuccessState<bool>() => Icon(
                                  Icons.check,
                                  color: ATColors.successColor,
                                ),
                              FailureState<bool>() => Icon(
                                  Icons.close,
                                  color: ATColors.textRedColor,
                                )
                            }
                          ),
                      ),
                      onChanged: (String text) {
                        ATHelperFuncs.callDebouncer(
                            1500,
                            () => context
                              .read<CheckIdentityAvailabilityCubit>()
                              .checkIdentityAvailability(
                                  param: <String, dynamic>{
                                'username': text.trim()
                              }
                            )
                          );
                      }
                    ),
          
                    const SizedBox(height: 10),
                    BlocBuilder<CheckIdentityAvailabilityCubit,
                      ATAppState<bool>>(builder: (_, ATAppState<bool> state) {
                        if (state is InitialState<bool>) {
                          return const SizedBox.shrink();
                        }
                        final bool isLoading = state is LoadingState<bool>;
                        final bool isSuccess = state is SuccessState<bool>;
                        return Text(
                          isLoading
                              ? ATStrings.checkerLoading
                              : isSuccess
                                  ? ATStrings.usernameIsAvailable
                                  : 'Username not available!',
                          style: context.textTheme.titleSmall?.copyWith(
                            color: isSuccess
                                ? ATColors.successColor
                                : isLoading
                                    ? ATColors.white
                                    : ATColors.textRedColor,
                          ),
                        );
                      }
                    ),
                  ],
                ),
              ),
          
              bottomSheet: BlocListener<RemoteUserDataCubit,
                ATAppState<ProfileData>>(
                listener: (_, ATAppState<ProfileData> state){
                  if(state is FailureState<ProfileData>){
                    _buttonNotifier.value = null;
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  }
                  else if(state is SuccessState<ProfileData>){
                    _buttonNotifier.value = null;
                    context.pop(_cntrl.text.trim());
                  }
                },
                child: ValueListenableBuilder<bool?>(
                  valueListenable: _buttonNotifier,            
                  builder: (BuildContext context, bool? value, _) {
                  final double bottomInset = 
                    MediaQuery.viewInsetsOf(context).bottom;
                  final double bottom = bottomInset == 0 ? 55.0 : 15;
                
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, bottom),
                    child: ATPlainElevatedBtn(
                      isLoading: value == true,
                      onPressed: value == false ? null : (){
                        //We start loading on this button
                        _buttonNotifier.value = true;
                        context.read<RemoteUserDataCubit>()
                          .updateRemoteUserProfile(
                            userProfileData: ProfileData(
                              username: _cntrl.text.trim()));
                      },
                      btnTitle: widget.initialUsername == null
                        ? 'Add username' : ATStrings.acceptChanges,
                    )
                  );
                }),
              ),
            ),
          );
        }
      ),
    );
  }
}
