import 'package:amptive/src/bloc/preference/bloc.dart';
import 'package:amptive/src/bloc/preference/events.dart';
import 'package:amptive/src/bloc/preference/states.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/constants/font_weights.dart';
import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
import '../../../../views/widgets/common_widgets/loading_indicator.dart';
import '../../../../views/widgets/other_widgets/post_authentication_widgets/community_card_preference.dart';
import '../../../../views/widgets/other_widgets/post_authentication_widgets/processing_preference_widget.dart';

class AmptivePreferenceScreen extends StatefulWidget {
  const AmptivePreferenceScreen({super.key});

  @override
  State<AmptivePreferenceScreen> createState() =>
      _AmptivePreferenceScreenState();
}

class _AmptivePreferenceScreenState extends State<AmptivePreferenceScreen> {
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
            context.goNamed(ATRoutes.preHomepage);

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
                : const ATAppBar(),
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
                                ATStrings.select5Communities,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 30.h),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ATStrings.selectedInterestNote,
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
                                        child: ElevatedButton(
                                          onPressed: () {
                                            context
                                                .read<AmptivePreferenceBloc>()
                                                .add(
                                                    SelectPreferenceCompletedEvent());
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ATColors.hex307FE2,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 11.5.h),
                                          ),
                                          child: Text(
                                            ATStrings.NEXT,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  fontWeight: ATFontWeights
                                                      .w600,
                                                ),
                                          ),
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
