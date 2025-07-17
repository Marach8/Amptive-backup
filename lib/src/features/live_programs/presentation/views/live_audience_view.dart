import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/minimized_go_live_dialog.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/main_app_shell.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
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
import '../../../../bloc/main_app/go_live_bloc/audience_view/host_moderation_control_bloc.dart';
import '../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../services/go_live_service/go_live_service.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/utils/dialogs/go_live/follow_or_subscribe_dialog.dart';
import '../../../../views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_audience_view.dart';


class ATLiveProgramsAudienceScreen extends StatefulWidget {
  const ATLiveProgramsAudienceScreen({super.key, required this.goLiveHost});
  final ObjectWithNotifier<Host> goLiveHost;

  @override
  State<ATLiveProgramsAudienceScreen> createState() => _ATLiveProgramsAudienceScreenState();
}

class _ATLiveProgramsAudienceScreenState extends State<ATLiveProgramsAudienceScreen> {
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
  Widget build(BuildContext context) {
    // final screenWidth = AmptiveHelperFunctions.getScreenWidth(context);
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              
              const Gap(10),
              AmptiveLiveViewHeaderWidget(
                exitIcon: ATContainer(
                onTap: (){
                  context.read<ATNavBarBloc>().goToPage(0);
                  showMinimizedGoLiveState();
                },
                color: ATColors.white.withOpacity(0.1),
                height: 35, width: 35, boxShape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: ATColors.black,
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
                child: ATContainer(
                  onTap: (){},
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5), radius: 30,
                  color: ATColors.white.withOpacity(0.1),
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
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                              itemCount: service.coHostsListData.length,
                              itemBuilder: (_, int listIndex){
                                final ObjectWithNotifier<Host> string = service.coHostsListData.elementAt(listIndex);
                                return ListTile(
                                  horizontalTitleGap: 10,
                                  minTileHeight: 50,
                                  leading: ATCircularImage(
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
                      width: ATHelperFuncs.getScreenWidth(context),
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
                                  AmptiveLiveHostAndCoHostWidgetForAudienceView(
                                    top: onlyHost ? 80 : 6, isHost: true, index: 0,
                                    hostOrCohost: widget.goLiveHost,
                                    service: service,
                                    onTap: (ObjectWithNotifier<Host>? hostOrCohost){},
                                  ),

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
  Widget build(BuildContext context) {
    return ATContainer(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
      color: ATColors.black,
      child: Row(
        children: <Widget>[
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, bool value, __) {
              if(value){
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ATCircularImage(
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
            builder: (_, List<bool> state) {
              final bool commentIsEnabled = state.first;
              return Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: ATTextFormField(
                    controller: _cntrl,
                    focusNode: _focusNode,
                    disableBlueBorder: true,
                    cursorHeight: 20,
                    hintStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: commentIsEnabled ? ATColors.strokeGreyColor
                      : ATColors.strokeGreyColor.withOpacity(0.3)
                    ),
                    fillColor: commentIsEnabled ? ATColors.hex9E9E9E.withOpacity(0.1) 
                      : ATColors.white.withOpacity(0.01),
                    enabled: commentIsEnabled ? true : false,
                    cursorColor: ATColors.white.withOpacity(0.6),
                    constraints: const BoxConstraints(maxHeight: 35),
                    contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    hintText: ATStrings.COMMENT,
                  ),
                )
              );
            }
          ),
      
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, bool value, __) {
              if(value){
                return AmptiveRebuilderWidget(
                  notifier: _hasText,
                  builder: (_, bool value, __) {
                    return GestureDetector(
                      onTap: value ? (){
                        _cntrl.clear();
                        _focusNode.unfocus();
                      } : null,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.send,
                          color:value ? ATColors.white : ATColors.lightDark,
                        ),
                      ),
                    );
                  }
                );
              }

              return BlocBuilder<AmptiveGoLiveHostModerationToolsBloc, List<bool>>(
                buildWhen: (List<bool> prev, List<bool> curr) => prev[1] != curr[1] || prev.last != curr.last,
                builder: (_, List<bool> state) {
                  final bool micIsEnabled = state[1];
                  final bool handRaiseIsEnabled = state.last;
                    
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if(micIsEnabled)_RenderAudienceViewButtons(
                        onTap: (){
                          showFollowHostOrCohostDialog(context: context, host: getHostList().first);
                        },
                        child: const Icon(Icons.mic),
                      ),
                      if(handRaiseIsEnabled)_RenderAudienceViewButtons(
                        onTap: (){
                          showAppNotification(
                            context: context,
                            icon: const ATImgLoader(imgPath: ATImgStrings.KICK_USER_OUT),
                            text: 'You have been kicked out of the live session',
                            bgColor: ATColors.hexECO404,
                          );
                        },
                        child: const Icon(Icons.front_hand_outlined),
                      ),
                      _RenderAudienceViewButtons(
                        onTap: (){},
                        child: const ATImgLoader(imgPath: ATImgStrings.GIFT_ICON),
                      ),
                      _RenderAudienceViewButtons(
                        onTap: (){},
                        addMargin: false,
                        child: Icon(Icons.favorite, color: ATColors.hexECO404),
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
  const _RenderAudienceViewButtons({
    required this.onTap,
    required this.child,
    this.addMargin = true, 
  });
  final VoidCallback onTap;
  final Widget child;
  final bool addMargin;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      margin: addMargin ? EdgeInsets.only(right: 5.w) : EdgeInsets.zero,
      color: ATColors.white.withOpacity(0.1),
      padding: const EdgeInsets.all(5),
      radius: 30, child: child
    );
  }
}
