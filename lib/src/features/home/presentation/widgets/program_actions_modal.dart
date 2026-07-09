import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:amptive/src/features/shows/cubits/cancel_show_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';

import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/shows/presentation/screens/stop_airing_confirmation_screen.dart';

enum SelectedProgramAction {
  subscribe,
  unsubscribe,
  follow,
  unfollow,
  shareLive,
  notInterested,
  report,
}

Future<SelectedProgramAction?> showProgramOptions({
  required BuildContext context,
  required ToggleFollowingCubit toggleFollowingCubit,
  required String targetUserName,
  required String targetUserId,
  String? targetUserProfileUrl,
  String? programType,
  String? contentId,
  String? coverUrl,
  String? programTitle,
}) async {
  // Drop any lingering focus (e.g. a search field) so dismissing the sheet
  // doesn't restore it and bring the keyboard back up.
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<SelectedProgramAction>(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        barrierColor: ATColors.black.withValues(alpha: 0.5),
        backgroundColor: const Color(0xFF1C1C1E), // Apple Music modal background
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24), topRight: Radius.circular(24))),
        builder: (
          _,
        ) {
          return MultiBlocProvider(
            providers: <SingleChildWidget>[
              BlocProvider<ToggleFollowingCubit>.value(
                value: toggleFollowingCubit,
              ),
            ],
            child: SafeArea(
              bottom: true,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 12),
                    const ATModalDismisser(),
                    const SizedBox(height: 24),
                    
                    // Apple Music Style Header
                    Row(
                      children: [
                        if (targetUserProfileUrl != null && targetUserProfileUrl.isNotEmpty)
                          ClipOval(
                            child: ATImgLoader(
                              imgPath: targetUserProfileUrl,
                              width: 32,
                              height: 32,
                              boxFit: BoxFit.cover,
                            ),
                          )
                        else
                          ClipOval(
                            child: SvgPicture.string(
                              ATImgStrings.defaultAvatarSvg,
                              height: 32,
                              width: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            targetUserName,
                            style: context.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF3A3A3C),
                            ),
                            child: const Icon(Icons.close, size: 20, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Group 1: Engagement Actions
                    _ActionGroup(
                      children: [
                        _RenderIconAndText(
                          text: 'Subscribe',
                          leading: const Icon(CupertinoIcons.heart, color: Colors.white, size: 22),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        BlocBuilder<ToggleFollowingCubit, ATAppState<FollowingStatus>>(
                          builder: (BuildContext ctx, __) {
                            final FollowingStatus? currentState =
                                ctx.read<ToggleFollowingCubit>().currentFollowStatus;
                            final bool isFollowing = currentState?.isFollowing ?? false;
                            return _RenderIconAndText(
                              text: isFollowing ? 'Unfollow' : 'Follow',
                              leading: Icon(
                                isFollowing
                                    ? CupertinoIcons.person_badge_minus
                                    : CupertinoIcons.person_badge_plus,
                                color: Colors.white,
                                size: 22,
                              ),
                              onTap: () {
                                ctx.read<ToggleFollowingCubit>().toggleIsFollowing(
                                      targetUserId: targetUserId,
                                    );
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Group 2: Content Actions
                    _ActionGroup(
                      children: [
                        _RenderIconAndText(
                          text: 'Share live',
                          leading: const Icon(Icons.ios_share_rounded, color: Colors.white, size: 22),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                        _RenderIconAndText(
                          text: 'Not interested',
                          leading: const Icon(Icons.visibility_off_outlined, color: Colors.white, size: 22),
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Group 3: Destructive Actions
                    _ActionGroup(
                      children: [
                        _RenderIconAndText(
                          text: programType == 'show'
                              ? 'Stop airing this show'
                              : programType == 'event'
                                  ? 'Delete this event'
                                  : programType == 'episode'
                                      ? 'Delete this episode'
                                      : 'Report',
                          textColor: ATColors.textRedColor,
                          leading: Icon(
                            programType == 'show' ? CupertinoIcons.stop : CupertinoIcons.delete,
                            color: ATColors.textRedColor,
                            size: 22,
                          ),
                          onTap: () async {
                            if (programType == 'show' && contentId != null) {
                              // Dismiss the bottom sheet first
                              Navigator.of(context, rootNavigator: true).pop();
                              
                              // Push the confirmation screen
                              final bool? cancelled = await context.pushNamed<bool>(
                                ATRoutes.stopAiringConfirmationScreen,
                                extra: StopAiringConfirmationScreenParams(
                                  showId: contentId,
                                  title: programTitle ?? 'this show',
                                  coverUrl: coverUrl,
                                ),
                              );
                              
                              if (cancelled == true) {
                                // Additional logic if needed after cancellation
                              }
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        });
}

/// Owner actions for one of the user's own shows (the "..." on the show page):
/// Edit show, View scheduled episodes, Share show, and Stop airing.
Future<void> showOwnerShowOptions({
  required BuildContext context,
  required String showId,
  required String title,
  String? coverUrl,
  VoidCallback? onEditShow,
  VoidCallback? onViewScheduled,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    backgroundColor: const Color(0xFF1C1C1E),
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (BuildContext sheetContext) {
      return SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12),
              const ATModalDismisser(),
              const SizedBox(height: 24),
              _ActionGroup(
                children: <Widget>[
                  _RenderIconAndText(
                    text: 'Edit show',
                    leading: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 22),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      onEditShow?.call();
                    },
                  ),
                  _RenderIconAndText(
                    text: 'View scheduled episodes',
                    leading: const Icon(CupertinoIcons.calendar,
                        color: Colors.white, size: 22),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      onViewScheduled?.call();
                    },
                  ),
                  _RenderIconAndText(
                    text: 'Share show',
                    leading: const Icon(Icons.ios_share_rounded,
                        color: Colors.white, size: 22),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _ActionGroup(
                children: <Widget>[
                  _RenderIconAndText(
                    text: 'Stop airing this show',
                    textColor: ATColors.textRedColor,
                    leading: Icon(CupertinoIcons.stop,
                        color: ATColors.textRedColor, size: 22),
                    onTap: () async {
                      Navigator.of(context, rootNavigator: true).pop();
                      await context.pushNamed<bool>(
                        ATRoutes.stopAiringConfirmationScreen,
                        extra: StopAiringConfirmationScreenParams(
                          showId: showId,
                          title: title.isNotEmpty ? title : 'this show',
                          coverUrl: coverUrl,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}

/// Owner actions for a single episode/event — same design as the owner show
/// sheet, adapted to episode actions.
Future<void> showOwnerEpisodeOptions({
  required BuildContext context,
  VoidCallback? onEditEpisode,
  bool isEvent = false,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  final String noun = isEvent ? 'event' : 'episode';
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    backgroundColor: const Color(0xFF1C1C1E),
    elevation: 0,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24), topRight: Radius.circular(24)),
    ),
    builder: (BuildContext sheetContext) {
      return SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 12),
              const ATModalDismisser(),
              const SizedBox(height: 24),
              _ActionGroup(
                children: <Widget>[
                  _RenderIconAndText(
                    text: 'Edit $noun',
                    leading: const Icon(Icons.edit_outlined,
                        color: Colors.white, size: 22),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      onEditEpisode?.call();
                    },
                  ),
                  _RenderIconAndText(
                    text: 'Share $noun',
                    leading: const Icon(Icons.ios_share_rounded,
                        color: Colors.white, size: 22),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    },
  );
}

class _ActionGroup extends StatelessWidget {
  const _ActionGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E), // Apple Music elevated card background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          final int idx = entry.key;
          final Widget child = entry.value;
          return Column(
            children: [
              child,
              if (idx != children.length - 1)
                Divider(
                  height: 0.5,
                  thickness: 0.5,
                  indent: 54, // Aligns divider with text (16 padding + 24 icon + 14 spacing)
                  color: Colors.white.withValues(alpha: 0.15),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _RenderIconAndText extends StatelessWidget {
  const _RenderIconAndText({
    required this.text,
    required this.leading,
    required this.onTap,
    this.textColor,
  });

  final String text;
  final Widget leading;
  final VoidCallback onTap;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: <Widget>[
              leading,
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: textColor ?? Colors.white,
                    fontSize: 17, // Standard Apple iOS Body Text size
                    fontWeight: FontWeight.w400, // Apple Music uses regular weight for list items
                    letterSpacing: -0.41, // Apple's standard tracking for 17pt SF Pro
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: Colors.white.withValues(alpha: 0.3)),
            ],
          ),
        ),
      ),
    );
  }
}
