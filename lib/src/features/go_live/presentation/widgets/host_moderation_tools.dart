
import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/go_live/host_moderation_tools_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../services/go_live_service/go_live_service.dart';


class HostModerationTools extends StatefulWidget {
  const HostModerationTools({super.key});

  @override
  State<HostModerationTools> createState() => _HostModerationToolsState();
}

class _HostModerationToolsState extends State<HostModerationTools> {
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
     // height: 35,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AmptiveRebuilderWidget(
            notifier: _isFocused,
            builder: (_, bool value, __) {
              if(value){
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ATCircularImage(
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
              child: ATTextFormField(
                controller: _cntrl,
                disableBlueBorder: true,
                cursorHeight: 20, maxLength: 50,
                counterText: '', //maxLines: 2,
                focusNode: _focusNode,
                fillColor: ATColors.white.withOpacity(0.1),
                cursorColor: ATColors.white.withOpacity(0.6),
                constraints: const BoxConstraints(maxHeight: 35),
                contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                hintText: ATStrings.COMMENT,
              ),
            )
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

              return Row(
                children: <Widget>[
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
                      // final bool? sendInvite = await showGoLiveHostAddCoHostDialog(context: context);
                      // if(context.mounted && (sendInvite ?? false)){
                      //   showAppNotification(
                      //     context: context,
                      //     icon: const Icon(Icons.check_circle),
                      //     text: ATStrings.COHOST_INVITE_SENT,
                      //     bgColor: ATColors.notifBg,
                      //   );
                      // }
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
  const _RenderBottomSheetButtonsWidget({
    required this.child,
    required this.onTap,
    this.margin
  });
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      margin: margin ?? EdgeInsets.only(right: 5.w),
      color: ATColors.white.withOpacity(0.1),
      padding: const EdgeInsets.all(5),
      radius: 30, child: child
    );
  }
}
