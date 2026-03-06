import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/widgets/profile_widgets_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
      builder: (BuildContext context, ATAppState<CachedUserData> state){
        final CachedUserData? userData = context
           .read<LocalUserDataCubit>()
           .currentUserData;
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
            children: <Widget>[
              const EditProfileBgImage(),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),
                      const _MenuHeading(text: ATStrings.ABT_U),
      
                      _MenuItem(
                        title: ATStrings.NAME,
                        value: userData?.name ??'Alieu Baba',
                        onTap: ()async{
                          await context.pushNamed(
                            ATRoutes.EDIT_NAME, extra: 'Alieu Baba'
                          );
                        }
                      ),
                      _MenuItem(
                        title: ATStrings.userName,
                        value: userData?.username?? 'AlieuBaba',
                        onTap: ()async => await context.pushNamed(
                          ATRoutes.EDIT_USERNAME, extra: 'AlieuBaba'
                        )
                      ),
                      _MenuItem(
                        title: ATStrings.BIO,
                        value: 'Author of UNTAMED & LOVE IS IN THE AIR',
                        onTap: ()async{
                          final String? newBio = await context.pushNamed(
                            ATRoutes.EDIT_BIO, 
                            extra: 'Author of UNTAMED & LOVE IS IN THE AIR'
                          );
                        }
                      ),
      
                      const SizedBox(height: 15),
                      const ATDivider(),
                      const SizedBox(height: 15),
      
                      const _MenuHeading(text: ATStrings.LINKS),
                      _MenuItem(
                        title: ATStrings.INSTAGRAM, isLink: true,
                        value: 'www.instagram.com/alieubaba1',
                        onTap: ()async => await context.pushNamed(
                          ATRoutes.EDIT_SOCIALS, extra:<String?>[
                            null,
                            //'www.instagram.com/alieubaba1',
                            ATStrings.INSTAGRAM,
                          ]
                        ) 
                      ),
                      _MenuItem(
                        title: 'X',isLink: true,
                        value: 'www.x.com/alieubaba',
                        onTap: ()async => await context.pushNamed(
                          ATRoutes.EDIT_SOCIALS, extra:<String?>[
                            null,//'www.x.com/alieubaba',
                            ATStrings.X,
                          ]
                        )
                      ),
                      _MenuItem(
                        title: ATStrings.LINKEDIN, isLink: true,
                        value: 'www.linkedIn.com/alieubaba',
                        onTap: ()async => await context.pushNamed(
                          ATRoutes.EDIT_SOCIALS, extra:<String>[
                            'www.linkedIn.com/alieubaba',
                            ATStrings.LINKEDIN,
                          ]
                        )
                      ),
                      _MenuItem(
                        title: ATStrings.WEBSITE, isLink: true,
                        value: 'www.palbucks.co',
                        onTap: ()async => await context.pushNamed(
                          ATRoutes.EDIT_SOCIALS, extra:<String?>[
                            null,//'www.palbucks.co',
                            ATStrings.WEBSITE
                          ]
                        )
                      ),
      
                      const SizedBox(height: 15),
                      const ATDivider(),
                      const SizedBox(height: 15),
      
                      const _MenuHeading(text: ATStrings.ACCT),
                      _MenuItem(
                        title: ATStrings.SWITCH_ACCT,
                        value: 'Audience',
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
    );
  }
}



class _MenuHeading extends StatelessWidget {
  const _MenuHeading({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          color: ATColors.hexC2C2C2,
          fontSize: ATSizes.size13
        ),
      ),
    );
  }
}


class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.value,
    required this.onTap,
    this.isLink = false,
  });

  final String title;
  final String value;
  final bool isLink;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Row(
        children: <Widget>[
          Text(title, style: context.textTheme.bodySmall),
          SizedBox(width: context.screenWidth * 0.2),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.bodySmall?.copyWith(
                color: isLink ? ATColors.white.withValues(alpha:0.4) : null,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}