import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/register_user_cubit.dart';
import 'package:amptive/src/features/auth/data/models/user_data.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/rich_text.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../views/widgets/common_widgets/app_bar_widget.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({super.key});

  @override
  State<AddNameScreen> createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> with ATValidators {
  late TextEditingController nameController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Removed the local BlocProvider. This screen now correctly uses the 
    // RegisterUserCubit provided at the root of the auth flow.
    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        appBar: const ATAppBar(
          leading: ATBackBtn(),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ATStrings.whatIsYourName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: ATSizes.size17,
                      ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                ATTextFormField(
                  controller: nameController,
                  validator: validateField,
                  onChanged: (String val) {
                    setState(() {
                      _isFormValid = _formKey.currentState?.validate() ?? false;
                    });
                    context.read<RegisterUserCubit>().setName(val);
                  },
                  keyboardType: TextInputType.text,
                  cursorColor: ATColors.hex307FE2,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    hintText: ATStrings.enterYourName,
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: ATColors.hex307FE2,
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
                Container(
                  height: 17.h,
                  margin: EdgeInsets.symmetric(
                    vertical: 11.h,
                  ),
                  child: Text(
                    ATStrings.noteAboutProfilePic,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BlocBuilder<RegisterUserCubit, ATAppState<UserData>>(
          builder: (BuildContext context, ATAppState<UserData> state) {
            final bool isLoading = state is LoadingState<UserData>;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 20,
                children: <Widget>[
                  ATRichText(
                    items: <String, TextStyle>{
                      '${ATStrings.by_clicking_on_create_acct} ': context.textTheme.titleSmall!.copyWith(
                        fontSize: ATSizes.size11
                      ),
                      ATStrings.terms_of_service: context.textTheme.displayMedium!.copyWith(
                        fontSize: ATSizes.size11
                      ),
                      ' and ': context.textTheme.titleSmall!.copyWith(
                        fontSize: ATSizes.size11
                      ),
                      ATStrings.privacy_policy: context.textTheme.displayMedium!.copyWith(
                        fontSize: ATSizes.size11
                      ),
                    },
                  ),
                  ATPlainElevatedBtn(
                    btnTitle: ATStrings.create_acct,
                    isLoading: isLoading,
                    onPressed: (_isFormValid && !isLoading)
                        ? () async {
                            final cubit = context.read<RegisterUserCubit>();
                            cubit.setName(nameController.text);
                            await cubit.registerUser();
                          }
                        : null,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}