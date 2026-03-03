import 'dart:async' show StreamController;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UpdateUsernameScreen extends StatefulWidget {
  const UpdateUsernameScreen({super.key, required this.title});
  final String title;

  @override
  State<UpdateUsernameScreen> createState() => _UpdateUsernameScreenState();
}

class _UpdateUsernameScreenState extends State<UpdateUsernameScreen> with ATValidators {
  final TextEditingController _controller = TextEditingController();
  final StreamController<bool> _activateButtonCntrl = StreamController<bool>();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      ATHelperFuncs.callDebouncer(
        500,
        () => _activateButtonCntrl.add(
          validateField(_controller.text) == null,
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _activateButtonCntrl.close();
    ATHelperFuncs.disposeDebouncer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CheckIdentityAvailabilityCubit>(
      create: (_) => CheckIdentityAvailabilityCubit(),
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              appBar: ATAppBar(
                leadingWidth: 30,
                padding: const EdgeInsets.only(left: 7),
                leading: const ATRoundedBackBtn(),
                titleText: widget.title,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ATTextFormField(
                      controller: _controller,
                      hintText: 'Enter username',
                      keyboardType: TextInputType.text,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 8),
                        child: Text(
                          '@',
                          style: context.textTheme.headlineMedium,
                        ),
                      ),
                      suffixIcon: BlocBuilder<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                        builder: (_, ATAppState<bool> state) => switch (state) {
                          InitialState<bool>() => const SizedBox.shrink(),
                          LoadingState<bool>() => const ATLoadingIndicator(size: 20),
                          SuccessState<bool>() => Icon(Icons.check, color: ATColors.successColor),
                          FailureState<bool>() => Icon(Icons.close, color: ATColors.textRedColor)
                        },
                      ),
                      onChanged: (String text) {
                        ATHelperFuncs.callDebouncer(
                          1500,
                          () => context.read<CheckIdentityAvailabilityCubit>().checkIdentityAvailability(
                            param: <String, dynamic>{'username': text},
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  final double bottom = MediaQuery.viewInsetsOf(context).bottom;
                  final double bottomPadding = bottom == 0 ? 60 : 15;

                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, bottomPadding),
                    child: BlocBuilder<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                      builder: (_, ATAppState<bool> state) {
                        final bool isAvailable = state is SuccessState<bool>;

                        return ATPlainElevatedBtn(
                          onPressed: isAvailable
                              ? () {
                                  final CachedUserData? currentData = context.read<LocalUserDataCubit>().currentUserData;
                                  final CachedUserData updatedData = (currentData ?? const CachedUserData()).copyWith(username: _controller.text.trim());
                                  context.read<LocalUserDataCubit>().updateUserDataLocally(updatedData);
                                  context.pop(_controller.text.trim());
                                }
                              : null,
                          btnTitle: 'Save Username',
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
