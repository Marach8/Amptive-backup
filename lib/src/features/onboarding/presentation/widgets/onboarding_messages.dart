import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';

class OnboardingMessages extends StatelessWidget {
  const OnboardingMessages({
    super.key,
    required this.pageController
  });

  final PageController pageController;

  static const Map<String, String> _messages = <String, String>{
    'Your Voice. Your Rules. Your Revenue': 'Host live audio shows, and events in one place',
    'Explore Shows and Events in One Place': 'Host live audio shows, and events in one place',
    'Join and Connect in 20+ Communities': 'Explore, create and connect in communities that inspire you',
  };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pageController,
      builder: (_, __) {
        final int currentPage = pageController.page?.toInt() ?? 0;
        final String title = _messages.keys.elementAt(currentPage);
        final String message = _messages[title] ?? '';
        return ATFadingSwitcher(
          child: Column(
            key: ValueKey<String>(title),
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title, maxLines: 2,
                textAlign: TextAlign.center,
                style: context.textTheme.displayMedium?.copyWith(
                  fontSize: 24, height: 1,
                  letterSpacing: 0.4
                )
              ),
              const SizedBox(height: 10),
              Text(
                message, maxLines: 3,
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  fontSize: 16, height: 1.25,
                  color: ATColors.hexCDCDCD
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
