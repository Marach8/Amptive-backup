import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/outlined_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/outlined_button_with_leading_icon_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
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
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const AmptiveAppBar(
          title: ATImgLoader(imgPath: ATImgStrings.logo2),
        ),

        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                AmptiveElevatedButtonWidget(
                  buttonTitle: (userSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.email,
                  onPressed: () => context.pushNamed(ATRoutes.emailAuth)
                ),
                Gap(15.h),

                AmptiveOutlinedButtonWidget(
                  buttonTitle: (userSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.phoneNumber,
                  onPressed: () => context.pushNamed(ATRoutes.addPhone)
                ),

                Gap(20.h),
                Text(
                  ATStrings.or,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Gap(20.h),

                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.facebook,
                  onPressed: (){},
                  leadingIcon: const ATImgLoader(
                    imgPath: ATImgStrings.facebookIcon,
                  )
                ),
                Gap(15.h),
                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.twitter,
                  onPressed: (){},
                  leadingIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(FontAwesomeIcons.xTwitter),
                  )
                ),
                Gap(15.h),
                AmptiveOutlinedButtonWithLeadingIconWidget(
                  buttonTitle: (userSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.google,
                  onPressed: (){},
                  leadingIcon: const ATImgLoader(
                    imgPath: ATImgStrings.googleIcon,
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