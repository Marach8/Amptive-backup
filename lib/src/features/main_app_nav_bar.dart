import 'dart:async' show unawaited;

import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/prepared_cover_art.dart';
import 'package:amptive/src/features/notifications/cubits/notifications_cubit.dart';
import 'package:amptive/src/features/notifications/data/models/get_notifications_response_model.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/custom_container_widget.dart';

/// The bottom menu for browse pages. The [Hero] pins it visually in place
/// during page-to-page transitions (both pages carry it at the same spot,
/// so it appears static while content slides), while modal detail routes —
/// which don't carry it — slide up in front of it.
class AppBottomMenu extends StatelessWidget {
  const AppBottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Hero(
      tag: 'app-bottom-menu',
      child: Material(
        type: MaterialType.transparency,
        child: MainAppBottomNav(),
      ),
    );
  }
}

class MainAppBottomNav extends StatelessWidget {
  const MainAppBottomNav({super.key});

  static final List<List<String>> listOfIcons = <List<String>>[
    <String>[ATImgStrings.filledHome, ATImgStrings.outlinedHome],
    <String>[ATImgStrings.filledSearch, ATImgStrings.outlinedSearch],
    <String>[ATImgStrings.filledBroadCast, ATImgStrings.outlinedBroadCast],
    <String>[ATImgStrings.filledBell, ATImgStrings.outlinedBell],
  ];

  static const List<String> semanticLabels = <String>[
    'Home',
    'Discover',
    'Go live',
    'Notifications',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ATNavBarBloc, (int, bool, bool)>(
      builder: (_, (int, bool, bool) state) {
        final bool disableAnimations =
            MediaQuery.maybeOf(context)?.disableAnimations ?? false;
        return ATAnimatedSlide(
          shouldSlide: state.$2,
          startOffset: const Offset(0, 1.5),
          endOffset: const Offset(0, 0),
          duration: disableAnimations ? 0 : 220,
          curve: Curves.easeOutCubic,
          child: ATContainer(
            color: ATColors.black,
            padding: EdgeInsets.only(
              top: 8,
              bottom: MediaQuery.paddingOf(context).bottom > 0
                  ? MediaQuery.paddingOf(context).bottom
                  : 12, // Adaptive padding for notched vs non-notched phones
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: listOfIcons.map((List<String> list) {
                final int index = listOfIcons.indexOf(list);

                Widget? badge;
                if (index == 3) {
                  badge = BlocBuilder<GetNotificationsCubit,
                      ATAppState<NotificationsResponseModel>>(
                    builder: (BuildContext context,
                        ATAppState<NotificationsResponseModel> notifState) {
                      final NotificationsResponseModel? notifications = context
                          .read<GetNotificationsCubit>()
                          .currentNotifications;

                      final int serverUnreadCount =
                          notifications?.unreadCount ?? 0;
                      final bool hasSeenNotifications = state.$3;
                      final int count =
                          hasSeenNotifications ? 0 : serverUnreadCount;

                      if (count == 0) return const SizedBox.shrink();

                      return Positioned(
                        top: -5,
                        right: -10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          constraints: const BoxConstraints(minWidth: 16),
                          height: 16,
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
                  );
                }

                return _BottomNavItem(
                  selectedImagePath: list.first,
                  unselectedImagePath: list.last,
                  itemIdentityIndex: index,
                  semanticLabel: semanticLabels[index],
                  badge: badge,
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
    required this.semanticLabel,
    this.badge,
  });

  final String selectedImagePath, unselectedImagePath;
  final int itemIdentityIndex;
  final String semanticLabel;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ATNavBarBloc, (int, bool, bool), int>(
      selector: ((int, bool, bool) state) => state.$1,
      builder: (_, int currentNavIndex) {
        final bool isSelected = itemIdentityIndex == currentNavIndex;
        final bool disableAnimations =
            MediaQuery.maybeOf(context)?.disableAnimations ?? false;

        Widget iconContent = ATAnimatedXFade(
          condition: isSelected,
          firstChild: ATImgLoader(imgPath: selectedImagePath),
          secondChild: ATImgLoader(imgPath: unselectedImagePath),
          duration: disableAnimations ? 0 : 200,
        );

        if (badge != null) {
          iconContent = Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              iconContent,
              badge!,
            ],
          );
        }

        return Expanded(
          child: Semantics(
            button: true,
            selected: itemIdentityIndex == 2 ? null : isSelected,
            label: semanticLabel,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (itemIdentityIndex == 2) {
                  HapticFeedback.lightImpact();
                } else {
                  HapticFeedback.selectionClick();
                }
                context
                    .read<ATNavBarBloc>()
                    .goToPage(itemIdentityIndex, context);
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                child: ExcludeSemantics(child: iconContent),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ATNavBarBloc extends Cubit<(int, bool, bool)> {
  ATNavBarBloc() : super((0, true, false));

  /// A new authenticated dashboard must never inherit a temporarily hidden
  /// navigation state from a previous session or an interrupted Live flow.
  void resetForAuthenticatedDashboard() {
    emit((0, true, false));
  }

  bool ctrlNavVisibility(ScrollNotification notif) {
    // Disabled auto-hide feature based on user preference.
    // The bottom menu will remain fixed during scrolling.
    return false;
  }

  void goToPage(int index, BuildContext context) {
    final int prevIndex = state.$1;
    final bool currentShowNav = state.$2;
    final bool currentHasSeen = state.$3;

    if (index == 2) {
      if (!currentShowNav) return;
      // Warm the next create-form's random cover (image + palette) while
      // the user is still choosing between show and event, so the form
      // opens fully rendered with zero on-the-spot work. Delayed past the
      // chooser's slide-up so the warm-up never competes with it.
      unawaited(Future<void>.delayed(
          const Duration(milliseconds: 600), PreparedCoverArt.prepareNext));
      emit((prevIndex, false, currentHasSeen));
      amptiveAppRouter.pushNamed(ATRoutes.chooseEventOrShowScreen).then((_) {
        if (!isClosed) emit((prevIndex, true, state.$3));
      });
      return;
    }

    // Regular tab switches return to the dashboard first. The Live action
    // is handled above so its bottom-up presentation is never preceded by a
    // horizontal route-pop animation.
    amptiveAppRouter.routerDelegate.navigatorKey.currentState
        ?.popUntil((Route<dynamic> route) => route.isFirst);

    if (index == 3) {
      context.read<GetNotificationsCubit>().markAllNotificationsAsRead();
    }

    final bool newHasSeen = (index == 3) ? true : currentHasSeen;

    emit((index, currentShowNav, newHasSeen));
  }

  void resetNotificationSession() {
    emit((state.$1, state.$2, false));
  }
}
