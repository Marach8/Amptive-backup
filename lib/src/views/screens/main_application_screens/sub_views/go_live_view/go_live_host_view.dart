import 'package:amptive/src/bloc/main_app/nav_bar_bloc.dart';
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
import '../../../../../services/create_show/create_show_service.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import 'dart:developer' as marach show log;
import '../../../../../utils/dialogs/go_live_add_cohost_dialog.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_or_cohost_widget.dart';


class AmptiveGoLiveHostView extends StatefulWidget {
  final HostWithNotifier goLiveHost;
  const AmptiveGoLiveHostView({super.key, required this.goLiveHost});

  @override
  State<AmptiveGoLiveHostView> createState() => _AmptiveGoLiveHostViewState();
}

class _AmptiveGoLiveHostViewState extends State<AmptiveGoLiveHostView> {
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
    
    else if (_scrollController.position.atEdge &&
      _scrollController.position.pixels != 0) {
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
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const Gap(10),
              const AmptiveLiveViewHeaderWidget(),

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
                              marach.log('Hello');
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
          
                    AmptiveRebuilderWidget(
                      notifier: service.scroll2Bottom,
                      builder: (_, showIcon, __) {
                        return AnimatedPositioned(
                          right: showIcon ? 15 : -50, bottom: 70,
                          duration: const Duration(milliseconds: 500),
                          child: AmptiveCustomContainer(
                            onTap: () => _scrollToBottom(),
                            color: AmptiveColors.whiteColor.withValues(alpha:0.1),
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
                  onTap: () async{
                    if(index == 5){
                      await showGoLiveHostAddCoHostDialog(context: context);
                    }
                  },
                  margin: index != 5 ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  padding: const EdgeInsets.all(5),
                  radius: 30,
                  child: widget
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
  const RotatedBox(quarterTurns: -45, child: Icon(Icons.logout)),
  const Icon(Icons.add),
];  