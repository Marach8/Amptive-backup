import 'dart:ui';

import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/routing/route_transition.dart';

class ATBlurredHeaderWidget extends StatelessWidget {
  const ATBlurredHeaderWidget({
    super.key,
    this.child,
    this.paddingFromTop,
    this.onDismissOverride,
  });

  final Widget? child;
  final double? paddingFromTop;
  final VoidCallback? onDismissOverride;

  @override
  Widget build(BuildContext context) {
    final double physicalTopPadding =
        MediaQueryData.fromView(View.of(context)).padding.top;
    final double blurredHeaderHeight = kToolbarHeight + physicalTopPadding;
    return ClipRect(
      child:
          BlocBuilder<BlurredHeaderCubit, bool>(builder: (_, bool shouldBlur) {
        final Widget content = Listener(
          onPointerMove: (event) {
            final notifier = ModalDragNotifier.of(context);
            if (notifier != null) {
              notifier.onDragUpdate(event.delta.dy);
            }
          },
          onPointerUp: (event) {
            final notifier = ModalDragNotifier.of(context);
            if (notifier != null) {
              notifier.onDragEnd(0.0);
            }
          },
          child: RawGestureDetector(
            gestures: {
              ATWinVerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<ATWinVerticalDragGestureRecognizer>(
                () => ATWinVerticalDragGestureRecognizer(),
                (ATWinVerticalDragGestureRecognizer instance) {},
              ),
            },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(top: physicalTopPadding + 8),
              height: blurredHeaderHeight,
              width: context.screenWidth,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: child ??
                      ATModalDismisser(onDismissOverride: onDismissOverride)),
            ),
          ),
        );

        return RepaintBoundary(
          child: shouldBlur
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 53, sigmaY: 53),
                  child: content,
                )
              : content,
        );
      }),
    );
  }
}

class ATWinVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }

  @override
  String get debugDescription => 'ATWinVerticalDrag';
}

class BlurredHeaderCubit extends Cubit<bool> {
  BlurredHeaderCubit() : super(false);

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        notification.metrics.axis == Axis.vertical) {
      final double extentBefore = notification.metrics.extentBefore;

      // Nested scrollables (tab bodies, inner lists) may turn the frost ON,
      // but only the outermost scroll may turn it OFF — an inner list being
      // at its own top doesn't mean the page is at the top.
      if (notification.depth > 0) {
        if (extentBefore > 0.0 && !state) emit(true);
        return true;
      }

      if (extentBefore > 0.0 && !state) {
        emit(true);
      } else if (extentBefore == 0.0 && state) {
        emit(false);
      }
    }

    return true;
  }
}
