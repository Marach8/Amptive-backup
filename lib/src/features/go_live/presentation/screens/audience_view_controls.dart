import 'dart:developer' show log;

import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../go_live_export.dart';


typedef _InputState = ({bool isFocused, bool hasText});
class AudienceViewControls extends StatefulWidget {
  const AudienceViewControls({super.key});

  @override
  State<AudienceViewControls> createState() =>
      _AudienceViewControlsState();
}

class _AudienceViewControlsState extends State<AudienceViewControls> {
  late FocusNode _focusNode;
  late TextEditingController _cntrl;

  final ValueNotifier<_InputState> _inputNotifier =
      ValueNotifier<_InputState>((isFocused: false, hasText: false));

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode()..addListener(_onFocus);
    _cntrl = TextEditingController()..addListener(_onInput);
  }

  void _onFocus() {
    final bool hasFocus = _focusNode.hasFocus;
    final _InputState current = _inputNotifier.value;
    if (current.isFocused == hasFocus) return;

    _inputNotifier.value = (
      isFocused: hasFocus,
      hasText: current.hasText,
    );
  }

  void _onInput() {
    final bool hasText = _cntrl.text.isNotEmpty;
    final _InputState current = _inputNotifier.value;
    if (current.hasText == hasText) return;

    _inputNotifier.value = (
      isFocused: current.isFocused,
      hasText: hasText,
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _cntrl.dispose();
    _inputNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String profilePic = context.read<LocalUserDataCubit>()
      .currentUserData?.profilePhoto ?? '';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ValueListenableBuilder<_InputState>(
          valueListenable: _inputNotifier,
          builder: (_, _InputState state, __) {
            if (state.isFocused) {
              return Padding(
                padding: const EdgeInsets.only(right: 15),
                child: InkWell(
                  onTap: () => _focusNode.unfocus(),
                  child: ATCircularImage(
                    diameter: 35,
                    imagePath: profilePic,
                  ),
                ),
              );
            }
            return EachGoLiveControlBtn(
              onTap: (){},
              child: Transform.flip(
                flipX: true,
                child: const Icon(Icons.reply, size: 20),
              ),
            );
          },
        ),
    
        Expanded(
          child: Material(
            color: ATColors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: ATTextFormField(
                controller: _cntrl,
                focusNode: _focusNode,
                disableBlueBorder: true,
                counterText: '',
                keyboardType: TextInputType.multiline,
                cursorHeight: 20,
                maxLength: 50,
                maxLines: null,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: ATColors.transparent),
                ),
                prefixIcon: const SizedBox(width: 10),
                fillColor: ATColors.white.withValues(alpha: 0.1),
                cursorColor: ATColors.white.withValues(alpha: 0.6),
                constraints: const BoxConstraints(maxHeight: 60),
                contentPadding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                hintText: ATStrings.comment,
                suffixIcon: ValueListenableBuilder<_InputState>(
                  valueListenable: _inputNotifier,
                  builder: (_, _InputState state, __) {
                    if(!state.hasText) return const SizedBox.shrink();
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: (){
                        _cntrl.clear();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(Icons.close, color: ATColors.white, size: 18),
                      ),
                    );
                  }
                ),
              ),
            ),
          ),
        ),
    
        ValueListenableBuilder<_InputState>(
          valueListenable: _inputNotifier,
          builder: (_, _InputState state, __) {
            if (state.isFocused) {
              return GestureDetector(
                onTapDown: state.hasText
                  ? (_) {
                      final String message = _cntrl.text.trim();
                      log('this is the message');
                      if (message.isNotEmpty) {
                        context.read<LiveStreamCubit1>().sendChat(message);
                      }
                      _cntrl.clear();
                    }
                  : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.send,
                    color: state.hasText ? ATColors.white
                      : ATColors.lightDark,
                  ),
                ),
              );
            }
            return const _RowOfBtns();
          },
        ),
      ],
    );
  }
}


class _RowOfBtns extends StatelessWidget {
  const _RowOfBtns();

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = 
      context.watch<LiveStreamCubit1>().state;
    final bool isMicUnmuted = state.myMicIsEnabled;
    final bool isMyHandRaised = state.myHandIsRaised == true;
    return Row(
      children: <Widget>[
        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 curr)
            => prev.myMicIsEnabled != curr.myMicIsEnabled,
          listener: (_, LiveStreamState1 state){
            context.read<LiveStreamCubit1>()
              .toggleMicrophone(state.myMicIsEnabled);
          },
          child: EachGoLiveControlBtn(
            onTap: () {
              context.read<LiveStreamCubit1>()
                .toggleMicrophone(!isMicUnmuted);
            },
            color: isMicUnmuted ? ATColors
            .white.withValues(alpha: 0.3) : null,
            child: Icon(
              isMicUnmuted ? Icons.mic : Icons.mic_off,
              size: 20
            ),
          ),
        ),
        EachGoLiveControlBtn(
          onTap: () {
            context.read<LiveStreamCubit1>().raiseHand(
              context.read<LocalUserDataCubit>()
                .currentUserData?.userId ?? '',
            );
          },
          color: isMyHandRaised ? ATColors
            .white.withValues(alpha: 0.3) : null,
          child: ATImgLoader(
            imgPath: ATImgStrings.handRaiseIcon,
            height: 20,
            width: 20,
            boxFit: BoxFit.fill,
            color: isMyHandRaised ? ATColors.hex307FE2 : null,
          ),
        ),
        EachGoLiveControlBtn(
          onTap: ()async{
            final int? price = await GiftPickerDialog.show(context);
            if(context.mounted && price != null){
              context.read<LiveStreamCubit1>().sendGift(price);
            }
            // GiftPickerDialog.show(context);
          },
          child: const ATImgLoader(
            imgPath: ATImgStrings.hostGiftingIcon,
            height: 20,
            width: 20,
          ),
        ),
        EachGoLiveControlBtn(
          onTap: () {
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              builder: (BuildContext modalContext) => EmojiPicker(
                onEmojiSelected: (Category? category, Emoji emoji) {
                  context.read<LiveStreamCubit1>().sendReaction(emoji.emoji);
                  Navigator.pop(modalContext);
                },
              ),
            );
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
