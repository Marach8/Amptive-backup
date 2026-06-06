import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/cubits/signup_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/app_bar_widget.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({super.key});

  @override
  State<AddNameScreen> createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> with ATValidators {
  final TextEditingController _nameCntrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _nameCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupCubit>(
      create: (_) => SignupCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: const ATAppBar(
            leading: ATBackBtn(),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(ATStrings.whatIsYourName,
                      style: context.textTheme.headlineMedium),
                  ATTextFormField(
                    controller: _nameCntrl,
                    maxLines: 1,
                    hintText: ATStrings.enterYourName,
                    fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                    keyboardType: TextInputType.text,
                    autoValidateMode: AutovalidateMode.disabled,
                    validator: validateField,
                    prefixIcon: const SizedBox(
                      width: 10,
                    ),
                  ),
                  Text(
                    ATStrings.noteAboutProfilePic,
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: BlocConsumer<SignupCubit, ATAppState<SignUpResponseModel>>(
              listener: (_, ATAppState<SignUpResponseModel> state)  async{
            if (state is SuccessState<SignUpResponseModel>) {
              final SignUpResponseModel? responseModel = state.newData;
    final ATUser? user = responseModel?.user;

    if (user != null) {
      await context.read<LocalUserDataCubit>().updateUserDataLocally(
        CachedUserData(
          userId: user.id,
          email: user.email,
          username: user.username,
          name: user.name,
          dob: user.dob,
          pictureUrl: user.pictureUrl,
          phoneNumber: user.phoneNumber,
        ),
      );
    }
    

              context.goNamed(ATRoutes.addProfilePicScreen);
            }
            if (state is FailureState<SignUpResponseModel>) {
              showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure);
            }
          }, 
          builder: (BuildContext context, ATAppState<SignUpResponseModel> state) {
            final double bottom = MediaQuery.viewInsetsOf(context).bottom;
            final double bottomPad = bottom > 0 ? 10 : 50;
            return Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, bottomPad),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: <Widget>[
                  ATRichText(
                    items: <String, TextStyle>{
                      '${ATStrings.byClickingOnCreateAcct} ': context
                          .textTheme.titleSmall!
                          .copyWith(fontSize: ATSizes.size11),
                      ATStrings.termsOfService: context.textTheme.displayMedium!
                          .copyWith(fontSize: ATSizes.size11),
                      ' and ': context.textTheme.titleSmall!
                          .copyWith(fontSize: ATSizes.size11),
                      ATStrings.privacyPolicy: context.textTheme.displayMedium!
                          .copyWith(fontSize: ATSizes.size11),
                    },
                    textOnTap: (String text) {
                      if (text == ATStrings.termsOfService) {
                      } else if (text == ATStrings.privacyPolicy) {}
                    },
                  ),
                  ATPlainElevatedBtn(
                      btnTitle: ATStrings.createAccount,
                      isLoading: state is LoadingState<dynamic>,
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          RegistrationData()
                              .copyWith(name: _nameCntrl.text.trim());
                          context.read<SignupCubit>().signupUser(
                                param: RegistrationData(),
                              );
                        }
                      }),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
