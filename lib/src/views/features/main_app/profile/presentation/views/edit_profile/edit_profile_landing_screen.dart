import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/features/main_app/profile/presentation/widgets/profile_widgets_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(context) {
    
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          padding: EdgeInsets.only(left: 7),
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.EDIT_PROFILE,
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const EditProfileBgImage(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const _MenuHeading(text: ATStrings.ABT_U),
                    const SizedBox(height: 10),

                    _MenuItem(
                      title: ATStrings.NAME,
                      initialValue: 'Alieu Baba',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_NAME, extra: 'Alieu Baba'
                      )
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.USERNAME,
                      initialValue: 'AlieuBaba',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_USERNAME, extra: 'AlieuBaba'
                      )
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.BIO,
                      initialValue: 'Author of UNTAMED & LOVE IS IN THE AIR',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_BIO, extra: 'Author of UNTAMED & LOVE IS IN THE AIR'
                      )
                    ),

                    const SizedBox(height: 15),
                    const ATDivider(),
                    const SizedBox(height: 15),

                    const _MenuHeading(text: ATStrings.LINKS),
                    const SizedBox(height: 10),
                    _MenuItem(
                      title: ATStrings.INSTAGRAM, isLink: true,
                      initialValue: 'www.instagram.com/alieubaba1',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_SOCIALS, extra:[
                          null,
                          //'www.instagram.com/alieubaba1',
                          ATStrings.INSTAGRAM,
                        ]
                      ) 
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: 'X',isLink: true,
                      initialValue: 'www.x.com/alieubaba',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_SOCIALS, extra:[
                          null,//'www.x.com/alieubaba',
                          ATStrings.X,
                        ]
                      )
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.LINKEDIN, isLink: true,
                      initialValue: 'www.linkedIn.com/alieubaba',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_SOCIALS, extra:[
                          'www.linkedIn.com/alieubaba',
                          ATStrings.LINKEDIN,
                        ]
                      )
                    ),
                    const SizedBox(height: 20),
                    _MenuItem(
                      title: ATStrings.WEBSITE, isLink: true,
                      initialValue: 'www.palbucks.co',
                      onTap: ()async => await context.pushNamed(
                        ATRoutes.EDIT_SOCIALS, extra:[
                          null,//'www.palbucks.co',
                          ATStrings.WEBSITE
                        ]
                      )
                    ),

                    const SizedBox(height: 15),
                    const ATDivider(),
                    const SizedBox(height: 15),

                    const _MenuHeading(text: ATStrings.ACCT),
                    const SizedBox(height: 10),
                    _MenuItem(
                      title: ATStrings.SWITCH_ACCT,
                      initialValue: 'Audience',
                      onTap: ()async {
                        context.pushNamed(ATRoutes.SELECT_ACCT_TYPE);
                        return null;
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _MenuHeading extends StatelessWidget {
  const _MenuHeading({required this.text});

  final String text;

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: ATColors.hexC2C2C2,
          fontSize: ATFontSizes.size13
        ),
      ),
    );
  }
}


class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.initialValue,
    required this.onTap,
    this.isLink = false,
  });

  final String title;
  final String initialValue;
  final bool isLink;
  final Future<String?> Function() onTap;

  @override
  Widget build(context) {
    String currentValue = initialValue;

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: StatefulBuilder(
        builder: (_, setter) {
          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () async {
              final newValue = await onTap();
              if (newValue != null && newValue != currentValue) {
                setter(() => currentValue = newValue);
              }
            },
            child: Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                SizedBox(width: ATHelperFuncs.getScreenWidth(context) * 0.2),
                Expanded(
                  child: Text(
                    currentValue,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isLink ? ATColors.white.withOpacity(0.4) : null,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          );
        },
      ),
    );
  }
}