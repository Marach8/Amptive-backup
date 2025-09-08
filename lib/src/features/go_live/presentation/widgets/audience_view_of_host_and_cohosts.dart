import 'dart:ui';

import 'package:amptive/src/features/go_live/presentation/widgets/go_live_comments.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/minimized_go_live_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../../../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import '../../../../shared/animated_switcher.dart';
import '../../go_live_export.dart';
import '../widgets/go_live_screen_header.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_audience_view.dart';



class AudienceViewOfHostAndCohostWidget extends StatelessWidget {
  const AudienceViewOfHostAndCohostWidget({super.key,});
  static final GoLiveService service = GoLiveService();

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      height: 250,
      width: context.screenWidth,
      child: LayoutBuilder(
        builder: (_, BoxConstraints constraints) {
          final double width = constraints.maxWidth;
              
          return BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
            builder: (_, List<ObjectWithNotifier<Host>> listOfHosts) {
              
              final ObjectWithNotifier<Host>? cohost1 = listOfHosts.elementAtOrNull(0);
              final ObjectWithNotifier<Host>? cohost2 = listOfHosts.elementAtOrNull(1);
              final ObjectWithNotifier<Host>? cohost3 = listOfHosts.elementAtOrNull(2);
              final ObjectWithNotifier<Host>? cohost4 = listOfHosts.elementAtOrNull(3);
              final ObjectWithNotifier<Host>? cohost5 = listOfHosts.elementAtOrNull(4);
    
    
              final bool onlyHost = listOfHosts.every((ObjectWithNotifier<Host> a) => a.obj.profilePicture == null);
              final bool hostAndACohost = listOfHosts.where((ObjectWithNotifier<Host> a) => a.obj.profilePicture != null).length == 1;
              final bool hostAnd2Cohosts = listOfHosts.where((ObjectWithNotifier<Host> a) => a.obj.profilePicture != null).length == 2;
              final bool hostAnd3Cohosts = listOfHosts.where((ObjectWithNotifier<Host> a) => a.obj.profilePicture != null).length == 3;
              final bool hostAnd4Cohosts = listOfHosts.where((ObjectWithNotifier<Host> a) => a.obj.profilePicture != null).length == 4;
              final bool hostAnd5Cohosts = listOfHosts.every((ObjectWithNotifier<Host> a) => a.obj.profilePicture != null);
                    
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  GoLiveHostWidget(
                    top: onlyHost ? 80 : 6,
                    hostName: 'Emmanuel Nnanna',
                    hostProfilePic: ATImgStrings.jpeg2
                  ),
                  // AmptiveLiveHostAndCoHostWidgetForAudienceView(
                  //   top: onlyHost ? 80 : 6, isHost: true, index: 0,
                  //   hostOrCohost: host,
                  //   service: service,
                  //   onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  // ),
    
                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                    bottom: hostAndACohost || hostAnd3Cohosts  || 
                      hostAnd5Cohosts ? 0 : hostAnd2Cohosts || hostAnd4Cohosts ? 30 : null,
                    left: hostAnd2Cohosts || hostAnd4Cohosts ? width * 0.1 : null,
                    index: 1, service: service,
                    hostOrCohost: cohost1,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                    bottom: hostAnd2Cohosts || hostAnd3Cohosts || hostAnd4Cohosts || hostAnd5Cohosts ? 30 : null,
                    left: hostAnd5Cohosts ? width * 0.1 : null,
                    right: hostAnd2Cohosts || hostAnd3Cohosts || hostAnd4Cohosts ? width * 0.1 : null,
                    index: 2, service: service,
                    hostOrCohost: cohost2,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                    bottom: hostAnd3Cohosts || hostAnd5Cohosts ? 30 : hostAnd4Cohosts ? 127: null,
                    //top: hostAnd4Cohosts ? 35: null,
                    right: hostAnd5Cohosts ? width * 0.1 : null,
                    left: hostAnd3Cohosts ? width * 0.1 : hostAnd4Cohosts ? 0 : null, 
                    index: 3, service: service,
                    hostOrCohost: cohost3,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                    top: hostAnd4Cohosts || hostAnd5Cohosts ? 35 : null,
                    right: hostAnd4Cohosts || hostAnd5Cohosts ? 0 : null, 
                    index: 4, service: service,
                    hostOrCohost: cohost4,
                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                  ),
                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                    top: hostAnd5Cohosts ? 35 : null,
                    left: hostAnd5Cohosts ? 0 : null, 
                    index: 5, service: service,
                    hostOrCohost: cohost5,
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
