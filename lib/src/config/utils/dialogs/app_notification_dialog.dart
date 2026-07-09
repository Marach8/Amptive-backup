import 'package:amptive/src/config/utils/colors.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../shared/custom_container_widget.dart';

Future<dynamic> showAppNotification(
    {required BuildContext context,
    Widget? icon = const Icon(Icons.check_circle),
    required String text,
    int? duration,
    Color? bgColor}) async {
  return await Flushbar<dynamic>(
    backgroundColor: ATColors.transparent,
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: duration ?? 5),
    messageText: Center(
      child: ATContainer(
        radius: 10,
        color: bgColor ?? ATColors.notifBg,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (icon != null) icon,
            if (icon != null) const SizedBox(width: 10),
            Flexible(
              child: Text(
                text,
                maxLines: 2,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    ),
  ).show(context);
}

enum NotificationType { normal, success, failure }

Future<dynamic> showAppNotification2({
  required BuildContext context,
  String? title,
  required String text,
  NotificationType type = NotificationType.normal,
  int? duration,
}) async {
  // Clean the text: strip leading dots/bullets, then shorten verbose messages
  String rawText = text.replaceFirst(RegExp(r'^[\u2022\u00B7\.\s]+'), '').trim();

  // Rewrite known verbose backend messages into short, friendly subtexts
  String shortenMessage(String msg) {
    final String lower = msg.toLowerCase();
    if (lower.contains('valid email') || lower.contains('invalid email') || lower.contains('must contain @')) return 'Please enter a valid email address.';
    if (lower.contains('already exists') || lower.contains('already taken') || lower.contains('already registered')) {
      if (lower.contains('username')) return 'This username is already taken.';
      if (lower.contains('phone')) return 'This phone number is already registered.';
      if (lower.contains('email')) return 'This email is already registered.';
      return 'This is already registered or taken.';
    }
    if (lower.contains('not found') || lower.contains('does not exist')) {
      if (lower.contains('email')) return 'We couldn\'t find that email.';
      return 'We couldn\'t find that account.';
    }
    if (lower.contains('incorrect password') || lower.contains('wrong password')) return 'The password you entered is incorrect.';
    if (lower.contains('too many') || lower.contains('rate limit')) return 'Too many attempts. Try again later.';
    if (lower.contains('expired') && lower.contains('otp')) return 'Your code has expired. Request a new one.';
    if (lower.contains('invalid') && lower.contains('otp')) return 'That code doesn\'t match. Try again.';
    if (lower.contains('network') || lower.contains('connection') || lower.contains('timeout')) return 'Check your internet and try again.';
    if (lower.contains('server') || lower.contains('internal')) return 'Our servers are busy. Try again shortly.';
    // Cap at 80 chars max if nothing matched
    if (msg.length > 80) return '${msg.substring(0, 77)}...';
    return msg;
  }

  final String cleanText = shortenMessage(rawText);

  // Intelligent fallback title generator based on the message context
  String getSmartTitle(String message, NotificationType notifType) {
    final String lower = message.toLowerCase();
    if (notifType == NotificationType.failure) {
      // Specific compound patterns first (order matters!)
      if (lower.contains('already exists') || lower.contains('already taken') || lower.contains('already registered') || lower.contains('already in use')) return 'Already Taken';
      if (lower.contains('not found') || lower.contains('does not exist') || lower.contains('no account')) return 'Account Not Found';
      if (lower.contains('incorrect password') || lower.contains('wrong password')) return 'Incorrect Password';
      if (lower.contains('too many') || lower.contains('rate limit')) return 'Too Many Attempts';
      if (lower.contains('expired')) return 'Session Expired';
      if (lower.contains('network') || lower.contains('connection') || lower.contains('internet') || lower.contains('timeout')) return 'No Internet Connection';
      if (lower.contains('server') || lower.contains('500') || lower.contains('unavailable') || lower.contains('internal')) return 'Server Unavailable';
      if (lower.contains('permission') || lower.contains('access') || lower.contains('denied') || lower.contains('unauthorized')) return 'Permission Denied';
      if (lower.contains('older than') || lower.contains('13 years') || lower.contains('age restriction')) return 'Age Restriction';
      // Broad single-keyword fallbacks last
      if (lower.contains('photo') || lower.contains('image') || lower.contains('picture') || lower.contains('selfie')) return 'Photo Verification Failed';
      if (lower.contains('verify') || lower.contains('code') || lower.contains('otp')) return 'Verification Failed';
      if (lower.contains('email')) return 'Invalid Email Address';
      if (lower.contains('password')) return 'Password Issue';
      if (lower.contains('payment') || lower.contains('wallet') || lower.contains('fund')) return 'Payment Failed';
      if (lower.contains('upload') || lower.contains('file')) return 'Upload Failed';
      if (lower.contains('login') || lower.contains('sign in') || lower.contains('credential')) return 'Login Failed';
      if (lower.contains('register') || lower.contains('sign up')) return 'Registration Failed';
      if (lower.contains('user') || lower.contains('account') || lower.contains('profile')) return 'Account Issue';
      return 'Something Went Wrong';
    } else if (notifType == NotificationType.success) {
      if (lower.contains('photo') || lower.contains('image')) return 'Photo Saved';
      if (lower.contains('email')) return 'Email Verified';
      if (lower.contains('password')) return 'Password Updated';
      if (lower.contains('profile')) return 'Profile Updated';
      if (lower.contains('payment') || lower.contains('wallet')) return 'Payment Successful';
      if (lower.contains('upload')) return 'Upload Complete';
      return 'All Done!';
    }
    return 'Heads Up';
  }

  final String finalTitle = title ?? getSmartTitle(cleanText, type);

  final bool isError = type == NotificationType.failure;

  if (isError) {
    // PS5 controller-like aggressive rumble (4 rapid heavy thuds)
    for (int i = 0; i < 4; i++) {
      Future<void>.delayed(Duration(milliseconds: i * 60), () {
        HapticFeedback.heavyImpact();
      });
    }
  }

  return await Flushbar<dynamic>(
    safeArea: !isError,
    flushbarStyle: isError ? FlushbarStyle.GROUNDED : FlushbarStyle.FLOATING,
    margin: isError ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    padding: isError ? EdgeInsets.zero : const EdgeInsets.fromLTRB(24, 16, 16, 16),
    borderRadius: isError ? BorderRadius.zero : BorderRadius.circular(16),
    shouldIconPulse: false,
    backgroundColor: isError ? const Color(0xFFE50914) : const Color(0xFF303030), // Netflix Red for errors
    backgroundGradient: isError ? null : switch (type) {
      NotificationType.failure => null, // Unreachable but required for switch exhaustiveness
      NotificationType.success => const LinearGradient(
          colors: <Color>[Color(0xFF00C853), Color(0xFF64DD17)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      NotificationType.normal => const LinearGradient(
          colors: <Color>[Color(0xFF9370FF), Color(0xFF7449FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
    },
    boxShadows: isError ? null : const <BoxShadow>[
      BoxShadow(
        color: Colors.black26,
        offset: Offset(0, 8),
        blurRadius: 20,
      ),
    ],
    flushbarPosition: FlushbarPosition.TOP,
    animationDuration: isError ? const Duration(milliseconds: 250) : const Duration(milliseconds: 500),
    forwardAnimationCurve: Curves.easeOutCubic,
    duration: Duration(seconds: duration ?? (isError ? 3 : 5)), // Shorter duration for simple banners
    icon: isError ? null : switch (type) {
      NotificationType.normal => const Icon(
          Icons.info_outline,
          color: Colors.white,
          size: 36,
        ),
      NotificationType.success => const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 36,
        ),
      NotificationType.failure => null,
    },
    messageText: isError
        ? SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              child: Center(
                child: Text(
                  cleanText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.3,
                      ),
                ),
              ),
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                finalTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      height: 1.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                cleanText,
                maxLines: 3,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      height: 1.3,
                    ),
              ),
            ],
          ),
  ).show(context);
}

Future<void> showDrawerNotification({
  required BuildContext context,
  required String text,
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
            text,
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
