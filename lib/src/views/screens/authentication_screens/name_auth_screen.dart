import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/authentication/general/auth_bloc.dart';
import '../../../bloc/authentication/general/auth_events.dart';
import '../../../bloc/authentication/general/auth_states.dart';
import '../../widgets/common_widgets/app_bar_widget.dart';

class NameAuthScreen extends StatefulWidget {
  const NameAuthScreen({super.key});

  @override
  State<NameAuthScreen> createState() => _NameAuthScreenState();
}

class _NameAuthScreenState extends State<NameAuthScreen> {
  TextEditingController nameController = TextEditingController();
  late AuthFieldService service;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        backgroundColor: AmptiveColors.brandBlack,
        appBar: const AmptiveAppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AmptiveStrings.whatIsYourName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: AmptiveFontSizes.size17,
                      ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                AmptiveTextFormFieldWidget(
                  controller: nameController,
                  onChanged: (val) {
                    context.read<AmptiveAuthBloc>().add(NameChangedEvent());
                    service.validateName(val);
                  },
                  keyboardType: TextInputType.text,
                  cursorColor: service.name.error == null
                      ? AmptiveColors.hex307FE2
                      : AmptiveColors.textRedColor,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
                    hintText: AmptiveStrings.enterYourName,
                    hintStyle: Theme.of(context).textTheme.labelMedium,
                    filled: true,
                    fillColor: const Color(0xFF9E9E9E).withOpacity(0.3),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: service.name.error == null
                            ? AmptiveColors.hex307FE2
                            : AmptiveColors.textRedColor,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: AmptiveColors.transparentColor,
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
                    AmptiveStrings.noteAboutProfilePic,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 1.h,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 22.h),
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      text: AmptiveStrings.warningOnClickingCreate +
                          AmptiveStrings.space,
                      children: [
                        TextSpan(
                          text: AmptiveStrings.termsOfService +
                              AmptiveStrings.space,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: AmptiveFontWeights.w700,
                                  ),
                        ),
                        const TextSpan(
                          text: AmptiveStrings.and +
                              AmptiveStrings.space,
                        ),
                        TextSpan(
                          text: AmptiveStrings.privacyPolicy,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: AmptiveFontWeights.w700,
                                  ),
                        ),
                      ],
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            builder: (context, state) {
          return AmptiveElevatedButtonWidget(
            height: 50.w,
            margin: EdgeInsets.only(bottom: 29.h),
            buttonTitle: AmptiveStrings.createAccount,
            onPressed: service.isNameValid
                ? () {
                    // Validate returns true if the form is valid, or false otherwise.
                    context.goNamed(ATRoutes.addProfilePic);
                  }
                : null,
          );
        }),
      ),
    );
  }
}
