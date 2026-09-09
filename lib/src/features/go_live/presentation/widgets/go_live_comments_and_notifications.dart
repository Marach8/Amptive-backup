import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/gifting_notification.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/reaction_notification.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_live_comment.dart';
import 'package:amptive/src/global_export.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GoLiveCommentsAndNotifications extends StatefulWidget {
  const GoLiveCommentsAndNotifications({super.key});

  @override
  State<GoLiveCommentsAndNotifications> createState() => _GoLiveCommentsAndNotificationsState();
}

class _GoLiveCommentsAndNotificationsState extends State<GoLiveCommentsAndNotifications> {
  static const int _maxItems = 100;

  final GlobalKey<AnimatedListState> _chatsListKey = GlobalKey<AnimatedListState>(),
    _giftListKey = GlobalKey<AnimatedListState>(),
    _reactionsListKey = GlobalKey<AnimatedListState>();
  final List<ChatMessage> _chats = <ChatMessage>[];
  final List<Gift> _gifts = <Gift>[];
  final List<Reaction> _reactions = <Reaction>[];

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

  //For chat messages
  void _insertMessage(ChatMessage message) {
    _chats.insert(0, message);

    _chatsListKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 250),
    );

    if (_chats.length > _maxItems) {
      _removeLastMessage();
    }
  }

  void _removeLastMessage() {
    final int lastIndex = _chats.length - 1;
    final ChatMessage removed = _chats.removeLast();

    _chatsListKey.currentState?.removeItem(
      lastIndex,
      (_, Animation<double> animation) {
        return AnimatedChatMsgItem(
          message: removed,
          animation: animation,
        );
      },
      duration: const Duration(milliseconds: 200),
    );
  }


  void _addGift(Gift gift) {
    _gifts.insert(0, gift);
    _giftListKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _removeGift(int index) {
    if (index < 0 || index >= _gifts.length) return;
    final Gift removed = _gifts.removeAt(index);

    _giftListKey.currentState?.removeItem(
      index,
      (_, Animation<double> animation) => GiftTravelItem(
        gift: removed,
        animation: animation,
        travelDuration: Duration.zero, // already travelled, just fade out
        onTravelComplete: () {},
        containerHeight: 1,
      ),
      duration: const Duration(milliseconds: 250),
    );
  }

  void _addReaction(Reaction reaction) {
    _reactions.insert(0, reaction);
    _reactionsListKey.currentState?.insertItem(
      0,
      duration: const Duration(milliseconds: 250),
    );

    if (_reactions.length > _maxItems) {
      _removeReaction(_reactions.length - 1);
    }
  }

  void _removeReaction(int index) {
    if (index < 0 || index >= _reactions.length) return;
    final Reaction removed = _reactions.removeAt(index);

    _reactionsListKey.currentState?.removeItem(
      index,
      (_, Animation<double> animation) => ReactionTravelItem(
        reaction: removed,
        animation: animation,
        travelDuration: Duration.zero,
        onTravelComplete: () {},
        containerHeight: 1,
      ),
      duration: const Duration(milliseconds: 250),
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
            key: _chatsListKey,
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(15, 50, 15, 50),
            initialItemCount: _chats.length,
            itemBuilder: (_, int index, Animation<double> animation) {
              return AnimatedChatMsgItem(
                message: _chats[index],
                animation: animation,
              );
            },
          ),
        ),


        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 curr) =>
              prev.giftIds != curr.giftIds,
          listener: (_, LiveStreamState1 state) {
            final List<String> ids = state.giftIds ?? <String>[];
            final Map<String, Gift>? gifts = state.gifts;

            if (ids.isEmpty) return;

            final String latestId = ids.first;
            final Gift? gift = gifts?[latestId];

            if (gift == null) return;

            _addGift(gift);
          },
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              // travel duration proportional to available height
              // ~1px per ms feels natural — tune this
              final Duration travelDuration = Duration(
                milliseconds: constraints.maxHeight.toInt() * 6,
              );
        
              return AnimatedList(
                key: _giftListKey,
                initialItemCount: 0,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(), // gifts aren't scrollable
                itemBuilder: (_, int index, Animation<double> animation) {
                  return GiftTravelItem(
                    gift: _gifts[index],
                    animation: animation,
                    travelDuration: travelDuration,
                    onTravelComplete: () => _removeGift(index),
                    containerHeight: constraints.maxHeight,
                  );
                },
              );
            },
          ),
        ),

        BlocListener<LiveStreamCubit1, LiveStreamState1>(
          listenWhen: (LiveStreamState1 prev, LiveStreamState1 curr) =>
              prev.reactions != curr.reactions,
          listener: (_, LiveStreamState1 state) {
            final List<Reaction> reactions = state.reactions ?? <Reaction>[];

            if (reactions.isEmpty) return;

            final Reaction latestReaction = reactions.first;

            _addReaction(latestReaction);
          },
          child: LayoutBuilder(
            builder: (_, BoxConstraints constraints) {
              final Duration travelDuration = Duration(
                milliseconds: constraints.maxHeight.toInt() * 4,
              );

              return AnimatedList(
                key: _reactionsListKey,
                initialItemCount: 0,
                reverse: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, int index, Animation<double> animation) {
                  return ReactionTravelItem(
                    reaction: _reactions[index],
                    animation: animation,
                    travelDuration: travelDuration,
                    onTravelComplete: () => _removeReaction(index),
                    containerHeight: constraints.maxHeight,
                  );
                },
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
      ],
    );
  }
}
