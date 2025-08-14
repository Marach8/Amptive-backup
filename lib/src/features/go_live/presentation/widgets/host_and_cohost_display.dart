import 'dart:ui';

import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_title.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/go_live/host_moderation_tools_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/go_live/go_live_add_cohost_dialog.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';
import '../../go_live_export.dart';



class HostAndCohostsDisplay extends StatelessWidget {
  const HostAndCohostsDisplay({
    super.key,
    required this.widget,
    required this.service,
  });

  final LiveProgramHostView widget;
  final GoLiveService service;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: 250,
      padding: const EdgeInsets.only(left: 20, right: 20),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: ATColors.black,
          spreadRadius: 10, blurRadius: 40,
          offset: const Offset(0, 40)
        )
      ],
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
                  
          return BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
            builder: (_, List<ObjectWithNotifier<Host>> listOfCoHosts) {                
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AmptiveLiveHostAndCoHostWidget(
                    top: 6, isHost: true, index: 0,
                    hostOrCohost: widget.goLiveHost,
                    service: service,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  
                  AmptiveLiveHostAndCoHostWidget(
                    top: 35, left: 0, index: 1,
                    hostOrCohost: listOfCoHosts.elementAtOrNull(0),
                    service: service,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidget(
                    top: 35, right: 0, index: 2,
                    hostOrCohost: listOfCoHosts.elementAtOrNull(1),
                    service: service,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidget(
                    bottom: 30, right: width * 0.1, index: 3,
                    hostOrCohost: listOfCoHosts.elementAtOrNull(2),
                    service: service,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidget(
                    bottom: 30, left: width * 0.1, index: 4,
                    hostOrCohost: listOfCoHosts.elementAtOrNull(3),
                    service: service,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidget(
                    bottom: 0, index: 5, service: service,
                    hostOrCohost: listOfCoHosts.elementAtOrNull(4),
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                ],
              );
            }
          );
        }
      )
    );
  }
}