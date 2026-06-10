import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/services/local_storage_service/flutter_secure_storage_service_impl.dart';
import 'package:amptive/src/config/services/local_storage_service/storage_service.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/cubits/signup_cubit.dart';
import 'package:amptive/src/features/auth/data/models/request/registration_data.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/data/models/response/auth_success_response_model.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
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

class _AddNameScreenState extends State<AddNameScreen>{
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
        child: BlocConsumer<SignupCubit, ATAppState<SignupStage>>(
          listener: (_, ATAppState<SignupStage> state){
            if (state is SuccessState<SignupStage>) {
              context.goNamed(ATRoutes.addProfilePicScreen);
            }
            if (state is FailureState<SignupStage>) {
              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure
              );
            }
          },
          builder: (_, ATAppState<SignupStage> state){
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final Animation<Offset> inAnimation = Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(animation);

                return SlideTransition(position: inAnimation, child: child);
              },
              child: switch(state){
                InitialState<SignupStage>() ||
                FailureState<SignupStage>() ||
                SuccessState<SignupStage>() => _AddFullNameWidget(
                  key: const ValueKey<String>('addFullNameWidget'),
                  nameCntrl: _nameCntrl,
                  formKey: _formKey,
                ),
                LoadingState<SignupStage>(:final SignupStage? currentData) 
                  => _CreatingAccountWidget(
                    key: const ValueKey<String>('creatingAccountWidget'),
                    text: currentData?.value ?? '',
                  )
              }
            );
          }
        )
      ),
    );
  }
}


class _AddFullNameWidget extends StatelessWidget with ATValidators{
  const _AddFullNameWidget({
    super.key,
    required this.nameCntrl,
    required this.formKey,
  });
  final TextEditingController nameCntrl;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ATAppBar(leading: ATBackBtn()),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(ATStrings.whatIsYourName,
                  style: context.textTheme.headlineMedium),
              ATTextFormField(
                controller: nameCntrl,
                maxLines: 1,
                hintText: 'E.g, John Doe',
                fillColor: ATColors.hex9E9E9E.withValues(alpha: 0.3),
                keyboardType: TextInputType.text,
                autoValidateMode: AutovalidateMode.disabled,
                validator: validateField,
                prefixIcon: const SizedBox(width: 10),
              ),
              Text(
                ATStrings.noteAboutProfilePic,
                style: context.textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: BlocBuilder<SignupCubit, ATAppState<SignupStage>>(
        builder: (BuildContext context, ATAppState<SignupStage> state) {
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
                    if (text == ATStrings.termsOfService) {}
                    else if (text == ATStrings.privacyPolicy) {}
                  },
                ),
                ATPlainElevatedBtn(
                    btnTitle: ATStrings.createAccount,
                    isLoading: state is LoadingState<SignupStage>,
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        RegistrationData()
                            .copyWith(name: nameCntrl.text.trim());
                        context.read<SignupCubit>().signupUser(
                              param: RegistrationData(),
                            );
                      }
                    }),
              ],
            ),
          );
        }
      ),
    );
  }
}


class _CreatingAccountWidget extends StatelessWidget {
  const _CreatingAccountWidget({
    super.key,
    required this.text
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 40,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ClipRect(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  key: ValueKey<String>(text),
                  text, textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const ATLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
