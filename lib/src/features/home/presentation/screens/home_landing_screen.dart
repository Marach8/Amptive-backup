import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/home/cubits/home_feed_cubit.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/home/presentation/widgets/render_home_feed_item.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../shared/circular_image.dart';
import '../../../../shared/divider_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/live_user_model_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/appbar_drop_down.dart';
import '../widgets/go_live_widget_in_home.dart';


class HomeTabView extends StatelessWidget {
  const HomeTabView({
    super.key,
    required this.nestedKey,
    required this.liveUsersScrollController,
  });

  final ScrollController liveUsersScrollController;
  final GlobalKey<NestedScrollViewState> nestedKey;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: context.read<ATNavBarBloc>().ctrlNavVisibility,
      child: NestedScrollView(
        floatHeaderSlivers: true,
        key: nestedKey,
        headerSliverBuilder: (_, __) => <Widget>[
          SliverAppBar(
            floating: true, snap: true, leadingWidth: 150,
            leading: const Padding(
              padding: EdgeInsets.only(left: 15),
              child: ATHomeDropDown(
                offset: Offset(0, 50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ATImgLoader(
                      imgPath: ATImgStrings.AMPTIVE_NAME_LOGO,
                      height: 21, width: 86
                    ),
                    SizedBox(width: 4.0,),
                    Icon(Icons.keyboard_arrow_down_outlined, size: 25,),
                  ],
                ),
              ),
            ),
          
            actions: <Widget>[
              // IconButton(
              //   onPressed: (){
              //     context.read<HomeFeedCubit>().fetchHomeFeed();
              //     context.read<LiveUsersCubit>().fetchLiveUsers();
              //   },
              //   icon: Icon(Icons.add),
              // ),
              GestureDetector(
                onTap: (){
                  //context.pushNamed(ATRoutes.GO_LIVE_ONBOARDING);
                  context.pushNamed(ATRoutes.walletScreen);
                  //context.pushNamed(ATRoutes.WALLET_ONBOARDING);
                },
                child: Stack(
                  children: <Widget>[
                    const ATImgLoader(
                      imgPath: ATImgStrings.walletIcon, 
                      height: 30, width: 30,
                    ),
                    Positioned(
                      top: 5, right: 0,
                      child: ATCircleAvatar(diameter: 8, color: ATColors.hexECO404)
                    )
                  ],
                )
              ),
              const SizedBox(width: 24),
              GestureDetector(
                // onTap: (){
                //   context.pushReplacementNamed(
                //     ATRoutes.MAIN_GO_LIVE_PROGRAM,
                //     extra: GoLiveUserType.audience
                //   );
                // },
                onTap: () => context.pushNamed(ATRoutes.creatorProfileScreen),
                //onTap: () => context.pushNamed(ATRoutes.USER_PROFILE_SCREEN),
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: BlocBuilder<LocalUserDataCubit, ATAppState<CachedUserData>>(
                    builder: (_, ATAppState<CachedUserData> state) {
                      final CachedUserData? userData = context.read<LocalUserDataCubit>().currentUserData;
                      return ATCircularImage(
                        imagePath: userData?.pictureUrl ?? ATImgStrings.jpeg2,
                      );
                    }
                  ),
                )
              ),
            ],      
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 100,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children:<Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 11, right: 14),
                    child: GoLiveWidgetInHome(),
                  ),
                  ...Iterable<Widget>.generate(
                    20,
                    (_) => const Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: LiveUserWidget(),
                    )
                  ),
                ]
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: ATDivider(),
            ),
          )
        ],
         
        body: BlocConsumer<HomeFeedCubit, ATAppState<HomeFeedResponseModel>>(
          listener: (_, ATAppState<HomeFeedResponseModel> state){
            if(state is FailureState<HomeFeedResponseModel>){
              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure,
              );
            }
          },
          builder: (_, ATAppState<HomeFeedResponseModel> state) {
            return switch(state){
              InitialState<HomeFeedResponseModel>() => const SizedBox.shrink(),
              LoadingState<HomeFeedResponseModel>() ||
              FailureState<HomeFeedResponseModel>() ||
              SuccessState<HomeFeedResponseModel>() => Builder(
                builder: (_){
                  final HomeFeedResponseModel? homeFeedData = 
                    context.read<HomeFeedCubit>().currentHomeFeedData;
                  final List<HomeFeedItem> homeFeedItems = 
                    homeFeedData?.homeFeedItems ?? <HomeFeedItem>[];

                  if(homeFeedItems.isEmpty){
                    if(state is LoadingState<HomeFeedResponseModel>){
                      return const _InitialLoadingShimmer();
                    }
                    if(state is FailureState<HomeFeedResponseModel>){
                      return Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => context.read<HomeFeedCubit>().fetchHomeFeed(),
                        ),
                      );
                    }
                    return const Center(
                      child: Text('No feed items available'),
                    );
                  }

                  final bool hasMore = homeFeedData?.hasMore ?? false;
                  final int count = homeFeedItems.length;

                  return ListView.separated(
                    separatorBuilder: (_, int index) => const SizedBox(height: 30),
                    itemCount: hasMore ? count + 1 : count,
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
                    itemBuilder: (_, int index){
                      if(index < count){
                        final HomeFeedItem homeFeedItem = homeFeedItems[index];
                        return MultiBlocProvider(
                          providers: <SingleChildWidget>[
                            BlocProvider<ToggleFollowingCubit>(
                              create: (_) => ToggleFollowingCubit(
                                initialStatus: FollowingStatus(
                                  isFollowing: homeFeedItem.requesterFollowsHost,
                                  followerCount: homeFeedItem.goingCount
                                ),
                              ))
                          ],
                          child: RenderHomeFeedItem(homeFeedItem: homeFeedItem),
                        );
                      }
                      if(state is LoadingState<HomeFeedResponseModel>){
                        return const Center(
                          child: ATLoadingIndicator(),
                        );
                      }
                      return const SizedBox.shrink();
                    }
                  );
                }
              )
            };
          }
        )
      ),
    );
  }
}


class _InitialLoadingShimmer extends StatelessWidget {
  const _InitialLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 30),
      itemCount: 5,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 60),
      itemBuilder: (_, __) => const RenderHomeFeedItemShimmer()
    );
  }
}
