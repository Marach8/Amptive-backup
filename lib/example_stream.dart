import 'dart:async';
import 'dart:math' as math;

import 'package:amptive/src/features/go_live/data/models/deconstruct_inbound_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './src/livestream/livestream.dart';

// ── Design tokens ────────────────────────────────────────────────────────────

class _C {
  static const bg = Color(0xFF0A0A0F);
  static const surface = Color(0xFF13131A);
  static const surfaceHigh = Color(0xFF1C1C27);
  static const border = Color(0xFF252535);
  static const accent = Color(0xFF6C63FF);
  static const accentDim = Color(0x336C63FF);
  static const live = Color(0xFFFF4757);
  static const green = Color(0xFF2ED573);
  static const amber = Color(0xFFFFAA00);
  static const textPrimary = Color(0xFFEEEEF5);
  static const textSecondary = Color(0xFF8888AA);
  static const textDim = Color(0xFF44445A);
}

// ─────────────────────────────────────────────────────────────────────────────

class LivestreamPage extends StatefulWidget {
  const LivestreamPage({
    super.key,
    this.isHost = true,
    this.streamId = "fc037ee3-4e4f-4927-8ed6-42fd6f825491",
    this.contentId = "65f3b7f0-c6fa-4e3f-a272-2e1f5d06df15",
  });

  final String? streamId;
  final String contentId;
  final bool isHost;

  @override
  State<LivestreamPage> createState() => _LivestreamPageState();
}

