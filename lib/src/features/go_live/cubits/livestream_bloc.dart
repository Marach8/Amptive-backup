// import 'dart:async';
// import 'package:amptive/src/livestream/livestream.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// abstract class LivestreamEvent {
//   const LivestreamEvent();
// }

// class JoinLivestream extends LivestreamEvent {
//   const JoinLivestream(
//       {required this.streamId, required this.isHost, this.contentId});
//   final String streamId;
//   final bool isHost;
//   final String? contentId;
// }

// class LeaveLivestream extends LivestreamEvent {
//   const LeaveLivestream();
// }

// class SendChatMessage extends LivestreamEvent {
//   const SendChatMessage({required this.message});
//   final String message;
// }

// class SendReactionEvent extends LivestreamEvent {
//   const SendReactionEvent({required this.emoji});
//   final String emoji;
// }

// class SendGiftEvent extends LivestreamEvent {
//   const SendGiftEvent({required this.giftId, required this.quantity});
//   final String giftId;
//   final int quantity;
// }

// class ToggleMuteEvent extends LivestreamEvent {
//   const ToggleMuteEvent();
// }

// class EndStreamEvent extends LivestreamEvent {
//   const EndStreamEvent();
// }

// class StartStreamEvent extends LivestreamEvent {
//   const StartStreamEvent({required this.contentId});
//   final String contentId;
// }

// class LivestreamBloc extends Bloc<LivestreamEvent, LivestreamState> {
//   LivestreamBloc()
//       : super(const LivestreamState(status: StreamStatus.waiting)) {
//     on<JoinLivestream>(_onJoinLivestream);
//     on<LeaveLivestream>(_onLeaveLivestream);
//     on<SendChatMessage>(_onSendChatMessage);
//     on<SendReactionEvent>(_onSendReactionEvent);
//     on<SendGiftEvent>(_onSendGiftEvent);
//     on<ToggleMuteEvent>(_onToggleMuteEvent);
//     on<EndStreamEvent>(_onEndStreamEvent);
//     on<StartStreamEvent>(_onStartStreamEvent);
//     on<_InternalStateUpdate>(_onInternalStateUpdate);
//   }

//   LivestreamController? _controller;
//   StreamSubscription<LivestreamState>? _stateSubscription;

//   Future<void> _onJoinLivestream(
//     JoinLivestream event,
//     Emitter<LivestreamState> emit,
//   ) async {
//     try {
//       _controller = LivestreamController(
//         streamId: event.streamId,
//         isHost: event.isHost,
//       );

//       _stateSubscription =
//           _controller!.stateStream.listen((LivestreamState state) {
//         if (!isClosed) {
//           add(_InternalStateUpdate(state));
//         }
//       });

//       // For host: startStream first to get streamId, then join
//       if (event.isHost && event.contentId != null) {
//         await _controller!.startStream(event.contentId!);
//       }

//       await _controller!.join();

//       emit(_controller!.state);
//     } catch (e) {
//       emit(LivestreamState(
//         status: StreamStatus.error,
//         lastError: 'Failed to join: $e',
//       ));
//     }
//   }

//   Future<void> _onLeaveLivestream(
//     LeaveLivestream event,
//     Emitter<LivestreamState> emit,
//   ) async {
//     await _disposeController();
//     emit(LivestreamState(status: StreamStatus.ended));
//   }

//   void _onSendChatMessage(
//     SendChatMessage event,
//     Emitter<LivestreamState> emit,
//   ) {
//     _controller?.sendChat(event.message);
//   }

//   void _onSendReactionEvent(
//     SendReactionEvent event,
//     Emitter<LivestreamState> emit,
//   ) {
//     _controller?.sendReaction(event.emoji);
//   }

//   void _onSendGiftEvent(
//     SendGiftEvent event,
//     Emitter<LivestreamState> emit,
//   ) {
//     _controller?.sendGift(event.giftId, event.quantity);
//   }

//   Future<void> _onToggleMuteEvent(
//     ToggleMuteEvent event,
//     Emitter<LivestreamState> emit,
//   ) async {
//     await _controller?.toggleMute();
//   }

//   Future<void> _onEndStreamEvent(
//     EndStreamEvent event,
//     Emitter<LivestreamState> emit,
//   ) async {
//     try {
//       await _controller?.endStream();
//     } catch (e) {
//       emit(state.copyWith(
//         status: StreamStatus.error,
//         lastError: 'Failed to end stream: $e',
//       ));
//     }
//   }

//   Future<void> _onStartStreamEvent(
//     StartStreamEvent event,
//     Emitter<LivestreamState> emit,
//   ) async {
//     try {
//       await _controller?.startStream(event.contentId);
//     } catch (e) {
//       emit(state.copyWith(
//         status: StreamStatus.error,
//         lastError: 'Failed to start stream: $e',
//       ));
//     }
//   }

//   void _onInternalStateUpdate(
//     _InternalStateUpdate event,
//     Emitter<LivestreamState> emit,
//   ) {
//     emit(event.state);
//   }

//   Future<void> _disposeController() async {
//     await _stateSubscription?.cancel();
//     _stateSubscription = null;
//     await _controller?.dispose();
//     _controller = null;
//   }

//   @override
//   Future<void> close() async {
//     await _disposeController();
//     return super.close();
//   }
// }

// class _InternalStateUpdate extends LivestreamEvent {
//   const _InternalStateUpdate(this.state);
//   final LivestreamState state;
// }
