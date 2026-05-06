import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_host_and_cohost.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/live_screen_notifications.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/global_export.dart';

class GoLiveComments extends StatefulWidget {
  const GoLiveComments({super.key});

  @override
  State<GoLiveComments> createState() => _GoLiveCommentsState();
}

class _GoLiveCommentsState extends State<GoLiveComments> {
  static const int _maxItems = 100;

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ChatMessage> _items = <ChatMessage>[];

  late final ScrollController _scrollController;
  late final ValueNotifier<bool> _scroll2BottomNotifier;

  @override
  void initState() {
    super.initState();

    _scroll2BottomNotifier = ValueNotifier<bool>(true);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scroll2BottomNotifier.dispose();
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
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _insertMessage(ChatMessage message) {
    _items.insert(0, message);

    _listKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 250),
    );

    if (_items.length > _maxItems) {
      _removeLastMessage();
    }
  }

  void _removeLastMessage() {
    final int lastIndex = _items.length - 1;
    final ChatMessage removed = _items.removeLast();

    _listKey.currentState?.removeItem(
      lastIndex,
      (_, Animation<double> animation) {
        return _AnimatedChatItem(
          message: removed,
          animation: animation,
        );
      },
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[

        /// 🔥 LISTENER ONLY (NO FULL REBUILD)
        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 curr) =>
              prev.messagesIds != curr.messagesIds,
          listener: (_, LiveStreamState1 state) {
            final List<String> ids = state.messagesIds ?? <String>[];
            final Map<String, ChatMessage>? messages = state.messages;

            if (ids.isEmpty) return;

            final String latestId = ids.first;
            final ChatMessage? message = messages?[latestId];

            if (message == null) return;

            _insertMessage(message);
          },
          child: AnimatedList(
            key: _listKey,
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
            initialItemCount: _items.length,
            itemBuilder: (_, int index, Animation<double> animation) {
              return _AnimatedChatItem(
                message: _items[index],
                animation: animation,
              );
            },
          ),
        ),

        /// Scroll to bottom button
        Positioned(
          bottom: 70,
          right: 15,
          child: ValueListenableBuilder<bool>(
            valueListenable: _scroll2BottomNotifier,
            builder: (_, bool showIcon, __) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: showIcon
                  ? GestureDetector(
                      key: const ValueKey<String>('scroll_btn'),
                      onTap: _scrollToBottom,
                      child: Container(
                        height: 35,  width: 35,
                        decoration: BoxDecoration(
                          color: ATColors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.keyboard_double_arrow_down),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey<String>('hidden')),
              );
            },
          ),
        ),

        /// Optional overlays (gift etc.)
        Column(
          children: const <Widget>[
            GiftNotification(),
          ],
        ),
      ],
    );
  }
}


class _AnimatedChatItem extends StatelessWidget {
  const _AnimatedChatItem({
    required this.message,
    required this.animation,
  });

  final ChatMessage message;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final bool msgFromHost = message.role == ParticipantRole.host;

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: -1,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.25),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: ATImgLoader(
                    imgPath: message.avatar ?? '',
                    boxFit: BoxFit.cover,
                    height: 35,
                    width: 35,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              message.senderName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    height: 0.78,
                                  ),
                            ),
                          ),
                          if (msgFromHost)
                            const Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: HostIndicator(size: 6, radius: 3),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message.message ?? '',
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontSize: 13,
                              height: 1.38,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
