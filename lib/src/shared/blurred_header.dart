import 'dart:io';
import 'dart:ui';

import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../config/utils/colors.dart';

class ATBlurredHeaderWidget extends StatelessWidget {
  const ATBlurredHeaderWidget({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BlocBuilder<BlurredHeaderBloc, bool>(
        builder: (_, bool state) {
          return BackdropFilter(
            filter: state ? ImageFilter.blur(sigmaX: 53, sigmaY: 53)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: ATContainer(
              padding: const EdgeInsets.only(top: 40),
              height: kToolbarHeight + MediaQuery.paddingOf(context).top,
              width: context.screenWidth,
              child: child ?? GestureDetector(
                onTap: () {
                  ATHelperFuncs.hideAnyMountedSnackbar(context);
                  context.pop();
                },
                child: Platform.isAndroid
                  ? Icon(
                    Icons.keyboard_arrow_down, size: 30,
                    color: ATColors.white.withValues(alpha: 0.6),
                  )
                  : ATContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    radius: 5, height: 4, width: 30,
                    color: ATColors.white.withValues(alpha: 0.6),
                    child: const SizedBox.shrink(),
                  ),
              ),
            ),
          );
        }
      ),
    );
  }
}


class BlurredHeaderBloc extends Cubit<bool>{
  BlurredHeaderBloc():super(false);


  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && notification.metrics.axis == Axis.vertical) {
      final double extentBefore = notification.metrics.extentBefore;
      if(extentBefore > 0.0 && !state){
        // log('backdrop is shown');
        // log(notification.metrics.extentInside.toString());
        emit(true);
      }
      else if(extentBefore == 0.0 && state){
        //log('Backdrop is hidden');
        emit(false);
      }
    }

    return true;
  }
}