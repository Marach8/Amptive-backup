import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/discover/data/models/response/all_users_response_model.dart';
import 'package:amptive/src/features/discover/presentation/widgets/search_item_tile.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/utils/image_strings.dart';

class SearchResultsTabsView extends StatefulWidget {
  const SearchResultsTabsView({super.key});

  @override
  State<SearchResultsTabsView> createState() => _SearchResultsTabsViewState();
}

class _SearchResultsTabsViewState extends State<SearchResultsTabsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ValueNotifier<int> _isTabSelected;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _isTabSelected = ValueNotifier(0);

    _tabController
        .addListener(() => _isTabSelected.value = _tabController.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AllUsersCubit>(
      create: (_) => AllUsersCubit()..fetchAllUsers(),
      child: Column(
        children: <Widget>[
          TabBar(
              controller: _tabController,
              physics: const BouncingScrollPhysics(),
              splashFactory: NoSplash.splashFactory,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.zero,
              indicator: const BoxDecoration(),
              indicatorColor: ATColors.transparent,
              padding: const EdgeInsets.only(left: 15),
              isScrollable: true,
              dividerColor: ATColors.hex0D0D0D,
              tabs: <String>['All', 'Shows', 'Events', 'Users', 'Hashtags']
                  .asMap()
                  .entries
                  .map((MapEntry<int, String> tab) {
                return Tab(
                  child: ValueListenableBuilder(
                      valueListenable: _isTabSelected,
                      builder: (_, int value, __) {
                        final bool isSelected = tab.key == value;
                        return ATContainer(
                          radius: 20,
                          margin: const EdgeInsets.only(right: 10),
                          color: isSelected
                              ? ATColors.white
                              : ATColors.hex9E9E9E.withOpacity(0.3),
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Text(
                            tab.value,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: isSelected
                                        ? ATColors.hex0D0D0D
                                        : ATColors.white),
                          ),
                        );
                      }),
                );
              }).toList()),
          ATContainer(
            padding: const EdgeInsets.all(15),
            height: ATHelperFuncs.getScreenHeight(context),
            child: Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Column(
                      children: List<Widget>.generate(
                    10,
                    (_) => SearchItemTile(
                      leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                      title: 'We Can Do Hard Things',
                      trailing: ATContainer(
                        onTap: () {},
                        boxShape: BoxShape.circle,
                        height: 24,
                        width: 24,
                        color: ATColors.hexB6B6B6,
                        child: Icon(
                          Icons.play_arrow,
                          size: 15,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ),
                  )),
                  Column(
                      children: List<Widget>.generate(
                    10,
                    (_) => SearchItemTile(
                      leadingImagePath: ATImgStrings.OFFICE_LADIES,
                      isCircular: true,
                      title: 'We Can Do Hard Things',
                      trailing: ATContainer(
                        onTap: () {},
                        boxShape: BoxShape.circle,
                        height: 24,
                        width: 24,
                        color: ATColors.hexB6B6B6,
                        child: Icon(
                          Icons.play_arrow,
                          size: 15,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ),
                  )),
                  Column(
                      children: List<Widget>.generate(
                    10,
                    (_) => SearchItemTile(
                      leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
                      title: 'We Can Do Hard Things',
                      trailing: ATContainer(
                        onTap: () {},
                        boxShape: BoxShape.circle,
                        height: 24,
                        width: 24,
                        color: ATColors.hexB6B6B6,
                        child: Icon(
                          Icons.play_arrow,
                          size: 15,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ),
                  )),
                  BlocConsumer<AllUsersCubit,
                      ATAppState<AllUsersResponseModel>>(
                    listener: (BuildContext context,
                        ATAppState<AllUsersResponseModel> state) {
                      if (state is FailureState<AllUsersResponseModel>) {
                        showAppNotification2(
                          context: context,
                          text: state.message,
                          type: NotificationType.failure,
                        );
                      }
                    },
                    builder: (BuildContext context,
                        ATAppState<AllUsersResponseModel> state) {
                      return switch (state) {
                        InitialState<AllUsersResponseModel>() =>
                          const SizedBox.shrink(),
                        LoadingState<AllUsersResponseModel>() ||
                        FailureState<AllUsersResponseModel>() ||
                        SuccessState<AllUsersResponseModel>() =>
                          Builder(
                            builder: (_) {
                              final AllUsersResponseModel? usersData = context
                                  .read<AllUsersCubit>()
                                  .currentUsersData;
                              final List<User> users =
                                  usersData?.data ?? <User>[];

                              if (users.isEmpty) {
                                if (state
                                    is LoadingState<AllUsersResponseModel>) {
                                  return const _UsersListShimmer();
                                }

                                if (state
                                    is FailureState<AllUsersResponseModel>) {
                                  return Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.refresh),
                                      onPressed: () => context
                                          .read<AllUsersCubit>()
                                          .fetchAllUsers(),
                                    ),
                                  );
                                }

                                return const Center(
                                  child: Text('No users found'),
                                );

                               
                              }

                              return ListView.builder(
                                padding: const EdgeInsets.all(15),
                                itemCount: users.length,
                                itemBuilder: (BuildContext _, int index) {
                                  final User user = users[index];
                                  return SearchItemTile(
                                    leadingImagePath: user.profilePicture ?? '',
                                    title: user.name ??

                                        'Unknown User',
                                        subtitle: user.username ?? 'Unknown Username',
                                    trailing:
                                        const Icon(Icons.keyboard_arrow_right),
                                  );
                                },
                              );
                            },
                          ),
                      };
                    },
                  ),
                  Column(
                      children: List<Widget>.generate(
                    10,
                    (_) => SearchItemTile(
                      leadingImagePath: ATImgStrings.CRIMINAL,
                      title: 'We Can Do Hard Things',
                      trailing: ATContainer(
                        onTap: () {},
                        boxShape: BoxShape.circle,
                        height: 24,
                        width: 24,
                        color: ATColors.hexB6B6B6,
                        child: Icon(
                          Icons.play_arrow,
                          size: 15,
                          color: ATColors.hex0D0D0D,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _UsersListShimmer extends StatelessWidget {
  const _UsersListShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 10, // Number of shimmer items to show
      itemBuilder: (_, __) => const _UserTileShimmer(),
    );
  }
}

class _UserTileShimmer extends StatelessWidget {
  const _UserTileShimmer();

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: LayoutBuilder(
        builder: (_, constraints) {
          return  Row(
          children: <Widget>[
            const ATShimmer(
              height: 50,
              width: 50,
              radius: 25, // Circular
            ),
            const SizedBox(width: 8),
        
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ATShimmer(
                    height: 14,
                    width: ATHelperFuncs.getRandomNumber(constraints.maxWidth * 0.8),
                    radius: 3,
                  ),
                  const SizedBox(height: 5),
        
                  Row(
                    children: <Widget>[
                      // ATShimmer(
                      //   height: 13,
                      //   width: 50,
                      //   radius: 2,
                      // ),
                      // SizedBox(width: 5),
                      // ATShimmer(
                      //   height: 3,
                      //   width: 3,
                      //   radius: 1.5,
                      // ),
                      const SizedBox(width: 5),
                      ATShimmer(
                        height: 13,
                        width: ATHelperFuncs.getRandomNumber(constraints.maxWidth * 0.5),
                        radius: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
        
            const SizedBox(width: 15),
        
            // Trailing icon shimmer
            const ATShimmer(
              height: 24,
              width: 24,
              radius: 4,
            ),
          ],
        );
        }
      ),
    );
  }
}
