import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/models/generic_response_model.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/utils/dialogs/go_live/host_moderation_tools_dialog.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
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
import '../../../../../bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
import '../../../../../models/go_live_notification_model.dart';
import '../../../../../services/go_live_service/go_live_service.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../../utils/dialogs/go_live/go_live_add_cohost_dialog.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_header_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_host_widget_for_host_view.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_go_live/go_live_notification_widget.dart';


class AmptiveGoLiveHostView extends StatefulWidget {
  final ObjectWithNotifier<Host> goLiveHost;
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
                  padding: const EdgeInsets.fromLTRB(5, 5, 10, 5), radius: 30,
                  color: AmptiveColors.whiteColor.withOpacity(0.1),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.GROUP_ICON),
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
                            builder: (_, listOfCoHosts) {                
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

        bottomSheet: const GoLiveHostViewBottomSheet(),
      ),
    );
  }
}




class GoLiveHostViewBottomSheet extends StatefulWidget {
  const GoLiveHostViewBottomSheet({super.key});

  @override
  State<GoLiveHostViewBottomSheet> createState() => _GoLiveHostViewBottomSheetState();
}

class _GoLiveHostViewBottomSheetState extends State<GoLiveHostViewBottomSheet> {
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
     // height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, value, __) {
              if(value){
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: AmptiveCircularContainerWithPictureWidget(
                    diameter: 35,
                    imagePath: getHostList()[5].obj.profilePicture ?? ''
                  ),
                );
              }
              return _RenderBottomSheetButtonsWidget(
                onTap: (){
                  showHostModerationToolsDialog(context);
                  // context.read<AmptiveGoLiveNotificationBloc>().addTalkingNotification(
                  //   service.coHostsListData.first
                  // );
                },
                child: const Icon(Icons.settings),
              );
            }
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: AmptiveTextFormFieldWidget(
                controller: _cntrl,
                disableBlueBorder: true,
                cursorHeight: 20, maxLength: 50,
                counterText: '', //maxLines: 2,
                focusNode: _focusNode,
                fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
                cursorColor: AmptiveColors.whiteColor.withOpacity(0.6),
                constraints: const BoxConstraints(maxHeight: 35),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                hintText: AmptiveOtherStrings.COMMENT,
              ),
            )
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

              return Row(
                children: [
                  _RenderBottomSheetButtonsWidget(
                    onTap: (){
                      context.read<AmptiveGoLiveNotificationBloc>().addGiftingNotification(
                        getHostList()[5]
                      );
                    },
                    child: const Icon(Icons.mic),
                  ),
                  _RenderBottomSheetButtonsWidget(
                    onTap: (){
                      context.read<AmptiveGoLiveNotificationBloc>().addPinnedMsgNotification(
                        getHostList()[3], 'CO-HOST'
                      );
                    },
                    child: const Icon(Icons.front_hand_outlined),
                  ),
                  _RenderBottomSheetButtonsWidget(
                    onTap: (){},
                    child: Transform.flip(flipX: true, child: const Icon(Icons.reply)),
                  ),
                  _RenderBottomSheetButtonsWidget(
                    onTap: ()async{
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
                    },
                    margin: EdgeInsets.zero,
                    child: const Icon(Icons.add),
                  ),
                ],
              );
            }
          ),
        ]
      ),
    );
  }
}


class _RenderBottomSheetButtonsWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onTap;
  const _RenderBottomSheetButtonsWidget({
    required this.child,
    required this.onTap,
    this.margin
  });

  @override
  Widget build(context) {
    return AmptiveCustomContainer(
      onTap: onTap,
      margin: margin ?? EdgeInsets.only(right: 5.w),
      color: AmptiveColors.whiteColor.withOpacity(0.1),
      padding: const EdgeInsets.all(5),
      radius: 30, child: child
    );
  }
}
