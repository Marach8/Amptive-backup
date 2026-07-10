import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/profile_prez_export.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 54;
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext ctx, __) => <Widget>[
              SliverAppBar(
                expandedHeight: 330.0,
                pinned: true,
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  const SizedBox(width: 15),
                  BlocBuilder<ToggleIconsColor, bool>(
                      builder: (_, bool state) {
                    return ATRoundedBackBtn(
                      bgColor: state
                          ? ATColors.white.withValues(alpha: 0.2)
                          : null,
                    );
                  }),
                  const Spacer(),
                  BlocBuilder<ToggleIconsColor, bool>(
                      builder: (_, bool state) {
                    return ATCircleAvatar(
                      onTap: () => context
                          .pushNamed(ATRoutes.profileMenuScreen),
                      diameter: 30, animationDuration: 0,
                      color: state
                          ? ATColors.white.withValues(alpha: 0.2)
                          : ATColors.black.withValues(alpha: 0.7),
                      child: const Icon(Icons.menu, size: 20),
                    );
                  }),
                  const SizedBox(width: 15)
                ],
                backgroundColor: ATColors.black,
                flexibleSpace: FlexibleSpaceBar(
                  background: BlocBuilder<LocalUserDataCubit,
                    ATAppState<ProfileData>>(
                  builder: (BuildContext context,
                      ATAppState<ProfileData> state) {
                    final ProfileData? userData = context
                      .watch<LocalUserDataCubit>()
                      .currentUserData;

                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const UserBgProfileCoverImage(),
                            const SizedBox(height: 50),
                            Text(userData?.name ?? '',
                                style: context.textTheme.bodyLarge?.copyWith(
                                  height: 0.6,
                                )),
                            const SizedBox(height: 8),
                            Text(
                              userData?.username ?? '',
                              style: context.textTheme.titleMedium?.copyWith(
                                  color: ATColors.hexC2C2C2, height: 0.8),
                            ),
                            const SizedBox(height: 20),
                            NoOfFollowers(noOfFollowers: userData?.followersCount),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: ATContainer(
                                onTap: () => context.pushNamed(ATRoutes.editProfile),
                                alignment: Alignment.center,
                                radius: 50,
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                color: ATColors.white.withValues(alpha: 0.2),
                                child: Text(ATStrings.editProfile,
                                  style: context.textTheme.bodyMedium
                                    ?.copyWith(fontSize: ATSizes.size14
                                  )
                                )
                              ),
                            ),
                            const SizedBox(height: 15),
                            Divider(
                              thickness: 1,
                              color: ATColors.white.withValues(alpha: 0.1),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: ATSliverHDelegate(
                    maxExt: headerHeight,
                    minExt: headerHeight,
                    onPinned: () => ctx
                        .read<ToggleIconsColor>()
                        .changeIconColor(true),
                    onUnpinned: () => ctx
                        .read<ToggleIconsColor>()
                        .changeIconColor(false),
                    child: Container(
                        height: headerHeight,
                        color: ATColors.black,
                        padding:
                            const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: ProfileScreenTabs(
                          tabs: _tabs,
                        ))),
              )
            ],
        body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: List<Widget>.generate(2, (int index) => SampleTabView(tabIndex: index)
          )
        )
      ),
    );
  }
}

class SampleTabView extends StatefulWidget {
  const SampleTabView({super.key, required this.tabIndex});
  final int tabIndex;

  @override
  State<SampleTabView> createState() => _SampleTabViewState();
}

class _SampleTabViewState extends State<SampleTabView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final ProfileTabType tabType = widget.tabIndex == 0 ? ProfileTabType.shows : ProfileTabType.events;
    return ProfileEventOrShowDisplay(tabType: tabType);
  }
    
  
}

final List<String> _tabs = <String>[ATStrings.ATTENDED, ATStrings.UPCOMING];
