import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/presentation/screens/profile_views_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/shared/rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../widgets/profile_widgets_export.dart';

class CreatorProfileView extends StatelessWidget {
  const CreatorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 54;
    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext ctx, __) => <Widget>[
          SliverAppBar(
            expandedHeight: 500.0,
            pinned: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              const SizedBox(width: 10),
              BlocBuilder<ToggleIconsColor, bool>(
                builder: (_, bool state) {
                  return ATRoundedBackBtn(
                    bgColor: state
                        ? ATColors.white.withValues(alpha: 0.2)
                        : null,
                  );
                },
              ),
              const Spacer(),
              Stack(
                children: <Widget>[
                  BlocBuilder<ToggleIconsColor, bool>(
                    builder: (_, bool state) {
                      return ATCircleAvatar(
                        onTap: () => context
                            .pushNamed(ATRoutes.communityTaskScreen),
                        diameter: 30,
                        animationDuration: 0,
                        color: state
                            ? ATColors.white.withValues(alpha: 0.2)
                            : ATColors.black.withValues(alpha: 0.7),
                        child: const Icon(Iconsax.global, size: 20),
                      );
                    },
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: ATCircleAvatar(
                      diameter: 8,
                      color: ATColors.hexECO404,
                    ),
                  )
                ],
              ),
              const SizedBox(width: 15),
              BlocBuilder<ToggleIconsColor, bool>(
                builder: (_, bool state) {
                  return ATCircleAvatar(
                    onTap: () =>
                        context.pushNamed(ATRoutes.profileMenuScreen),
                    diameter: 30,
                    animationDuration: 0,
                    color: state
                        ? ATColors.white.withValues(alpha: 0.2)
                        : ATColors.black.withValues(alpha: 0.7),
                    child: const Icon(Icons.menu, size: 20),
                  );
                },
              ),
              const SizedBox(width: 15)
            ],
            backgroundColor: ATColors.black,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const <StretchMode>[StretchMode.fadeTitle],
              background: BlocBuilder<LocalUserDataCubit,
                  ATAppState<UserProfileData>>(
                builder: (BuildContext context,
                    ATAppState<UserProfileData> state) {
                  final UserProfileData? userData = context
                      .watch<LocalUserDataCubit>()
                      .currentUserData;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const CreatorProfileCoverImage(),
                      const SizedBox(height: 50),
                      Text(
                        userData?.name ?? 'Glennon Doyle',
                        style: context.textTheme.bodyLarge
                            ?.copyWith(height: 0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        userData?.username ?? 'Glennondoyle',
                        style: context.textTheme.titleMedium?.copyWith(
                          color: ATColors.hexC2C2C2,
                          height: 0.8,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const TopCreatorBadge(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: <Widget>[
                          NoOfFollowers(
                            noOfFollowers:userData?.followersCount
                          ),
                          NoOfSubscribers(
                            noOfSubscribers: userData?.subscribersCount
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                       _ProfileDesc(userData: userData),
                      const SizedBox(height: 20),
                      const RowOfSocials(),
                      const SizedBox(height: 15),
                      const EditProfileAndSubscriptionRow(),
                      const SizedBox(height: 15),
                      Divider(
                        thickness: 1,
                        color: ATColors.white.withValues(alpha: 0.1),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: ATSliverHDelegate(
              maxExt: headerHeight,
              minExt: headerHeight,
              onPinned: () =>
                  ctx.read<ToggleIconsColor>().changeIconColor(true),
              onUnpinned: () =>
                  ctx.read<ToggleIconsColor>().changeIconColor(false),
              child: Container(
                height: headerHeight,
                color: ATColors.black,
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: ProfileScreenTabs(tabs: _tabs),
              ),
            ),
          )
        ],
        body: TabBarView(
                
            children: List<Widget>.generate(
              4,
              (int index) => CreatorSampleTabView(tabIndex: index),
            )),
      ),
    );
  }
}

class _ProfileDesc extends StatelessWidget {
  const _ProfileDesc({required this.userData});
  final UserProfileData? userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: ATRichText(
        items: <String, TextStyle>{
         'Author of UNTAMED & LOVE WARRIOR. Host of WE CAN DO HARD THINGS. Founder of':
              context.textTheme.titleMedium!.copyWith(fontSize: ATSizes.size13),
          ' @together_rising. ': context.textTheme.titleMedium!.copyWith(
            fontSize: ATSizes.size13,
            color: ATColors.hexC2C2C2,
          ),
          'Includes an Oscar winner.':
              context.textTheme.titleMedium!.copyWith(fontSize: ATSizes.size13),
        },
        textAlign: TextAlign.center,
        textOnTap: (String index) {
          if (index == "1") {
            print("Hello");
          }
        },
      ),
    );
  }
}

class CreatorSampleTabView extends StatefulWidget {
  const CreatorSampleTabView({super.key, required this.tabIndex});
  final int tabIndex;

  @override
  State<CreatorSampleTabView> createState() => _CreatorSampleTabViewState();
}

class _CreatorSampleTabViewState extends State<CreatorSampleTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProfileTabType tabType = switch (widget.tabIndex) {
      0 => ProfileTabType.scheduled,
      1 => ProfileTabType.ended,
      2 => ProfileTabType.shows,
      3 => ProfileTabType.events,
      _ => ProfileTabType.shows,
    };
    return ProfileEventOrShowDisplay(tabType: tabType);
  }
}

final List<String> _tabs = <String>[
  ATStrings.scheduled,
  ATStrings.ended,
  ATStrings.shows,
  ATStrings.events
];
