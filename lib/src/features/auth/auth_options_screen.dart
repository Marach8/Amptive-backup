import 'dart:io';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/outlined_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';


enum AuthType{signUp, signIn}
class ATAuthOptionsScreen extends StatelessWidget {
  const ATAuthOptionsScreen({
    super.key,
    required this.authType
  });

  final AuthType authType;

  @override
  Widget build(BuildContext context) {
    final bool isSignUp = authType == AuthType.signUp;
    final bool isIOS = Platform.isIOS;

    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          title: ATImgLoader(imgPath: ATImgStrings.AMPTIVE_NAME_LOGO),
          leading: ATBackBtn(),
        ),

        body: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                ATPlainElevatedBtn(
                  btnTitle: (isSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.email,
                  onPressed: (){
                    if(isSignUp){
                      context.pushNamed(ATRoutes.emailScreen);
                    }
                    else{
                      context.pushNamed(ATRoutes.temporaryLoginScreen);
                    }
                  }
                ),
                const SizedBox(height: 15,),

                ATOutlinedBtn(
                  btnTitle: (isSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.phoneNumber,
                  onPressed: () {
                    if (isSignUp){
                     context.pushNamed(ATRoutes.phoneAuthScreen);
                     } else {
                      context.pushNamed(ATRoutes.phoneLoginScreen);
                     }
                     }
                ),

                const SizedBox(height: 20),
                Text(
                  ATStrings.or,
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                const SizedBox(height: 20,),

                _CustomBtn(
                  isSignUp: isSignUp, btnName: ATStrings.FACEBOOK,
                  leading: const ATImgLoader(imgPath: ATImgStrings.FB_ICON,),
                  onPressed: (){}
                ),
                const SizedBox(height: 15,),

                _CustomBtn(
                  isSignUp: isSignUp, btnName: ATStrings.TWITTER,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(FontAwesomeIcons.xTwitter, size: 30,),
                  ),
                  onPressed: (){}
                ),
                const SizedBox(height: 15,),

                _CustomBtn(
                  isSignUp: isSignUp, btnName: ATStrings.GOOGLE,
                  leading: const ATImgLoader(imgPath: ATImgStrings.googleIcon,),
                  onPressed: (){}
                ),
                const SizedBox(height: 15,),

                if(isIOS) _CustomBtn(
                  isSignUp: isSignUp, btnName: ATStrings.APPLE,
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ATImgLoader(
                      imgPath: ATImgStrings.appleIcon,
                      height: 30, width: 30,
                    ),
                  ),
                  onPressed: (){}
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _CustomBtn extends StatelessWidget {
  const _CustomBtn({
    required this.isSignUp,
    required this.btnName,
    required this.leading,
    required this.onPressed
  });

  final bool isSignUp;
  final String btnName;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ATOutlinedBtn(
      //btnTitle: (isSignUp ? ATStrings.signUpWith : ATStrings.signInWith) + ATStrings.FONE_NO,
      //onPressed: () => context.pushNamed(ATRoutes.ADD_FONE_NO_SCREEN),
      onPressed: onPressed,
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leading,
          Flexible(
            child: Text(
              '${(isSignUp ? ATStrings.signUpWith : ATStrings.signInWith)} $btnName',
              style: context.textTheme.bodyMedium
            ),
          ),
          Opacity(opacity: 0.0, child: leading)
        ],
      )
    );
  }
}