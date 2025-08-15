import 'dart:ui';

import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_screen_title.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
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


class LiveProgramHostView extends StatefulWidget {
  const LiveProgramHostView({super.key, required this.goLiveHost});
  final ObjectWithNotifier<Host> goLiveHost;

  @override
  State<LiveProgramHostView> createState() => _LiveProgramHostViewState();
}

class _LiveProgramHostViewState extends State<LiveProgramHostView> {
  late GoLiveService service;
  late ScrollController _scrollController;
  late ValueNotifier<bool> _scroll2BottomNotifier;

  @override 
  void initState(){
    super.initState();
    service = GetIt.I<GoLiveService>();
    service.initFormControl();
    _scroll2BottomNotifier = ValueNotifier(false);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override 
  void dispose(){
    service.dispose();
    _scroll2BottomNotifier.dispose();
    super.dispose();
  }


  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _scroll2BottomNotifier.value = true;
    }
    
    else if (_scrollController.position.atEdge &&
      _scrollController.position.pixels != 0) {
      _scroll2BottomNotifier.value = false;
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }


  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      statusBarColor: ATColors.trsprnt,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: const ATImgLoader(
                  imgPath: ATImgStrings.jpeg2,
                  boxFit: BoxFit.fill
                ),
              ),
            ),
            
            Container(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.95),
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
                      margin: const EdgeInsets.only(left: 15),
                      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5), radius: 30,
                      color: ATColors.white.withValues(alpha: 0.1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ATImgLoader(imgPath: ATImgStrings.GROUP_ICON),
                          const Gap(5),
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
              
                  const Gap(10),          
              
                  Expanded(
                    child: Stack(
                      children: <Widget>[
                        SizedBox(
                          height: ATHelperFuncs.getScreenHeight(context),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: ATHelperFuncs.getScreenHeight(context) * 0.3,
                              ),
                              Expanded(
                                child: GoLiveComments(scrollController: _scrollController, service: service),
                              ),
                            ],
                          ),
                        ),
                    
                        HostAndCohostsDisplay(widget: widget, service: service),
              
                        BlocBuilder<AmptiveGoLiveNotificationBloc, AmptiveGoLiveNotificationModel>(
                          builder: (_, AmptiveGoLiveNotificationModel state) {
                            if(state.notificationType == ATStrings.PINNED){
                              return Positioned(
                                top: 260,
                                child: SizedBox(
                                  width: ATHelperFuncs.getScreenWidth(context),
                                  child: AmptiveGoLivePinnedMsgNtfctnWidget(state: state)
                                )
                              );
                            }
              
                            return Positioned(
                              top: 260, left: 15,
                              child: AmptiveGoLiveNotificationsWidget(state: state)
                            );
                            
                          }
                        ),
              
                        AmptiveRebuilderWidget(
                          notifier: _scroll2BottomNotifier,
                          builder: (_, bool showIcon, __) {
                            return Positioned(
                              bottom: 70, right: 15,
                              child: ATScalingSwitcher(
                                duration: 500,
                                child: showIcon ? ATContainer(
                                  key: const ValueKey(1),
                                  onTap: () => _scrollToBottom(),
                                  color: ATColors.white.withOpacity(0.1),
                                  height: 35, width: 35,
                                  boxShape: BoxShape.circle,
                                  child: const Icon(Icons.keyboard_double_arrow_down),
                                ) : const SizedBox.shrink(key: ValueKey(2)),
                              ),
                            );
                          }
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        bottomSheet: const HostModerationTools(),
      ),
    );
  }
}
