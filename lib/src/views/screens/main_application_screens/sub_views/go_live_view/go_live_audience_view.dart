import 'package:amptive/src/models/generic_response_model.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/minimized_go_live_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
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
import '../../../../../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../../bloc/main_app/nav_bar_bloc.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import '../../../../widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_audience_view.dart';


class AmptiveGoLiveAudienceView extends StatefulWidget {
  final ObjectWithNotifier<Host> goLiveHost;
  const AmptiveGoLiveAudienceView({super.key, required this.goLiveHost});

  @override
  State<AmptiveGoLiveAudienceView> createState() => _AmptiveGoLiveAudienceViewState();
}

class _AmptiveGoLiveAudienceViewState extends State<AmptiveGoLiveAudienceView> {
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
    super.dispose();
  }


  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      _scroll2BottomNotifier.value = true;
    } 
    else if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
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
    // final screenWidth = AmptiveHelperFunctions.getScreenWidth(context);
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              
              const Gap(10),
              AmptiveLiveViewHeaderWidget(
                exitIcon: AmptiveCustomContainer(
                onTap: (){
                  context.read<AmptiveNavBarBloc>().goToPage(0);
                  showMinimizedGoLiveState();
                },
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
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5), radius: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.GROUP_ICON),
                      const Gap(5),
                      Text(
                        AmptiveStrings.SOCIETY,
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
                                    string.obj.name ?? '',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AmptiveColors.hexC2C2C2
                                    )
                                  ),
                                  subtitle: Text(
                                    string.obj.username ?? '',
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
          
                          return BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
                            builder: (_, listOfHosts) {
          
                              final cohost1 = listOfHosts.elementAtOrNull(0);
                              final cohost2 = listOfHosts.elementAtOrNull(1);
                              final cohost3 = listOfHosts.elementAtOrNull(2);
                              final cohost4 = listOfHosts.elementAtOrNull(3);
                              final cohost5 = listOfHosts.elementAtOrNull(4);


                              final onlyHost = listOfHosts.every((a) => a.obj.profilePicture == null);
                              final hostAndACohost = listOfHosts.where((a) => a.obj.profilePicture != null).length == 1;
                              final hostAnd2Cohosts = listOfHosts.where((a) => a.obj.profilePicture != null).length == 2;
                              final hostAnd3Cohosts = listOfHosts.where((a) => a.obj.profilePicture != null).length == 3;
                              final hostAnd4Cohosts = listOfHosts.where((a) => a.obj.profilePicture != null).length == 4;
                              final hostAnd5Cohosts = listOfHosts.every((a) => a.obj.profilePicture != null);
                
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

        bottomSheet: const GoLiveAudienViewControlsWidget(),
      ),
    );
  }
}





class GoLiveAudienViewControlsWidget extends StatefulWidget {
  const GoLiveAudienViewControlsWidget({super.key});

  @override
  State<GoLiveAudienViewControlsWidget> createState() => _GoLiveAudienViewControlsWidgetState();
}

class _GoLiveAudienViewControlsWidgetState extends State<GoLiveAudienViewControlsWidget> {
  late FocusNode _focusNode;
  late TextEditingController _cntrl;
  late ValueNotifier<bool> _isFocused, _hasText;

  @override 
  void initState(){
    super.initState();
    _focusNode = FocusNode();
    _cntrl = TextEditingController();
    _hasText = ValueNotifier(false);
    _isFocused = ValueNotifier(false);
    _focusNode.addListener(_onFocus);
    _cntrl.addListener(_onInput);
  }

  void _onFocus() => _focusNode.hasFocus ? _isFocused.value = true : _isFocused.value = false;
  void _onInput() => _cntrl.text.isNotEmpty ? _hasText.value = true : _hasText.value = false;

  @override 
  void dispose(){
    _focusNode.dispose();
    _isFocused.dispose();
    _hasText.dispose();
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return AmptiveCustomContainer(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      color: AmptiveColors.black,
      child: Row(
        children: [
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, value, __) {
              if(value){
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: AmptiveCircularContainerWithPictureWidget(
                    diameter: 35,
                    imagePath: getHostList()[9].obj.profilePicture ?? ''
                  ),
                );
              }

              return _RenderAudienceViewButtons(
                onTap: (){},
                child: Transform.flip(flipX: true, child: const Icon(Icons.reply))
              );
            }
          ),

          BlocBuilder<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
            builder: (_, state) {
              final commentIsEnabled = state.first;
              return Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: AmptiveTextFormFieldWidget(
                    controller: _cntrl,
                    focusNode: _focusNode,
                    disableBlueBorder: true,
                    cursorHeight: 20,
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: commentIsEnabled ? AmptiveColors.strokeGreyColor
                      : AmptiveColors.strokeGreyColor.withOpacity(0.3)
                    ),
                    fillColor: commentIsEnabled ? AmptiveColors.fillGreyColor.withOpacity(0.1) 
                      : AmptiveColors.whiteColor.withOpacity(0.01),
                    enabled: commentIsEnabled ? true : false,
                    cursorColor: AmptiveColors.whiteColor.withOpacity(0.6),
                    constraints: const BoxConstraints(maxHeight: 35),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    hintText: AmptiveStrings.COMMENT,
                  ),
                )
              );
            }
          ),
      
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, value, __) {
              if(value){
                return AmptiveRebuilderWidget(
                  notifier: _hasText,
                  builder: (_, value, __) {
                    return GestureDetector(
                      onTap: value ? (){
                        _cntrl.clear();
                        _focusNode.unfocus();
                      } : null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.send,
                          color:value ? AmptiveColors.whiteColor : AmptiveColors.lightDark,
                        ),
                      ),
                    );
                  }
                );
              }

              return BlocBuilder<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                buildWhen: (prev, curr) => prev[1] != curr[1] || prev.last != curr.last,
                builder: (_, state) {
                  final micIsEnabled = state[1];
                  final handRaiseIsEnabled = state.last;
                    
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if(micIsEnabled)_RenderAudienceViewButtons(
                        onTap: (){
                          showFollowHostOrCohostDialog(context: context, host: getHostList().first);
                        },
                        child: const Icon(Icons.mic),
                      ),
                      if(handRaiseIsEnabled)_RenderAudienceViewButtons(
                        onTap: (){
                          showSuccessOrFailureNotification(
                            response: GenericResponseModel(
                              isSuccessful: false,
                              responseMessage: 'You have been kicked out of the live session'
                            ),
                            child: const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.KICK_USER_OUT)
                          );
                        },
                        child: const Icon(Icons.front_hand_outlined),
                      ),
                      _RenderAudienceViewButtons(
                        onTap: (){},
                        child: const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.GIFT_ICON),
                      ),
                      _RenderAudienceViewButtons(
                        onTap: (){},
                        addMargin: false,
                        child: Icon(Icons.favorite, color: AmptiveColors.hexECO404),
                      ),
                    ]
                  );
                }
              );
            }
          ),
        ],
      ),
    );
  }
}


class _RenderAudienceViewButtons extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final bool addMargin;
  const _RenderAudienceViewButtons({
    required this.onTap,
    required this.child,
    this.addMargin = true, 
  });

  @override
  Widget build(context) {
    return AmptiveCustomContainer(
      onTap: onTap,
      margin: addMargin ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
      color: AmptiveColors.whiteColor.withOpacity(0.1),
      padding: const EdgeInsets.all(5),
      radius: 30, child: child
    );
  }
}
