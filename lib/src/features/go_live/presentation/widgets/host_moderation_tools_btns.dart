import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/notifications_bloc.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_bloc.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/host_moderation_tools_dialog.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global_export.dart';
import '../../../../services/go_live_service/go_live_service.dart';

class GoLiveControlsVisibilityBloc extends Cubit<bool> {
  GoLiveControlsVisibilityBloc() : super(true);

  bool ctrlModerationToolsVisibility(ScrollNotification notif) {
    if (notif is ScrollUpdateNotification) {
      if (notif.dragDetails != null) {
        if (notif.dragDetails!.delta.dy > 0) {
          emit(true);
        } else if (notif.dragDetails!.delta.dy < 0) {
          emit(false);
        }
      }
    }

    return true;
  }
}

class HostModerationToolsBtns extends StatefulWidget {
  const HostModerationToolsBtns({super.key});

  @override
  State<HostModerationToolsBtns> createState() =>
      _HostModerationToolsBtnsState();
}

class _HostModerationToolsBtnsState extends State<HostModerationToolsBtns> {
  late FocusNode _focusNode;
  late TextEditingController _cntrl;
  final ValueNotifier<bool> _isFocusedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _hasTextNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_onFocus);
    _cntrl = TextEditingController()..addListener(_onInput);
  }

  void _onFocus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _isFocusedNotifier.value = _focusNode.hasFocus;
      }
    });
  }

  void _onInput() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _hasTextNotifier.value = _cntrl.text.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isFocusedNotifier.dispose();
    _hasTextNotifier.dispose();
    _cntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ValueListenableBuilder<bool>(
              valueListenable: _isFocusedNotifier,
              builder: (_, bool isFocused, __) {
                if (isFocused) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: () {
                        // ignore: avoid_print
                        print(
                            'Profile image tapped - NOT calling unfocus for debugging');
                        // Removed _focusNode.unfocus() to debug
                      },
                      child: ATCircularImage(
                          diameter: 35,
                          imagePath: getHostList()[5].obj.profilePicture ?? ''),
                    ),
                  );
                }
                return EachGoLiveControlBtn(
                  onTap: () {
                    showHostModerationToolsDialog(context);
                    // context.read<AmptiveGoLiveNotificationBloc>().addTalkingNotification(
                    //   service.coHostsListData.first
                    // );
                  },
                  child: const Icon(Icons.settings, size: 20),
                );
              }),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 5),
            child: ATTextFormField(
              controller: _cntrl,
              disableBlueBorder: true,
              focusNode: _focusNode,
              counterText: '',
              keyboardType: TextInputType.multiline,
              cursorHeight: 20,
              maxLength: 50,
              maxLines: null,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: ATColors.transparent)
              ),
              prefixIcon: const SizedBox(
                width: 10,
              ),
              fillColor: ATColors.white.withValues(alpha: 0.1),
              cursorColor: ATColors.white.withValues(alpha: 0.6),
              constraints: const BoxConstraints(maxHeight: 60),
              contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
              hintText: ATStrings.comment,
            ),
          )),
          ValueListenableBuilder<bool>(
              valueListenable: _isFocusedNotifier,
              builder: (_, bool isFocused, __) {
                // ignore: avoid_print
                print('OUTER: isFocused=$isFocused');
                if (isFocused) {
                  return ValueListenableBuilder<bool>(
                      valueListenable: _hasTextNotifier,
                      builder: (_, bool hasText, __) {
                        // ignore: avoid_print
                        print('INNER: hasText=$hasText');
                        return GestureDetector(
                          onTap: hasText
                              ? () {
                                  final String message = _cntrl.text.trim();
                                  if (message.isNotEmpty) {
                                    context.read<LiveStreamCubit1>()
                                      .sendChat(message);
                                  }
                                  _cntrl.clear();
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.send,
                              color:
                                  hasText ? ATColors.white : ATColors.lightDark,
                            ),
                          ),
                        );
                      }
                    );
                }

                return const _RowOfBtns();
              }),
        ]);
  }
}

class _RowOfBtns extends StatelessWidget {
  const _RowOfBtns();

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = 
      context.watch<LiveStreamCubit1>().state;
    final bool isMicUnmuted = state.isMicEnabled;

    return Row(
      children: <Widget>[
        EachGoLiveControlBtn(
          onTap: () {
            context.read<LiveStreamCubit1>()
              .toggleMicrophone(!isMicUnmuted);
          },
          child: Icon(
            isMicUnmuted ? Icons.mic : Icons.mic_off,
            size: 20
          ),
        ),
        EachGoLiveControlBtn(
          onTap: () {
            context
                .read<AmptiveGoLiveNotificationBloc>()
                .addPinnedMsgNotification(getHostList()[3], 'CO-HOST');
          },
          child: const ATImgLoader(
            imgPath: ATImgStrings.handRaiseIcon,
            height: 20,
            width: 20,
            boxFit: BoxFit.fill,
          ),
        ),
        EachGoLiveControlBtn(
          onTap: () {},
          child: Transform.flip(
              flipX: true, child: const Icon(Icons.reply, size: 20)),
        ),
        EachGoLiveControlBtn(
          onTap: () async {
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
          child: const Icon(
            Icons.add,
          ),
        ),
        EachGoLiveControlBtn(
          onTap: () {
            // context.read<LivestreamBloc>().add(
            //       const SendReactionEvent(emoji: '❤️'),
            //     );
          },
          margin: EdgeInsets.zero,
          child: Icon(
            Icons.favorite,
            color: ATColors.hexECO404,
            size: 20,
          ),
        ),
      ],
    );
  }
}

class EachGoLiveControlBtn extends StatelessWidget {
  const EachGoLiveControlBtn(
      {super.key, required this.child, required this.onTap, this.margin});

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.only(right: 5),
      child: ATContainer(
          alignment: Alignment.center,
          height: 35,
          width: 35,
          onTap: onTap,
          color: ATColors.white.withValues(alpha: 0.1),
          padding: const EdgeInsets.all(5),
          radius: 30,
          child: child),
    );
  }
}
