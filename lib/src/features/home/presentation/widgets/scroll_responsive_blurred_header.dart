import 'dart:developer' show log;
import 'dart:io';
import 'dart:ui';

import 'package:amptive/src/utils/helpers/extensions/context_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../utils/constants/colors.dart';

class ScrollResponsiveBlurredHeader extends StatelessWidget {
  const ScrollResponsiveBlurredHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BlocBuilder<ScrollResponsiveBlurredHeaderBloc, bool>(
        builder: (_, bool state) {
          return BackdropFilter(
            filter: state ? ImageFilter.blur(sigmaX: 53, sigmaY: 53)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: ATContainer(
              height: kToolbarHeight,
              width: context.screenWidth,
              alignment: Alignment.center,
              child: GestureDetector(
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

class ScrollResponsiveBlurredHeaderBloc extends Cubit<bool>{
  ScrollResponsiveBlurredHeaderBloc():super(false);


  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final double extentBefore = notification.metrics.extentBefore;
      if(extentBefore > 0.0 && !state){
        log('backdrop is shown');
        log(notification.metrics.extentInside.toString());
        emit(true);
      }
      else if(extentBefore == 0.0 && state){
        log('Backdrop is hidden');
        emit(false);
      }
    }

    return true;
  }
}