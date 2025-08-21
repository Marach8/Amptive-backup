import 'package:amptive/src/bloc/preference/bloc.dart';
import 'package:amptive/src/bloc/preference/events.dart';
import 'package:amptive/src/bloc/preference/states.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/loading_indicator.dart';
import '../../post_authentication_widgets/community_card_preference.dart';
import '../../post_authentication_widgets/processing_preference_widget.dart';

class Select5CommunitiesScreen extends StatefulWidget {
  const Select5CommunitiesScreen({super.key});

  @override
  State<Select5CommunitiesScreen> createState() =>
      _Select5CommunitiesScreenState();
}

class _Select5CommunitiesScreenState extends State<Select5CommunitiesScreen> {
  @override
  void initState() {
    context.read<AmptivePreferenceBloc>().add(LoadPreferencesEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: BlocListener<AmptivePreferenceBloc, AmptivePreferenceState>(
        listener: (BuildContext context, AmptivePreferenceState state) {
          if (state is PreferencePersonalizedState) {
            // context.goNamed(AmptiveRoutes.homeScreen);
            context.goNamed(ATRoutes.ALLOW_NOTIFICATIONS_SCREEN);

          }
        },
        child: BlocBuilder<AmptivePreferenceBloc, AmptivePreferenceState>(
            builder: (BuildContext context, AmptivePreferenceState state) {
          bool isOpaque =
              state.selectedItems.length == Constants.kMaxNumberCommunities;

          return Scaffold(
            backgroundColor: ATColors.hex0D0D0D,
            appBar: state is SelectPreferenceCompletedState
                ? null
                : const ATAppBar(leading: ATBackBtn(),),
            body: state is InitialState
                ? const Center(
                    child: ATLoadingIndicator(),
                  )
                : state is SelectPreferenceCompletedState
                    ? const ProcessingPreferenceWidget()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 20.h, bottom: 11.h),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ATStrings.select5Communities, maxLines: 3,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 30.h),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ATStrings.selectedInterestNote, maxLines: 3,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: ATColors.hexCDCDCD),
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: <Widget>[
                                  GridView.builder(
                                    // shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 4.w,
                                            mainAxisSpacing: 4.h,
                                            crossAxisCount: 2,
                                            childAspectRatio: 169.w / 122.h),
                                    itemBuilder: (_, int index) =>
                                        CommunityCardPreferenceWidget(
                                      width: 169.w,
                                      height: 122.h,
                                      index: index,
                                      isOpaque: isOpaque,
                                    ),
                                    itemCount: state.items.length,
                                  ),
                                  Visibility(
                                    visible: isOpaque,
                                    child: Positioned(
                                      left: 0.0,
                                      right: 0.0,
                                      bottom: 0.0,
                                      child: Container(
                                        width: 340.w,
                                        height: 50.h,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25.w),
                                        margin: EdgeInsets.only(bottom: 16.h),
                                        child: ATPlainElevatedBtn(
                                          onPressed: () {
                                            context
                                                .read<AmptivePreferenceBloc>()
                                                .add(
                                                    SelectPreferenceCompletedEvent());
                                          },
                                          btnTitle: ATStrings.NEXT,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
          );
        }),
      ),
    );
  }
}
