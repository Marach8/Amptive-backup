import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/notifications/cubits/notifications_cubit.dart';
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
    return BlocBuilder<ATNavBarBloc, (int, bool, bool)>(
      builder: (_, (int, bool, bool) state) {
        return ATAnimatedSlide(
          shouldSlide: state.$2,
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
                  return Stack(
                    children: <Widget>[
                      _BottomNavItem(
                        selectedImagePath: list.first,
                        unselectedImagePath: list.last,
                        itemIdentityIndex: index,
                      ),
                      BlocBuilder<GetNotificationsCubit,
                          ATAppState<NotificationsResponseModel>>(
                        builder: (BuildContext context,
                            ATAppState<NotificationsResponseModel> notifState) {
                          final NotificationsResponseModel? notifications =
                              context.read<GetNotificationsCubit>().currentNotifications;

                          final int serverUnreadCount =
                              notifications?.unreadCount ?? 0;

                          // Your "has seen" logic (preserved)
                          final bool hasSeenNotifications = state.$3;
                          final int count =
                              hasSeenNotifications ? 0 : serverUnreadCount;

                          if (count == 0) return const SizedBox.shrink();

                          return Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                              constraints: const BoxConstraints(minWidth: 15),
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ATColors.hexECO404,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  count > 99 ? '99+' : '$count',
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.bodySmall
                                      ?.copyWith(fontSize: ATSizes.size10),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                }

                return _BottomNavItem(
                  selectedImagePath: list.first,
                  unselectedImagePath: list.last,
                  itemIdentityIndex: index,
                );
              }).toList(),
            ),
          ),
        );
      },
    );
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
    return BlocSelector<ATNavBarBloc, (int, bool, bool), int>(
      selector: ((int, bool, bool) state) => state.$1,
      builder: (_, int currentNavIndex) {
        final bool isSelected = itemIdentityIndex == currentNavIndex;
        return GestureDetector(
          onTap: () {
            context.read<ATNavBarBloc>().goToPage(itemIdentityIndex, context);
          },
          child: ATAnimatedXFade(
            condition: isSelected,
            firstChild: ATImgLoader(imgPath: selectedImagePath),
            secondChild: ATImgLoader(imgPath: unselectedImagePath),
          ),
        );
      },
    );
  }
}

class ATNavBarBloc extends Cubit<(int, bool, bool)> {
  ATNavBarBloc() : super((0, true, false));

  bool ctrlNavVisibility(ScrollNotification notif) {
    if (notif is! ScrollUpdateNotification) return false;
    if (notif.dragDetails == null) return false;

    if (notif.dragDetails!.delta.dy > 0) {
      emit((state.$1, true, state.$3));
    } else if (notif.dragDetails!.delta.dy < 0) {
      emit((state.$1, false, state.$3));
    }
    return true;
  }

  void goToPage(int index, BuildContext context) {
    final int prevIndex = state.$1;
    final bool currentShowNav = state.$2;
    final bool currentHasSeen = state.$3;

    if (index == 3) {
      context.read<GetNotificationsCubit>().markAllNotificationsAsRead();
    }

    final bool newHasSeen = (index == 3) ? true : currentHasSeen;

    emit((index, currentShowNav, newHasSeen));

    if (index == 2) {
      context.pushNamed(ATRoutes.chooseEventOrShowScreen);
      emit((prevIndex, false, currentHasSeen)); // hide nav bar during live flow
    }
  }

  void resetNotificationSession() {
    emit((state.$1, state.$2, false));
  }
}
