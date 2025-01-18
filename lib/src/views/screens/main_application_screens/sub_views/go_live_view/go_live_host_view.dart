import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
import 'package:amptive/src/models/generic_response_model.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/models/user_model.dart';
import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/add_co_host_dialog.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/go_live/host_moderation_tools_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../../models/go_live_notification_model.dart';
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer' as marach show log;
import '../../../../../utils/dialogs/go_live/go_live_add_cohost_dialog.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';


class AmptiveGoLiveHostView extends StatefulWidget {
  final HostWithNotifier goLiveHost;
  const AmptiveGoLiveHostView({super.key, required this.goLiveHost});

  @override
  State<AmptiveGoLiveHostView> createState() => _AmptiveGoLiveHostViewState();
}

class _AmptiveGoLiveHostViewState extends State<AmptiveGoLiveHostView> {
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
  Widget build(context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Gap(10),
              const AmptiveLiveViewHeaderWidget(),
              const Gap(30),

              Align(
                alignment: Alignment.centerLeft,
                child: AmptiveCustomContainer(
                  onTap: (){},
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5), radius: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.threePpl),
                      const Gap(5),
                      Text(
                        AmptiveOtherStrings.SOCIETY,
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
                  children: [
                    SizedBox(
                      height: AmptiveHelperFunctions.getScreenHeight(context),
                      child: Column(
                        children: [
                          SizedBox(
                            height: AmptiveHelperFunctions.getScreenHeight(context) * 0.3,
                          ),
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                              itemCount: service.coHostsListData.length,
                              itemBuilder: (_, listIndex){
                                final string = service.coHostsListData.elementAt(listIndex);
                                return ListTile(
                                  horizontalTitleGap: 10,
                                  minTileHeight: 50,
                                  leading: AmptiveCircularContainerWithPictureWidget(
                                    diameter: 35.h,
                                    imagePath: AmptiveImageStrings.CRIMINAL,
                                  ),
                                  title: Text(
                                    string.host.name ?? '',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AmptiveColors.subtitleColor
                                    )
                                  ),
                                  subtitle: Text(
                                    string.host.username ?? '',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontSize: AmptiveFontSizes.size13
                                    )
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                
                    AmptiveCustomContainer(
                      height: 250,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      boxShadow: [
                        BoxShadow(
                          color: AmptiveColors.black,
                          spreadRadius: 10, blurRadius: 40,
                          offset: const Offset(0, 40)
                        )
                      ],
                      child: LayoutBuilder(
                        builder: (_, constraints) {
                          final width = constraints.maxWidth;
          
                          return BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<HostWithNotifier>>(
                            builder: (_, listOfCoHosts) {
                              final onlyHost = listOfCoHosts.isEmpty;
                              final hostAndACohost = listOfCoHosts.length == 1;
                              final hostAndT2Cohosts = listOfCoHosts.length == 2;
                              final hostAnd3Cohosts = listOfCoHosts.length == 3;
                              final hostAnd4Cohosts = listOfCoHosts.length == 4;
                              final hostAnd5Cohosts = listOfCoHosts.length == 5;
                
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  AmptiveLiveHostAndCoHostWidget(
                                    top: 6, isHost: true, index: 0,
                                    hostOrCohost: widget.goLiveHost,
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),

                                  AmptiveLiveHostAndCoHostWidget(
                                    top: 35, left: 0, index: 1,
                                    hostOrCohost: listOfCoHosts.elementAtOrNull(0),
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidget(
                                    top: 35, right: 0, index: 2,
                                    hostOrCohost: listOfCoHosts.elementAtOrNull(1),
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidget(
                                    bottom: 30, right: width * 0.1, index: 3,
                                    hostOrCohost: listOfCoHosts.elementAtOrNull(2),
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidget(
                                    bottom: 30, left: width * 0.1, index: 4,
                                    hostOrCohost: listOfCoHosts.elementAtOrNull(3),
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidget(
                                    bottom: 0, index: 5, service: service,
                                    hostOrCohost: listOfCoHosts.elementAtOrNull(4),
                                    onTap: (hostOrCohost){},
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      )
                    ),

                    BlocBuilder<AmptiveGoLiveNotificationBloc, AmptiveGoLiveNotificationModel>(
                      builder: (_, state) {
                        if(state.notificationType == AmptiveOtherStrings.PINNED){
                          return Positioned(
                            top: 260,
                            child: SizedBox(
                              width: AmptiveHelperFunctions.getScreenWidth(context),
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
                      builder: (_, showIcon, __) {
                        return Positioned(
                          bottom: 70, right: 15,
                          child: AmptiveScalingAnimatedSwitcherWidget(
                            duration: 500,
                            child: showIcon ? AmptiveCustomContainer(
                              key: const ValueKey(1),
                              onTap: () => _scrollToBottom(),
                              color: AmptiveColors.whiteColor.withOpacity(0.1),
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

        bottomSheet: AmptiveCustomContainer(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: AmptiveColors.black,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _listOfWidgets.map(
              (widget){
                final index = _listOfWidgets.indexOf(widget);
                if(index == 1){
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: AmptiveTextFormFieldWidget(
                        controller: TextEditingController(),
                        disableBlueBorder: true,
                        cursorHeight: 20,
                        fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
                        cursorColor: AmptiveColors.whiteColor.withOpacity(0.6),
                        constraints: const BoxConstraints(maxHeight: 40),
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        hintText: AmptiveOtherStrings.COMMENT,
                      ),
                    )
                  );
                }

                return AmptiveCustomContainer(
                  onTap: () async{
                    if(index == 5){
                      final sendInvite = await showGoLiveHostAddCoHostDialog(context: context);
                      if(sendInvite ?? false){
                        showSuccessOrFailureNotification(
                          response: GenericResponseModel(
                            isSuccessful: true,
                            responseMessage: AmptiveOtherStrings.COHOST_INVITE_SENT
                          ),
                          bgColor: AmptiveColors.notifBg,
                          child: const Icon(Icons.check_circle)
                        );
                      }
                    }
                    if(context.mounted && index == 0){
                      showHostModerationToolsDialog(context);
                      // context.read<AmptiveGoLiveNotificationBloc>().addTalkingNotification(
                      //   service.coHostsListData.first
                      // );
                    }
                    if(context.mounted && index == 2){
                      context.read<AmptiveGoLiveNotificationBloc>().addGiftingNotification(
                        service.coHostsListData[2]
                      );
                    }
                    if(context.mounted && index == 3){
                      context.read<AmptiveGoLiveNotificationBloc>().addPinnedMsgNotification(
                        service.coHostsListData[3], 'CO-HOST'
                      );
                    }
                  },
                  margin: index != 5 ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(5),
                  radius: 30, child: widget
                );
              }
            ).toList()
          ),
        ),
      ),
    );
  }
}




List<Widget> _listOfWidgets = [
  const Icon(Icons.settings),
  const Icon(Icons.mic),
  const Icon(Icons.mic),
  const Icon(Icons.front_hand_outlined),
  Transform.flip(flipX: true, child: const Icon(Icons.reply)),
  const Icon(Icons.add),
];  