class _LivestreamPageState extends State<LivestreamPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late final LivestreamController _controller;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  final _chatInput = TextEditingController();
  final _chatScrollController = ScrollController();
  final _chatFocus = FocusNode();

  bool _joining = false;
  String? _error;
  bool _joinInProgress = false;
  bool _chatExpanded = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    WidgetsBinding.instance.addObserver(this);
    _controller = LivestreamController(
      streamId: widget.streamId,
      isHost: widget.isHost,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _joinStream());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    super.didChangeAppLifecycleState(appState);
    switch (appState) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _controller.mediaService.toggleMicrophone(false);
        break;
      case AppLifecycleState.resumed:
        // final id = _controller.mediaService.localParticipant?.identity;
        // final isSpeaker = id != null &&
        //     _controller.state.participants
        //         .any((p) => p.userId == id && p.isSpeaker);
        // if (isSpeaker) _controller.mediaService.toggleMicrophone(true);
        break;
      default:
        break;
    }
  }

  Future<void> _joinStream() async {
    if (_joinInProgress) return;
    _joinInProgress = true;
    setState(() { _joining = true; _error = null; });

    try {
      if (widget.isHost) await _controller.startStream(widget.contentId);
      await _controller.join();
    } on LivestreamApiException catch (e) {
      if (mounted) {
        setState(() => _error = e.isForbidden
            ? 'Stream has not started yet.'
            : e.message);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      _joinInProgress = false;
      if (mounted) setState(() => _joining = false);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _controller.dispose();
    _chatInput.dispose();
    _chatScrollController.dispose();
    _chatFocus.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendChat(String msg) {
    final trimmed = msg.trim();
    if (trimmed.isEmpty) return;
    _controller.sendChat(trimmed);
    _chatInput.clear();
  }

  void _toggleHandRaise() {
    final id = _controller.mediaService.localParticipant?.identity;
    if (id == null) return;
    if (_controller.state.handQueue.contains(id)) {
      _controller.lowerHand();
    } else {
      _controller.raiseHand();
    }
  }

  // ── Loading / error screens ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_joining) return _buildLoadingScreen();
    if (_error != null) return _buildErrorScreen(_error!);

    return StreamBuilder<LivestreamState>(
      stream: _controller.stateStream,
      initialData: _controller.state,
      builder: (context, snapshot) {
        final state = snapshot.requireData;

        if (state.status == StreamStatus.ended) return _buildEndedScreen();
        if (state.status == StreamStatus.error) {
          return _buildErrorScreen(state.lastError ?? 'An error occurred');
        }

        if (state.messages.isNotEmpty) _scrollToBottom();

        return _buildMainScreen(state);
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PulsingOrb(controller: _pulseController, size: 80, color: _C.accent),
            const SizedBox(height: 24),
            Text(
              'Joining stream…',
              style: TextStyle(color: _C.textSecondary, fontSize: 15,
                  letterSpacing: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen(String msg) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _C.live.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.wifi_off_rounded,
                      color: _C.live, size: 28),
                ),
                const SizedBox(height: 20),
                Text(msg,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: _C.textPrimary, fontSize: 15)),
                const SizedBox(height: 28),
                _PillButton(
                  label: 'Try again',
                  color: _C.accent,
                  onTap: _joinStream,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEndedScreen() {
    return Scaffold(
      backgroundColor: _C.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.live.withOpacity(0.1),
              ),
              child: const Icon(Icons.stop_rounded, color: _C.live, size: 32),
            ),
            const SizedBox(height: 20),
            const Text('Stream ended',
                style: TextStyle(color: _C.textPrimary, fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('Thanks for tuning in',
                style: TextStyle(color: _C.textSecondary, fontSize: 14)),
            const SizedBox(height: 32),
            _PillButton(
              label: 'Go back',
              color: _C.surfaceHigh,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  // ── Main screen ───────────────────────────────────────────────────────────

  Widget _buildMainScreen(LivestreamState state) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(state),
            Expanded(
              child: _chatExpanded
                  ? _buildChatPanel(state)
                  : _buildStagePanel(state),
            ),
            _buildBottomBar(state),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar(LivestreamState state) {
    final isLive = state.status == StreamStatus.live;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Back
          _IconBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 12),

          // LIVE badge
          if (isLive) ...[
            _LiveBadge(controller: _pulseController),
            const SizedBox(width: 10),
          ],

          // Viewer count
          const Icon(Icons.remove_red_eye_outlined,
              size: 14, color: _C.textSecondary),
          const SizedBox(width: 4),
          Text('${state.viewerCount}',
              style: const TextStyle(
                  color: _C.textSecondary, fontSize: 13)),

          // Participant count
          if (state.participantCount > 0) ...[
            const SizedBox(width: 12),
            const Icon(Icons.people_outline_rounded,
                size: 14, color: _C.textSecondary),
            const SizedBox(width: 4),
            Text('${state.participantCount}',
                style: const TextStyle(
                    color: _C.textSecondary, fontSize: 13)),
          ],

          const Spacer(),

          // Mute toggle
          StreamBuilder<MediaStateChange>(
            stream: _controller.mediaService.onMediaStateChanged,
            builder: (context, _) {
              final on = _controller.mediaService.isAudioEnabled;
              return _IconBtn(
                icon: on ? Icons.mic_rounded : Icons.mic_off_rounded,
                color: on ? _C.textPrimary : _C.live,
                onTap: _controller.toggleMute,
              );
            },
          ),
          const SizedBox(width: 4),

          // Reactions picker
          PopupMenuButton<String>(
            color: _C.surfaceHigh,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            icon: const Icon(Icons.add_reaction_outlined,
                color: _C.textSecondary, size: 20),
            onSelected: (e) => _controller.sendReaction(e),
            itemBuilder: (_) => ['🔥', '❤️', '👍', '😂', '🎉']
                .map((e) => PopupMenuItem(
              value: e,
              child: Text(e, style: const TextStyle(fontSize: 20)),
            ))
                .toList(),
          ),

          // End stream (host)
          if (widget.isHost) ...[
            const SizedBox(width: 4),
            _IconBtn(
              icon: Icons.stop_circle_outlined,
              color: _C.live,
              onTap: _showEndDialog,
            ),
          ],
        ],
      ),
    );
  }

  // ── Stage panel (visualizer + participants) ───────────────────────────────

  Widget _buildStagePanel(LivestreamState state) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Visualizer
        Expanded(
          flex: 5,
          child: _buildVisualizer(state),
        ),

        // Participants strip
        if (state.participants.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildParticipantStrip(state),
        ],

        // Hand queue (host)
        if (widget.isHost && state.handQueue.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildHandQueue(state),
        ],

        // Reactions ticker
        if (state.reactions.isNotEmpty) ...[
          const SizedBox(height: 4),
          _buildReactionsTicker(state),
        ],

        // Chat preview (last 3 messages)
        const SizedBox(height: 8),
        _buildChatPreview(state),
        const SizedBox(height: 4),
      ],
    );
  }

  // ── Audio visualizer ──────────────────────────────────────────────────────

  Widget _buildVisualizer(LivestreamState state) {
    final remote = state.remoteLevel;
    final local = state.localLevel;
    final speaking = remote > 0.04;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Main orb
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, _) {
              final pulse = _pulseController.value;
              final scale = speaking
                  ? 1.0 + remote * 0.25 * pulse
                  : 1.0 + 0.04 * pulse;

              return Transform.scale(
                scale: scale,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow ring
                    Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (speaking ? _C.accent : _C.textDim)
                                .withOpacity(speaking
                                ? 0.35 * pulse
                                : 0.1 * pulse),
                            blurRadius: 40,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    ),
                    // Ring
                    Container(
                      width: 154,
                      height: 154,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: (speaking ? _C.accent : _C.border)
                              .withOpacity(speaking ? 0.6 : 0.4),
                          width: 1.5,
                        ),
                      ),
                    ),
                    // Core
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _C.surface,
                        gradient: RadialGradient(
                          colors: [
                            speaking
                                ? _C.accent.withOpacity(0.18)
                                : _C.surfaceHigh,
                            _C.surface,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            speaking ? Icons.mic_rounded : Icons.mic_none_rounded,
                            size: 36,
                            color: speaking ? _C.accent : _C.textDim,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            speaking ? 'Speaking' : 'Listening',
                            style: TextStyle(
                              color: speaking ? _C.accent : _C.textDim,
                              fontSize: 11,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          // Level meters
          _buildLevelMeter('You', local, _C.green),
          const SizedBox(height: 10),
          _buildLevelMeter('Host', remote, _C.accent),
        ],
      ),
    );
  }

  Widget _buildLevelMeter(String label, double level, Color color) {
    return SizedBox(
      width: 220,
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text(label,
                style: const TextStyle(color: _C.textDim, fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: level.clamp(0.0, 1.0),
                backgroundColor: _C.border,
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Participant strip ─────────────────────────────────────────────────────

  Widget _buildParticipantStrip(LivestreamState state) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.participants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final p = state.participants[i];
          return _ParticipantAvatar(participant: p);
        },
      ),
    );
  }

  // ── Hand queue ────────────────────────────────────────────────────────────

  Widget _buildHandQueue(LivestreamState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: _C.amber.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.amber.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.back_hand_outlined, color: _C.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: state.handQueue
                  .map((id) => GestureDetector(
                onTap: () => _controller.approveHandRaise(id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _C.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(id,
                      style: const TextStyle(
                          color: _C.amber, fontSize: 12)),
                ),
              ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ── Reactions ticker ──────────────────────────────────────────────────────

  Widget _buildReactionsTicker(LivestreamState state) {
    final recent = state.reactions.reversed.take(5).toList();
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        reverse: true,
        itemCount: recent.length,
        itemBuilder: (_, i) {
          final r = recent[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _C.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.border),
              ),
              child: Text('${r.emoji}  ${r.senderId}',
                  style: const TextStyle(
                      color: _C.textSecondary, fontSize: 11)),
            ),
          );
        },
      ),
    );
  }

  // ── Chat preview (collapsed state) ───────────────────────────────────────

  Widget _buildChatPreview(LivestreamState state) {
    final preview = state.messages.reversed.take(3).toList().reversed.toList();

    return GestureDetector(
      onTap: () => setState(() => _chatExpanded = true),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    size: 13, color: _C.textDim),
                const SizedBox(width: 6),
                Text('${state.messages.length} messages',
                    style: const TextStyle(
                        color: _C.textDim, fontSize: 11)),
                const Spacer(),
                const Text('Tap to expand',
                    style: TextStyle(color: _C.textDim, fontSize: 11)),
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_up_rounded,
                    size: 14, color: _C.textDim),
              ],
            ),
            if (preview.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...preview.map((m) => _ChatLine(message: m)),
            ] else
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text('No messages yet',
                    style: TextStyle(color: _C.textDim, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  // ── Chat panel (expanded state) ───────────────────────────────────────────

  Widget _buildChatPanel(LivestreamState state) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text('Chat',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              _IconBtn(
                icon: Icons.keyboard_arrow_down_rounded,
                onTap: () => setState(() => _chatExpanded = false),
              ),
            ],
          ),
        ),

        // Messages
        Expanded(
          child: state.messages.isEmpty
              ? const Center(
              child: Text('Be the first to chat!',
                  style: TextStyle(color: _C.textDim, fontSize: 13)))
              : ListView.builder(
            controller: _chatScrollController,
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 4),
            itemCount: state.messages.length,
            itemBuilder: (_, i) =>
                _ChatLine(message: state.messages[i], full: true),
          ),
        ),
      ],
    );
  }

  // ── Bottom bar ────────────────────────────────────────────────────────────

  Widget _buildBottomBar(LivestreamState state) {
    final localId = _controller.mediaService.localParticipant?.identity;
    final isHandRaised =
        localId != null && state.handQueue.contains(localId);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: const BoxDecoration(
        color: _C.surface,
        border: Border(top: BorderSide(color: _C.border)),
      ),
      child: Row(
        children: [
          // Hand raise (viewers only)
          if (!widget.isHost)
            _IconBtn(
              icon: isHandRaised
                  ? Icons.back_hand_rounded
                  : Icons.back_hand_outlined,
              color: isHandRaised ? _C.amber : _C.textSecondary,
              onTap: _toggleHandRaise,
            ),

          const SizedBox(width: 8),

          // Chat input
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: _C.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _C.border),
              ),
              child: TextField(
                controller: _chatInput,
                focusNode: _chatFocus,
                style: const TextStyle(color: _C.textPrimary, fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Say something…',
                  hintStyle: TextStyle(color: _C.textDim, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: _sendChat,
                onTap: () {
                  if (!_chatExpanded) setState(() => _chatExpanded = true);
                },
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: () => _sendChat(_chatInput.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.accent,
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: _C.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.stop_circle_outlined,
                  color: _C.live, size: 36),
              const SizedBox(height: 14),
              const Text('End stream?',
                  style: TextStyle(
                      color: _C.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              const Text(
                'This will disconnect all viewers.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _C.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _PillButton(
                      label: 'Cancel',
                      color: _C.border,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PillButton(
                      label: 'End',
                      color: _C.live,
                      onTap: () {
                        Navigator.pop(context);
                        _controller.endStream();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _PulsingOrb extends StatelessWidget {
  const _PulsingOrb({
    required this.controller,
    required this.size,
    required this.color,
  });

  final AnimationController controller;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.15 + 0.1 * controller.value),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3 * controller.value),
              blurRadius: 20,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Icon(Icons.radio_button_checked_rounded,
            color: color, size: size * 0.4),
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _C.live,
              boxShadow: [
                BoxShadow(
                  color: _C.live.withOpacity(0.6 * controller.value),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          const Text('LIVE',
              style: TextStyle(
                  color: _C.live,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.color = _C.textSecondary,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _C.surfaceHigh,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  const _ParticipantAvatar({required this.participant});
  final LivestreamParticipant participant;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            // Container(
            //   width: 40,
            //   height: 40,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     color: _C.surfaceHigh,
            //     border: Border.all(
            //       color: participant.isSpeaker ? _C.accent : _C.border,
            //       width: participant.isSpeaker ? 2 : 1,
            //     ),
            //   ),
            //   child: Center(
            //     child: Text(
            //       participant.userName.isNotEmpty
            //           ? participant.userName[0].toUpperCase()
            //           : '?',
            //       style: const TextStyle(
            //           color: _C.textPrimary,
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: _C.live),
                  child: const Icon(Icons.mic_off_rounded,
                      size: 8, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 48,
          child: Text(
            participant.username ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _C.textDim, fontSize: 9),
          ),
        ),
      ],
    );
  }
}

class _ChatLine extends StatelessWidget {
  const _ChatLine({required this.message, this.full = false});
  final ChatMessage message;
  final bool full;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: full ? 10 : 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (full)
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8, top: 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.surfaceHigh,
                border: Border.all(color: _C.border),
              ),
              child: const Center(
                child: Text(
                  'foo',
                  style: const TextStyle(
                      color: _C.textPrimary, fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          Expanded(
            child: RichText(
              maxLines: full ? null : 1,
              overflow: full ? TextOverflow.visible : TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${message.senderName}  ',
                    style: const TextStyle(
                        color: _C.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: message.message,
                    style: const TextStyle(
                        color: _C.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
