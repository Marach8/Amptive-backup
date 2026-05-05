import 'dart:ui';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/live_screen_notifications.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../go_live_export.dart';

class GoLiveComments extends StatefulWidget {
  const GoLiveComments({super.key});

  @override
  State<GoLiveComments> createState() => _GoLiveCommentsState();
}

class _GoLiveCommentsState extends State<GoLiveComments> {
  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _scroll2BottomNotifier =
      ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scroll2BottomNotifier.dispose();
    _scrollController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _scroll2BottomNotifier.value = true;
    } else if (_scrollController.position.atEdge &&
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
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        NotificationListener<ScrollNotification>(
          onNotification: context
              .read<GoLiveControlsVisibilityBloc>()
              .ctrlModerationToolsVisibility,

          child: BlocBuilder<LiveStreamCubit1, LiveStreamState1>(
            builder: (BuildContext context, LiveStreamState1 state) {
              final Map<String, ChatMessage>? messages = state.messages;
              final List<String> messagesIds = state.messagesIds ?? <String>[];

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
                itemCount: messagesIds.isEmpty ? 0 : messagesIds.length,
                itemBuilder: (_, int listIndex) {
                  if (messagesIds.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(
                            color: ATColors.hexC2C2C2,
                            fontSize: ATSizes.size13,
                          ),
                        ),
                      ),
                    );
                  }
              
                  final String id = messagesIds[listIndex];
                  final ChatMessage? message = messages?[id];
                  final bool msgFromHost = message?.role == ParticipantRole.host;
              
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: ATImgLoader(
                            imgPath: message?.avatar ?? '',
                            boxFit: BoxFit.cover,
                            height: 35, width: 35,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                spacing: 10,
                                children: <Widget>[
                                  Flexible(
                                    child: Text(
                                      message?.senderName ?? '',
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: ATColors.hexC2C2C2, height: 0.78
                                      )
                                    ),
                                  ),
                                  if(msgFromHost) const HostIndicator(
                                    size: 6, radius: 3,
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(message?.message ?? '',
                                  maxLines: 2,
                                  style: context.textTheme.titleMedium
                                      ?.copyWith(
                                          fontSize: ATSizes.size13,
                                          height: 1.38)),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          ),
        ),
        Positioned(
          bottom: 70,
          right: 15,
          child: ValueListenableBuilder<bool>(
              valueListenable: _scroll2BottomNotifier,
              builder: (_, bool showIcon, __) {
                return ATScalingSwitcher(
                  duration: 200,
                  child: showIcon
                      ? ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: ATContainer(
                              key: const ValueKey<int>(1),
                              onTap: () => _scrollToBottom(),
                              color: ATColors.white.withValues(alpha: 0.1),
                              height: 35,
                              width: 35,
                              boxShape: BoxShape.circle,
                              child: const Icon(
                                  Icons.keyboard_double_arrow_down),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey<int>(2)),
                );
              }),
        ),
        Column(
          children: <Widget>[
            //SpeakingNotification(speaker: speaker),
            const GiftNotification(),
          ],
        )
      ],
    );
  }
}
