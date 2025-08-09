import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/services/auth/auth_field_service.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/rich_text.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/authentication/general/auth_bloc.dart';
import '../../bloc/authentication/general/auth_events.dart';
import '../../bloc/authentication/general/auth_states.dart';
import '../../views/widgets/common_widgets/app_bar_widget.dart';

class AddNameScreen extends StatefulWidget {
  const AddNameScreen({super.key});

  @override
  State<AddNameScreen> createState() => _AddNameScreenState();
}

class _AddNameScreenState extends State<AddNameScreen> {
  TextEditingController nameController = TextEditingController();
  late AuthFieldService service;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    service = GetIt.I<AuthFieldService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        backgroundColor: ATColors.hex0D0D0D,
        appBar: const ATAppBar(leading: ATBackBtn(),),
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
                        fontSize: ATFontSizes.size17,
                      ),
                ),
                SizedBox(
                  height: 11.h,
                ),
                ATTextFormField(
                  controller: nameController,
                  onChanged: (String val) {
                    context.read<AmptiveAuthBloc>().add(NameChangedEvent());
                    service.validateName(val);
                  },
                  keyboardType: TextInputType.text,
                  cursorColor: service.name.error == null
                      ? ATColors.hex307FE2
                      : ATColors.textRedColor,
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
                        color: service.name.error == null
                            ? ATColors.hex307FE2
                            : ATColors.textRedColor,
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2.w,
                        color: ATColors.trsprnt,
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

        bottomSheet: BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
            builder: (BuildContext context, AmptiveAuthState state) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                ATRichText(
                  items: {
                    '${ATStrings.BY_CLICKING_ON_CREATE_ACCT} ': context.textTheme.titleSmall!.copyWith(
                      fontSize: ATFontSizes.size11
                    ),
                    ATStrings.TERMS_OF_SERVICE: context.textTheme.displayMedium!.copyWith(
                      fontSize: ATFontSizes.size11
                    ),
                    ' and ': context.textTheme.titleSmall!.copyWith(
                      fontSize: ATFontSizes.size11
                    ),
                    ATStrings.PRIVACY_POLICY: context.textTheme.displayMedium!.copyWith(
                      fontSize: ATFontSizes.size11
                    ),
                  },
                ),
                ATPlainElevatedBtn(
                  btnTitle: ATStrings.CREATE_ACCT,
                  onPressed: service.isNameValid
                      ? () {
                          // Validate returns true if the form is valid, or false otherwise.
                          context.goNamed(ATRoutes.ADD_PROFILE_PIC_SCREEN);
                        }
                      : null,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
