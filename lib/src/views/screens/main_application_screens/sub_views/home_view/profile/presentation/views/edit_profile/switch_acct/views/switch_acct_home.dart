import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../bloc/profile_bloc_export.dart';

class SwitchAccountScreen extends StatelessWidget {
  const SwitchAccountScreen({super.key});

  @override
  Widget build(context) {
    int? index;
    return ATAnnotatedRegion(
      child: StatefulBuilder(
        builder: (_, setter) {
          return Scaffold(
            appBar: const ATAppBar(
              leadingWidth: 30,
              padding: EdgeInsets.only(left: 7),
              leading: ATRoundedBackBtn(),
              titleText: ATStrings.SWITCH_ACCT
            ),
          
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
              child: Column(
                children: [
                  Text(
                    ATStrings.SELECT_ACCT_TYPE, maxLines: 3,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: ATColors.hexC2C2C2
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SelectAcct(
                    title: ATStrings.CREATOR_ACCT,
                    subTitle: ATStrings.CREATOR_ACCT_DESC,
                    imgPath: ATImgStrings.CREATOR_ACCT_LOGO,
                    isSelected: index == 0,
                    onTap: (){
                      if(index == null || index == 1){setter(() => index = 0);}
                      else{setter(() => index = null);}
                    },
                  ),
                  const SizedBox(height: 20),
                  _SelectAcct(
                    isSelected: index == 1,
                    title: ATStrings.BIZ_ACCT,
                    subTitle: ATStrings.BIZ_ACCT_DESC,
                    imgPath: ATImgStrings.BIZ_ACCT_LOGO,
                    onTap: (){
                      if(index == null || index == 0){setter(() => index = 1);}
                      else{setter(() => index = null);}
                    },
                  )
                ],
              ),
            ),
          
            bottomSheet: Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
              child: ATPlainElevatedBtn(
                onPressed: index == null ? null 
                  : (){
                    context.read<CreatorLandingAnimationBloc>().reset();
                    context.pushNamed(
                      ATRoutes.SELECTED_ACCT_LANDING,
                      extra: index == 0 ? true : false
                    );
                  },
                btnTitle: ATStrings.PROCEED,
              ),
            ),
          );
        }
      ),
    );
  }
}



class _SelectAcct extends StatelessWidget {
  const _SelectAcct({
    required this.title,
    required this.subTitle,
    required this.imgPath,
    required this.onTap,
    required this.isSelected
  });
  final String title, subTitle, imgPath;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(context) {
    return ATContainer(
      radius: 14,
      duration: 200,
      padding: const EdgeInsets.all(15),
      border: isSelected ? Border.all(
        color: ATColors.hex307FE2,
        width: 0.5
      ) : null,
      color: ATColors.white.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: ATFontSizes.size15
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  subTitle, maxLines: 3,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size13,
                    color: ATColors.hexC2C2C2
                  ),
                ),
              ),
              const SizedBox(width: 30),
              ATImgLoader(imgPath: imgPath)
            ],
          ),
          const SizedBox(height: 15),
          const ATDivider(),
          const SizedBox(height: 5),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(5),
            child: ATContainer(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              color: ATColors.white.withValues(alpha: 0.1),
              radius: 5,
              child: Text(
                ATStrings.setUpAcct(title.toLowerCase()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: ATFontSizes.size12,
                  color: ATColors.white.withValues(alpha: 0.7)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
