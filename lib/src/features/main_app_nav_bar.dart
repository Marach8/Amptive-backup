import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/notifications/cubits/get_notifications_cubit.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../shared/custom_container_widget.dart';

class MainAppBottomNav extends StatelessWidget {
  const MainAppBottomNav({super.key});

  static final List<List<String>> listOfIcons = <List<String>>[
    <String>[ATImgStrings.filledHome, ATImgStrings.outlinedHome],
    <String>[ATImgStrings.filledSearch, ATImgStrings.outlinedSearch],
    <String>[ATImgStrings.filledBroadCast, ATImgStrings.outlinedBroadCast],
    <String>[ATImgStrings.filledBell, ATImgStrings.outlinedBell],
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ATNavBarBloc, ATNavBarState>(
        builder: (_, ATNavBarState state) {
      return ATAnimatedSlide(
        shouldSlide: state.shouldShowNav,
        startOffset: const Offset(0, 1.5),
        endOffset: const Offset(0, 0),
        child: ATContainer(
          color: ATColors.black,
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: listOfIcons.map((List<String> list) {
                final int index = listOfIcons.indexOf(list);
                if (index == 3) {
                  return Stack(children: <Widget>[
                    _BottomNavItem(
                      selectedImagePath: list.first,
                      unselectedImagePath: list.last,
                      itemIdentityIndex: index,
                    ),
                    BlocBuilder<GetNotificationsCubit,
                            ATAppState<NotificationsResponseModel>>(
                        builder: (BuildContext context,
                            ATAppState<NotificationsResponseModel> state) {
                      final int serverUnreadCount = switch (state) {
                        SuccessState<NotificationsResponseModel>(
                          :final NotificationsResponseModel? newData
                        ) =>
                          newData?.unreadCount ?? 0,
                        FailureState<NotificationsResponseModel>(
                          :final NotificationsResponseModel? oldData
                        ) =>
                          oldData?.unreadCount ?? 0,
                        InitialState<NotificationsResponseModel>(
                          :final NotificationsResponseModel? initialData
                        ) =>
                          initialData?.unreadCount ?? 0,
                        LoadingState<NotificationsResponseModel>(
                          :final NotificationsResponseModel? currentData
                        ) =>
                          currentData?.unreadCount ?? 0,
                      };

                      final int count = context
                              .read<ATNavBarBloc>()
                              .state
                              .hasSeenNotifications
                          ? 0
                          : serverUnreadCount;

                      if (count == 0) return const SizedBox.shrink();
                      return Positioned(
                        top: 0,
                        right: 0,
                        child: ATContainer(
                          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                          constraints: const BoxConstraints(minWidth: 15),
                          height: 15,
                          radius: 100,
                          color: ATColors.hexECO404,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(fontSize: ATSizes.size10),
                            ),
                          ),
                        ),
                      );
                    })
                  ]);
                }

                return _BottomNavItem(
                  selectedImagePath: list.first,
                  unselectedImagePath: list.last,
                  itemIdentityIndex: index,
                );
              }).toList()),
        ),
      );
    });
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.itemIdentityIndex,
  });

  final String selectedImagePath, unselectedImagePath;
  final int itemIdentityIndex;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ATNavBarBloc, ATNavBarState, int>(
        selector: (ATNavBarState state) => state.currentIndex,
        builder: (_, int currentNavIndex) {
          final bool isSelected = itemIdentityIndex == currentNavIndex;
          return GestureDetector(
            onTap: () {
              context.read<ATNavBarBloc>().goToPage(itemIdentityIndex, context);
            },
            child: ATAnimatedXFade(
                condition: isSelected,
                firstChild: ATImgLoader(imgPath: selectedImagePath),
                secondChild: ATImgLoader(imgPath: unselectedImagePath)),
          );
        });
  }
}

class ATNavBarState {
  const ATNavBarState({
    required this.currentIndex,
    required this.shouldShowNav,
    this.hasSeenNotifications = false,
  });

  final int currentIndex;
  final bool shouldShowNav;
  final bool hasSeenNotifications;

  ATNavBarState copyWith({
    int? currentIndex,
    bool? shouldShowNav,
    bool? hasSeenNotifications,
  }) {
    return ATNavBarState(
      currentIndex: currentIndex ?? this.currentIndex,
      shouldShowNav: shouldShowNav ?? this.shouldShowNav,
      hasSeenNotifications: hasSeenNotifications ?? this.hasSeenNotifications,
    );
  }
}

class ATNavBarBloc extends Cubit<ATNavBarState> {
  ATNavBarBloc()
      : super(const ATNavBarState(currentIndex: 0, shouldShowNav: true));

  bool ctrlNavVisibility(ScrollNotification notif) {
    if (notif is! ScrollUpdateNotification) return false;
    if (notif.dragDetails == null) return false;
    if (notif.dragDetails!.delta.dy > 0) {
      emit(state.copyWith(shouldShowNav: true));
    } else if (notif.dragDetails!.delta.dy < 0) {
      emit(state.copyWith(shouldShowNav: false));
    }

    return true;
  }

  void goToPage(int index, BuildContext context) {
    final int prevIndex = state.currentIndex;

    final bool hasSeenNotifs = index == 3 ? true : state.hasSeenNotifications;

    emit(ATNavBarState(
      currentIndex: index,
      shouldShowNav: state.shouldShowNav,
      hasSeenNotifications: hasSeenNotifs,
    ));

    if (index == 2) {
      context.pushNamed(ATRoutes.GO_LIVE_TYPE_SELECTION);
      emit(ATNavBarState(
        currentIndex: prevIndex,
        shouldShowNav: false,
        hasSeenNotifications: state.hasSeenNotifications,
      ));
    }
  }

  void resetNotificationSession() {
    emit(state.copyWith(hasSeenNotifications: false));
  }
}
