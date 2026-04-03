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
  });

  final Widget? child;
  final double? paddingFromTop;

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
          kToolbarHeight + MediaQuery.paddingOf(context).top;
    return ClipRect(
      child:
          BlocBuilder<BlurredHeaderCubit, bool>(builder: (_, bool shouldBlur) {
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
                  child: child ?? const ATModalDismisser()),
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
