import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';

class ProgressStageLoadingWidget extends StatelessWidget {
  const ProgressStageLoadingWidget({
    super.key,
    required this.stageText,
  });

  final String stageText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 40,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (
                  Widget child,
                  Animation<double> animation,
                ) {
                  return ClipRect(
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeIn,
                        ),
                      ),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  key: ValueKey<String>(stageText),
                  stageText,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 17,
                  ),
                ),
              ),
            ),
            const ATLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
