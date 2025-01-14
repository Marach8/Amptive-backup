import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/routes.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/add_co_host_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
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
import '../../../../../bloc/main_app/nav_bar_bloc.dart';
import '../../../../../services/create_show/create_show_service.dart' hide getHostList;
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer' as marach show log;
import '../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_audience_view.dart';


class AmptiveGoLiveAudienceView extends StatefulWidget {
  final HostWithNotifier goLiveHost;
  const AmptiveGoLiveAudienceView({super.key, required this.goLiveHost});

  @override
  State<AmptiveGoLiveAudienceView> createState() => _AmptiveGoLiveAudienceViewState();
}

class _AmptiveGoLiveAudienceViewState extends State<AmptiveGoLiveAudienceView> {
  late GoLiveService service;
  late ScrollController _scrollController;

  @override 
  void initState(){
    super.initState();
    service = GetIt.I<GoLiveService>();
    service.initFormControl();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override 
  void dispose(){
    service.dispose();
    super.dispose();
  }


  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      service.scroll2Bottom.value = true;
    } 
    else if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      service.scroll2Bottom.value = false;
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
    final screenWidth = AmptiveHelperFunctions.getScreenWidth(context);
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              
              const Gap(10),
              AmptiveLiveViewHeaderWidget(
                exitIcon: AmptiveCustomContainer(
                onTap: () => context.read<AmptiveNavBarBloc>().goToPage(0),
                color: AmptiveColors.whiteColor.withOpacity(0.1),
                height: 35, width: 35, boxShape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AmptiveColors.black,
                    blurRadius: 10, spreadRadius: 30,
                    offset: const Offset(-20, 0)
                  )
                ],
                child: const Icon(Icons.keyboard_arrow_down),
              ),
              ),
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
                      Text(
                        "🎁",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          overflow: TextOverflow.fade
                        ),
                      ),
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
                      width: AmptiveHelperFunctions.getScreenWidth(context),
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
                            builder: (_, listOfHosts) {
          
                              final cohost1 = listOfHosts.elementAtOrNull(0);
                              final cohost2 = listOfHosts.elementAtOrNull(1);
                              final cohost3 = listOfHosts.elementAtOrNull(2);
                              final cohost4 = listOfHosts.elementAtOrNull(3);
                              final cohost5 = listOfHosts.elementAtOrNull(4);


                              final onlyHost = listOfHosts.every((a) => a.host.profilePicture == null);
                              final hostAndACohost = listOfHosts.where((a) => a.host.profilePicture != null).length == 1;
                              final hostAnd2Cohosts = listOfHosts.where((a) => a.host.profilePicture != null).length == 2;
                              final hostAnd3Cohosts = listOfHosts.where((a) => a.host.profilePicture != null).length == 3;
                              final hostAnd4Cohosts = listOfHosts.where((a) => a.host.profilePicture != null).length == 4;
                              final hostAnd5Cohosts = listOfHosts.every((a) => a.host.profilePicture != null);
                
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    top: onlyHost ? 80 : 6, isHost: true, index: 0,
                                    hostOrCohost: widget.goLiveHost,
                                    service: service,
                                    onTap: (hostOrCohost){},
                                  ),

                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    bottom: hostAndACohost || hostAnd3Cohosts  || 
                                      hostAnd5Cohosts ? 0 : hostAnd2Cohosts || hostAnd4Cohosts ? 30 : null,
                                    left: hostAnd2Cohosts || hostAnd4Cohosts ? width * 0.1 : null,
                                    index: 1, service: service,
                                    hostOrCohost: cohost1,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    bottom: hostAnd2Cohosts || hostAnd3Cohosts || hostAnd4Cohosts || hostAnd5Cohosts ? 30 : null,
                                    left: hostAnd5Cohosts ? width * 0.1 : null,
                                    right: hostAnd2Cohosts || hostAnd3Cohosts || hostAnd4Cohosts ? width * 0.1 : null,
                                    index: 2, service: service,
                                    hostOrCohost: cohost2,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    bottom: hostAnd3Cohosts || hostAnd5Cohosts ? 30 : hostAnd4Cohosts ? 127: null,
                                    //top: hostAnd4Cohosts ? 35: null,
                                    right: hostAnd5Cohosts ? width * 0.1 : null,
                                    left: hostAnd3Cohosts ? width * 0.1 : hostAnd4Cohosts ? 0 : null, 
                                    index: 3, service: service,
                                    hostOrCohost: cohost3,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    top: hostAnd4Cohosts || hostAnd5Cohosts ? 35 : null,
                                    right: hostAnd4Cohosts || hostAnd5Cohosts ? 0 : null, 
                                    index: 4, service: service,
                                    hostOrCohost: cohost4,
                                    onTap: (hostOrCohost){},
                                  ),
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    top: hostAnd5Cohosts ? 35 : null,
                                    left: hostAnd5Cohosts ? 0 : null, 
                                    index: 5, service: service,
                                    hostOrCohost: cohost5,
                                    onTap: (hostOrCohost){},
                                  ),
                                ],
                              );
                            }
                          );
                        }
                      )
                    ),
          
                    AmptiveRebuilderWidget(
                      notifier: service.scroll2Bottom,
                      builder: (_, showIcon, __) {
                        return AnimatedPositioned(
                          right: showIcon ? 15 : -50, bottom: 70,
                          duration: const Duration(milliseconds: 500),
                          child: AmptiveCustomContainer(
                            onTap: () => _scrollToBottom(),
                            color: AmptiveColors.whiteColor.withOpacity(0.1),
                            height: 35, width: 35,
                            boxShape: BoxShape.circle,
                            child: const Icon(Icons.keyboard_double_arrow_down),
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
                        cursorColor: AmptiveColors.whiteColor.withOpacity(0.6),
                        constraints: const BoxConstraints(maxHeight: 40),
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        hintText: AmptiveOtherStrings.COMMENT,
                      ),
                    )
                  );
                }
                return AmptiveCustomContainer(
                  onTap: (){
                    final host = HostWithNotifier(host: Host.empty());
                    if(index == 0){
                      service.hostAddCohost(host, index + 1);
                    }
                    else if(index == 5){
                      service.hostRemoveCohost(host, index + 1);
                    }
                    // else if(index == 2){
                    //   showFollowHostOrCohostDialog(context: context, host: getHostList().first);
                    // }
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
  const RotatedBox(quarterTurns: -45, child: Icon(Icons.logout)),
  const Icon(Icons.mic),
  const Icon(Icons.mic),
  const Icon(Icons.front_hand_outlined),
  const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.GIFT_ICON),
  Icon(Icons.favorite, color: AmptiveColors.notifRed,),
];
