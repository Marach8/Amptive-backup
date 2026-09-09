import 'dart:ui';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final double blurredHeaderHeight =
          kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: BlocBuilder<BlurredHeaderCubit, bool>(
        builder: (_, bool shouldBlur) {
        return RepaintBoundary(
          child: BackdropFilter(
            filter: shouldBlur
                ? ImageFilter.blur(sigmaX: 53, sigmaY: 53)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              padding: EdgeInsets.only(top: paddingFromTop ?? 40),
              height: blurredHeaderHeight,
              width: context.screenWidth,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: child ?? ATModalDismisser(
                    onDismissOverride: onDismissOverride)),
            ),
          ),
        );
      }),
    );
  }
}


class BlurredHeaderWidget2 extends StatelessWidget {
  const BlurredHeaderWidget2({
    super.key,
    this.child,
    this.onDismissOverride,
  });

  final Widget? child;
  final VoidCallback? onDismissOverride;

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
          kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ClipRect(
      child: BlocBuilder<BlurredHeaderCubit, bool>(
        builder: (_, bool shouldBlur) {
        return RepaintBoundary(
          child: BackdropFilter(
            filter: shouldBlur
                ? ImageFilter.blur(sigmaX: 53, sigmaY: 53)
                : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: SizedBox(
              height: blurredHeaderHeight,
              width: context.screenWidth,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    bottom: 10, right: 0, left: 0,
                    child: child ?? ATModalDismisser(
                      onDismissOverride: onDismissOverride),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}


class BlurredHeaderCubit extends Cubit<bool> {
  BlurredHeaderCubit() : super(false);

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification &&
        notification.metrics.axis == Axis.vertical) {
      final double extentBefore = notification.metrics.extentBefore;
      // log('This is the xtent before $extentBefore');
      // log('This is the metric.pixels ${notification.metrics.pixels}');
      // log('This is the dragdetails.delta: ${notification.dragDetails?.delta}');
      // log('This is the dept: ${notification.depth}');

      if (extentBefore > 0.0 && !state) {
        // log('backdrop is shown');
        // log(notification.metrics.extentInside.toString());
        emit(true);
      } else if (extentBefore == 0.0 && state) {
        //log('Backdrop is hidden');
        emit(false);
      }
    }

    return true;
  }
}
