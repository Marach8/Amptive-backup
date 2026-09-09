import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/custom_rebuilder_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/horiz_slider_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../config/utils/colors.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../widgets/gifting_notification.dart';
import '../widgets/reactions_overlay.dart';

class LiveProgramCohostView extends StatefulWidget {
  const LiveProgramCohostView({super.key});

  @override
  State<LiveProgramCohostView> createState() => _LiveProgramCohostViewState();
}

class _LiveProgramCohostViewState extends State<LiveProgramCohostView> {
  late GoLiveService service;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    service = GetIt.I<GoLiveService>();
    service.initFormControl();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      service.scroll2Bottom.value = true;
    } else if (_scrollController.position.atEdge &&
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
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: <Widget>[
            AmptiveHorizSliderAnimationWidget(
              duration: 15.w,
              child: Row(
                children: <Widget>[
                  Text(
                    ATStrings.live,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(width: 5.w),
                  const ATCircleAvatar(diameter: 5),
                  SizedBox(width: 5.w),
                  Text(
                    "Don't Forget Who you are by glennodyle",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(overflow: TextOverflow.fade),
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  const ReactionsOverlay(),
                  const GiftOverlayOKay(),
                  SizedBox(
                    height: ATHelperFuncs.getScreenHeight(context),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: ATHelperFuncs.getScreenHeight(context) *
                              0.3,
                        ),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            controller: _scrollController,
                            padding:
                                const EdgeInsets.fromLTRB(0, 50, 0, 50),
                            itemCount: service.coHostsListData.length,
                            itemBuilder: (_, int listIndex) {
                              final ObjectWithNotifier<Host> string =
                                  service.coHostsListData
                                      .elementAt(listIndex);
                              return ListTile(
                                horizontalTitleGap: 10,
                                minTileHeight: 50,
                                leading: ATCircularImage(
                                  diameter: 35.h,
                                  imagePath: ATImgStrings.CRIMINAL,
                                ),
                                title: Text(string.obj.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                            color: ATColors.hexC2C2C2)),
                                subtitle: Text(string.obj.username ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                            fontSize: ATSizes.size13)),
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
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: ATColors.black,
                            spreadRadius: 10,
                            blurRadius: 40,
                            offset: const Offset(0, 40))
                      ],
                      child: const SizedBox()),
                  AmptiveRebuilderWidget(
                      notifier: service.scroll2Bottom,
                      builder: (_, bool showIcon, __) {
                        return AnimatedPositioned(
                          right: showIcon ? 15 : -50,
                          bottom: 70,
                          duration: const Duration(milliseconds: 500),
                          child: ATContainer(
                            onTap: () => _scrollToBottom(),
                            color: ATColors.white.withValues(alpha: 0.1),
                            height: 35,
                            width: 35,
                            boxShape: BoxShape.circle,
                            child: const Icon(
                                Icons.keyboard_double_arrow_down),
                          ),
                        );
                      })
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
              children: _listOfWidgets.map((Widget widget) {
                final int index = _listOfWidgets.indexOf(widget);
                if (index == 1) {
                  return Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: ATTextFormField(
                      controller: TextEditingController(),
                      disableBlueBorder: true,
                      cursorHeight: 20,
                      cursorColor: ATColors.white.withValues(alpha: 0.6),
                      constraints: const BoxConstraints(maxHeight: 40),
                      contentPadding:
                          const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      hintText: ATStrings.comment,
                    ),
                  ));
                }
                return ATContainer(
                    margin: index != 5
                        ? EdgeInsets.only(right: 5.w)
                        : EdgeInsets.zero,
                    color: ATColors.white.withValues(alpha: 0.1),
                    padding: const EdgeInsets.all(5),
                    radius: 30,
                    child: widget);
              }).toList()),
        ),
      ),
    );
  }
}

List<Widget> _listOfWidgets = <Widget>[
  const Icon(Icons.settings),
  const Icon(Icons.mic),
  const Icon(Icons.mic),
  const Icon(Icons.front_hand_outlined),
  const RotatedBox(quarterTurns: -45, child: Icon(Icons.logout)),
  const Text('😎'),
];