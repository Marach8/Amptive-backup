void mapIncomingStreamAction(Map<String, dynamic> json) {
    final String? type = json['type'] as String?;

    switch (type) {
      case 'chat':
        final ChatMessage? chat = ChatMessage.fromJson(json);
        emit(state.copyWith(messages: [...?state.messages, chat]));
        break;

      case 'reaction':
        final reaction = ReactionEvent.fromJson(json);
        emit(state.copyWith(reactions: [...state.reactions, reaction]));
        break;

      case 'gift':
        final gift = GiftEvent.fromJson(json);
        emit(state.copyWith(gifts: [...state.gifts, gift]));
        break;

      case 'handRaise':
        final action = json['action'] as String?;
        final identity = json['user_id'] as String?;
        if (action == 'raise' && identity != null) {
          if (!state.handQueue.contains(identity)) {
            emit(state.copyWith(handQueue: [...state.handQueue, identity]));
          }
        } else if ((action == 'lower' || action == 'approve') &&
            identity != null) {
          emit(state.copyWith(
            handQueue: state.handQueue.where((id) => id != identity).toList(),
          ));
        }
        break;

      case 'viewerCount':
        final count = json['count'] as int?;
        if (count != null) {
          emit(state.copyWith(viewerCount: count));
        }
        break;

      default:
        log('Received unknown WebSocket message type: $type');
    }
  }