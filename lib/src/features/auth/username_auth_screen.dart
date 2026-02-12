import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/check_identity_availability_cubit.dart';
import 'package:amptive/src/features/auth/cubits/register_user_cubit.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';

class AddUsernameScreen extends StatefulWidget {
  const AddUsernameScreen({super.key});

  @override
  State<AddUsernameScreen> createState() => _AddUsernameScreenState();
}

class _AddUsernameScreenState extends State<AddUsernameScreen> with ATValidators {
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CheckIdentityAvailabilityCubit>(
          create: (_) => CheckIdentityAvailabilityCubit(),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return ATAnnotatedRegion(
            child: Scaffold(
              backgroundColor: ATColors.hex0D0D0D,
              appBar: const ATAppBar(
                leading: ATBackBtn(),
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: BlocConsumer<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                  listener: (_, ATAppState<bool> state) {},
                  builder: (_, ATAppState<bool> availabilityState) {
                    final bool isLoading = availabilityState is LoadingState<bool>;
                    final bool isAvailable = availabilityState is SuccessState<bool> && availabilityState.newData == true;
                    final bool isTaken = availabilityState is SuccessState<bool> && availabilityState.newData == false;
                    final bool isError = availabilityState is FailureState<bool>;

                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            ATStrings.whatShouldWeCallYou,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: ATSizes.size17,
                                ),
                          ),
                          SizedBox(
                            height: 11.h,
                          ),
                          ATTextFormField(
                            controller: usernameController,
                            onChanged: (String val) {
                              context.read<RegisterUserCubit>().setUsername(val);
                              ATHelperFuncs.callDebouncer(
                                1500,
                                () => context
                                    .read<CheckIdentityAvailabilityCubit>()
                                    .checkIdentityAvailability(param: <String, dynamic>{'username': val}),
                              );
                            },
                            keyboardType: TextInputType.text,
                            cursorColor: isTaken || isError ? ATColors.textRedColor : ATColors.hex307FE2,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.h, horizontal: 16.w),
                              prefixIcon: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 12.h, horizontal: 16.w),
                                child: Text(
                                  ATStrings.emailSymbol,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                              suffix: isLoading
                                  ? SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: ATColors.hex307FE2,
                                        backgroundColor: ATColors.hex307FE2
                                            .withOpacity(0.5),
                                        strokeWidth: 3.w,
                                      ),
                                    )
                                  : null,
                              suffixIcon: isLoading
                                  ? null
                                  : isAvailable
                                      ? Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          child: Icon(
                                            Icons.check,
                                            color: ATColors.successColor,
                                          ),
                                        )
                                      : (isTaken || isError)
                                          ? Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              child: Icon(
                                                Icons.close,
                                                color: ATColors.textRedColor,
                                              ),
                                            )
                                          : null,
                              hintText: ATStrings.username,
                              hintStyle: Theme.of(context).textTheme.labelMedium,
                              filled: true,
                              fillColor: ATColors.hex9E9E9E.withOpacity(0.3),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.w,
                                  color: isTaken || isError
                                      ? ATColors.textRedColor
                                      : ATColors.hex307FE2,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2.w,
                                  color: ATColors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: isLoading,
                            child: Container(
                              height: 20.h,
                              margin: EdgeInsets.symmetric(vertical: 11.h),
                              child: Text(
                                ATStrings.checker_loading,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: ATFontWeights.w500,
                                    ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !isLoading && isAvailable,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 11.h),
                              child: Text(
                                ATStrings.username_available,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: ATColors.successColor,
                                    ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !isLoading && !isAvailable,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 11.h),
                              child: Text(
                                isTaken
                                    ? ATStrings.username_taken
                                    : (isError ? availabilityState.message : ATStrings.empty),
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      color: ATColors.textRedColor,
                                    ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 1.h,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              bottomSheet: Builder(
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(15),
                    child: BlocBuilder<CheckIdentityAvailabilityCubit, ATAppState<bool>>(
                      builder: (_, ATAppState<bool> availabilityState) {
                        final bool isAvailable = availabilityState is SuccessState<bool> && availabilityState.newData == true;
                        return ATPlainElevatedBtn(
                          onPressed: isAvailable
                              ? () {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    context.read<RegisterUserCubit>().setUsername(usernameController.text);
                                    context.pushNamed(ATRoutes.ADD_NAME_AUTH_SCREEN);
                                  }
                                }
                              : null,
                          btnTitle: ATStrings.next,
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
