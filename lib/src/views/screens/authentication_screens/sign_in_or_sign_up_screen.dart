import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/outlined_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/outlined_button_with_leading_icon_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/svg_asset_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AmptiveAuthScreen extends StatelessWidget {
  const AmptiveAuthScreen({
    super.key,
    required this.userSignUp
  });

  final bool userSignUp;

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: const AmptiveAppBar(
          title: AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.logo2),
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                AmptiveElevatedButtonWidget(
                  buttonTitle: (userSignUp ? AmptiveOtherStrings.signUpWith : AmptiveOtherStrings.signInWith) + AmptiveOtherStrings.email,
                  onPressed: () => context.pushNamed(AmptiveRoutes.emailAuth)
                ),
                Gap(15.h),

                AmptiveOutlinedButtonWidget(
                  buttonTitle: (userSignUp ? AmptiveOtherStrings.signUpWith : AmptiveOtherStrings.signInWith) + AmptiveOtherStrings.phoneNumber,
                  onPressed: () => context.pushNamed(AmptiveRoutes.addPhone)
                ),

                Gap(20.h),
                Text(
                  AmptiveOtherStrings.or,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Gap(20.h),

                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? AmptiveOtherStrings.signUpWith : AmptiveOtherStrings.signInWith) + AmptiveOtherStrings.facebook,
                  onPressed: (){},
                  leadingIcon: const AmptiveImageLoaderWidget(
                    imagePath: AmptiveImageStrings.facebookIcon,
                  )
                ),
                Gap(15.h),
                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? AmptiveOtherStrings.signUpWith : AmptiveOtherStrings.signInWith) + AmptiveOtherStrings.twitter,
                  onPressed: (){},
                  leadingIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(FontAwesomeIcons.xTwitter),
                  )
                ),
                Gap(15.h),
                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? AmptiveOtherStrings.signUpWith : AmptiveOtherStrings.signInWith) + AmptiveOtherStrings.google,
                  onPressed: (){},
                  leadingIcon: const AmptiveImageLoaderWidget(
                    imagePath: AmptiveImageStrings.googleIcon,
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}