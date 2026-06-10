import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/utils_export.dart';
import 'package:amptive/src/features/profile/presentation/profile_prez_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ATUserProfileScreen extends StatelessWidget {
  const ATUserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider<ToggleIconsColor>(
        create: (_) => ToggleIconsColor(),
        child: ATAnnotatedRegion(
          statusBarColor: ATColors.transparent,
          child: Scaffold(
            body: NestedScrollView(
                floatHeaderSlivers: true,
                headerSliverBuilder: (BuildContext ctx, __) => <Widget>[
                      SliverAppBar(
                        expandedHeight: 340.0,
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
                                  .pushNamed(ATRoutes.PROFILE_MENU_SCREEN),
                              //onTap: () => context.pushNamed(AmptiveRoutes.USER_PROFILE_SCREEN),
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
                          background: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const UserBgProfileWidget(),
                              const SizedBox(height: 50),
                              Text('Emmanuel Marach',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    height: 0.6,
                                  )),
                              const SizedBox(height: 8),
                              Text(
                                'nnannaemmanuel💖💝',
                                style: context.textTheme.titleMedium?.copyWith(
                                    color: ATColors.hexC2C2C2, height: 0.8),
                              ),
                              const SizedBox(height: 20),
                              const NoOfFollowers(noOfFollowers: '1.2k'),
                              const SizedBox(height: 15),
                              ATContainer(
                                  onTap: () =>
                                      context.pushNamed(ATRoutes.editProfile),
                                  alignment: Alignment.center,
                                  radius: 50,
                                  height: 45,
                                  width: context.screenWidth - 30,
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  color: ATColors.white.withValues(alpha: 0.2),
                                  child: Text(ATStrings.editProfile,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                              fontSize: ATSizes.size14))),
                              const SizedBox(height: 15),
                              Divider(
                                thickness: 1,
                                color: ATColors.white.withValues(alpha: 0.1),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: ATSliverHDelegate(
                            maxExt: 65,
                            minExt: 65,
                            onPinned: () => ctx
                                .read<ToggleIconsColor>()
                                .changeIconColor(true),
                            onUnpinned: () => ctx
                                .read<ToggleIconsColor>()
                                .changeIconColor(false),
                            child: Container(
                                height: 65,
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
                    children: List<Widget>.generate(2, (int index) => SampleTabView(tabIndex: index)))),
          ),
        ),
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
