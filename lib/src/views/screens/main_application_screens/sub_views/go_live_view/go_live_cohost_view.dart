import 'dart:ui';

import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';

import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';


class AmptiveGoLiveCohostView extends StatefulWidget {
  const AmptiveGoLiveCohostView({super.key});

  @override
  State<AmptiveGoLiveCohostView> createState() => _AmptiveGoLiveCohostViewState();
}

class _AmptiveGoLiveCohostViewState extends State<AmptiveGoLiveCohostView> {
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
      // if (!_showScrollIcon) {
      //   setState(() {
      //     _showScrollIcon = true;
      //   });
      // }
    } 
    else if (_scrollController.position.atEdge &&
        _scrollController.position.pixels != 0) {
      // Hide the icon when at the bottom
      service.scroll2Bottom.value = false;
      // if (_showScrollIcon) {
      //   setState(() {
      //     _showScrollIcon = false;
      //   });
      // }
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
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            
            AmptiveHorizSliderAnimationWidget(
                    duration: 15.w,
                    child: Row(
                      children: [
                        Text(
                          ATStrings.LIVE,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Gap(5.w),
                        const AmptiveCircleAvatarWidget(diameter: 5),
                        Gap(5.w),
                        Text(
                          // maxLines: 1,
                          "Don't Forget Who you are by glennodyle",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            overflow: TextOverflow.fade
                          ),
                        )
                      ],
                    ),
                  ),
        
        
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
                                  imagePath: ATImgStrings.CRIMINAL,
                                ),
                                title: Text(
                                  string.obj.name ?? '',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: ATColors.hexC2C2C2
                                  )
                                ),
                                subtitle: Text(
                                  string.obj.username ?? '',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontSize: ATFontSizes.size13
                                  )
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
              
                  ATContainer(
                    height: 250,
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    boxShadow: [
                      BoxShadow(
                        color: ATColors.black,
                        spreadRadius: 10, blurRadius: 40,
                        offset: const Offset(0, 40)
                      )
                    ],
                    child: LayoutBuilder(
                      builder: (_, constraints) {
                        final width = constraints.maxWidth;

                        return AmptiveRebuilderWidget(
                          notifier: service.goLiveHostListNotifier,
                          shouldDispose: true,
                          builder: (_, listOfHosts, __) {
                            // final onlyHost = listOfHosts.length == 1;
                            // final hostAndACohost = listOfHosts.length == 2;
                            // final hostAndT2Cohosts = listOfHosts.length == 3;
                            // final hostAnd3Cohosts = listOfHosts.length == 4;
                            // final hostAnd4Cohosts = listOfHosts.length == 5;
                            // final hostAnd5Cohosts = listOfHosts.length == 6;
              
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                AmptiveLiveHostAndCoHostWidget(
                                  top: 6, isHost: true, index: 0,
                                  hostOrCohost: listOfHosts.elementAt(0),
                                  service: service,
                                  onTap: (hostOrCohost){},
                                ),
                                AmptiveLiveHostAndCoHostWidget(
                                  top: 35, left: 0, index: 1,
                                  hostOrCohost: listOfHosts.elementAt(1),
                                  service: service,
                                  onTap: (hostOrCohost){},
                                ),
                                AmptiveLiveHostAndCoHostWidget(
                                  top: 35, right: 0, index: 2,
                                  hostOrCohost: listOfHosts.elementAt(2),
                                  service: service,
                                  onTap: (hostOrCohost){},
                                ),
                                AmptiveLiveHostAndCoHostWidget(
                                  bottom: 30, right: width * 0.1, index: 3,
                                  hostOrCohost: listOfHosts.elementAt(3),
                                  service: service,
                                  onTap: (hostOrCohost){},
                                ),
                                AmptiveLiveHostAndCoHostWidget(
                                  bottom: 30, left: width * 0.1, index: 4,
                                  hostOrCohost: listOfHosts.elementAt(4),
                                  service: service,
                                  onTap: (hostOrCohost){},
                                ),
                                AmptiveLiveHostAndCoHostWidget(
                                  bottom: 0, index: 5, service: service,
                                  hostOrCohost: listOfHosts.elementAt(5),
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
                        child: ATContainer(
                          onTap: () => _scrollToBottom(),
                          color: ATColors.white.withOpacity(0.1),
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

        bottomSheet: ATContainer(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: ATColors.black,
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
                        cursorColor: ATColors.white.withOpacity(0.6),
                        constraints: const BoxConstraints(maxHeight: 40),
                        contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                        hintText: ATStrings.COMMENT,
                      ),
                    )
                  );
                }
                return ATContainer(
                  margin: index != 5 ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
                  color: ATColors.white.withOpacity(0.1),
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
  const Text('😎'),
];

