import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showAddedOrRemovedSnackbar(
    {required BuildContext context, required String content}) async {
  final bool isRemoved = content == ATStrings.REMOVED_4RM_CAL;
  final Color bgColor =
      isRemoved ? const Color(0xFFE50914) : const Color(0xFF303030);

  return await Flushbar<bool?>(
    safeArea: false,
    flushbarStyle: FlushbarStyle.GROUNDED,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    borderRadius: BorderRadius.zero,
    shouldIconPulse: false,
    backgroundColor: bgColor,
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 250),
    forwardAnimationCurve: Curves.easeOutCubic,
    duration: const Duration(seconds: 4),
    messageText: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      height: 1.3,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              onTap: () => context.pop(true),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      ATStrings.VIEW,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ).show(context);
}

Future<void> showCommunityFollowSnackbar({
  required BuildContext context,
  required String communityName,
  required bool isFollowing,
}) async {
  await Flushbar<void>(
    safeArea: false,
    flushbarStyle: FlushbarStyle.GROUNDED,
    margin: EdgeInsets.zero,
    padding: EdgeInsets.zero,
    borderRadius: BorderRadius.zero,
    shouldIconPulse: false,
    backgroundColor: const Color(0xFF303030),
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: const Duration(milliseconds: 250),
    forwardAnimationCurve: Curves.easeOutCubic,
    duration: const Duration(seconds: 3),
    messageText: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Center(
          child: Text(
            isFollowing
                ? 'You’re now following $communityName'
                : 'You’ve unfollowed $communityName',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  height: 1.3,
                ),
          ),
        ),
      ),
    ),
  ).show(context);
}
