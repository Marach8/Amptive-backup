import 'dart:ui';

import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/shared/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../../../models/go_live_notification_model.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';
import '../../go_live_export.dart';


class LiveProgramHostView extends StatelessWidget {
  const LiveProgramHostView({super.key, required this.goLiveHost});
  final ObjectWithNotifier<Host> goLiveHost;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AddCohostsBloc>(create: (_) => AddCohostsBloc()),
      ],
      child: _SubWidget(goLiveHost: goLiveHost),
    );
  }
}

class _SubWidget extends StatelessWidget {
  const _SubWidget({required this.goLiveHost});
  final ObjectWithNotifier<Host> goLiveHost;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: SafeArea(
        maintainBottomViewPadding: false,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: const ATImgLoader(
                    imgPath: ATImgStrings.jpeg1,
                    boxFit: BoxFit.fill
                  ),
                ),
              ),
              
              ColoredBox(
                color: ATColors.hex0D0D0D.withValues(alpha: 0.9),
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(10, kToolbarHeight * 0.9, 15, 20),
                      child: GoLiveScreenHeader(),
                    ),
                
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ATContainer(
                        onTap: (){},
                        margin: const EdgeInsets.only(left: 15), radius: 30,
                        padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                        color: ATColors.white.withValues(alpha: 0.1),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ATImgLoader(imgPath: ATImgStrings.GROUP_ICON),
                            const SizedBox(width: 5),
                            Text(
                              ATStrings.SOCIETY,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                overflow: TextOverflow.fade
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 10),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (_, BoxConstraints kst) {
                          final bool isPortrait = kst.maxHeight > kst.maxWidth;
                          return Flex(
                            direction: isPortrait ? Axis.vertical : Axis.horizontal,
                            children: <Widget>[
                              if(isPortrait) Container(
                                height: 250,
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: const HostViewHostNdCohostDisplay()
                              ) else const Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: SizedBox(height: 250, child: HostViewHostNdCohostDisplay())
                                )
                              ),
        
                              const Expanded(child: GoLiveComments()),
                            ],
                          );
                        }
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
          
          resizeToAvoidBottomInset: false,
          bottomSheet: const HostModerationTools(),
        ),
      ),
    );
  }
}

