import 'dart:async';

import 'package:flutter/material.dart';
import './src/livestream/livestream.dart';

class LivestreamPage extends StatefulWidget {
  LivestreamPage({
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
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late final LivestreamController _controller;
  late AnimationController _pulseController;

  final _chatInput = TextEditingController();
  bool _joining = false;
  String? _error;

  final List<StreamSubscription<dynamic>> _mediaSubs = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    WidgetsBinding.instance.addObserver(this);
    _controller = LivestreamController(
      streamId: widget.streamId,
      isHost: widget.isHost,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _joinStream();
    });

  }

  Future<void> _joinStream() async {
    setState(() => _joining = true);
    try {
      if (widget.isHost) {
        // Host starts the stream first, then joins
        await _controller.startStream(widget.contentId);
      }
      await _controller.join();
      // _setupMediaListeners();
    } on LivestreamApiException catch (e) {
      setState(() => _error = e.isForbidden
          ? 'Stream has not started yet. Please wait.'
          : e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _joining = false);
    }
  }


  @override
  void dispose() {
    for (final StreamSubscription<dynamic> sub in _mediaSubs) {
      sub.cancel();
    }
    _controller.dispose();
    _chatInput.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_joining) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _joinStream(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<LivestreamState>(
      stream: _controller.stateStream,
      initialData: _controller.state,
      builder: (context, snapshot) {
        final state = snapshot.requireData;

        if (state.status == StreamStatus.ended) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stop_circle, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Stream has ended.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.status == StreamStatus.error) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(state.lastError ?? 'An error occurred'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _joinStream(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(state),
          body: Column(
            children: [
              // ── Video Grid / Screen Share View ───────────────────────
              _buildAudioVisualizer(state),

              // ── Participants Bar ─────────────────────────────────────
              _buildParticipantsBar(state),

              // ── Hand Queue (Host View) ───────────────────────────────
              if (widget.isHost && state.handQueue.isNotEmpty)
                _buildHandQueue(state),

              // ── Chat Messages ────────────────────────────────────────
              Expanded(child: _buildChatList(state)),

              // ── Control Bar ──────────────────────────────────────────
              _buildControlBar(state),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(LivestreamState state) {
    return AppBar(
      title: Row(
        children: [
          if (state.status == StreamStatus.live)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          Text('Viewers: ${state.viewerCount}'),
          if (state.participantCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '• Participants: ${state.participantCount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
      actions: [
        // Mute toggle
        StreamBuilder<MediaStateChange>(
          stream: _controller.mediaService.onMediaStateChanged,
          builder: (context, _) {
            final enabled = _controller.mediaService.isAudioEnabled;
            return IconButton(
              icon: Icon(enabled ? Icons.mic : Icons.mic_off),
              onPressed: _controller.toggleMute,
              tooltip: enabled ? 'Mute' : 'Unmute',
            );
          },
        ),

        // Reaction
        PopupMenuButton<String>(
          icon: const Icon(Icons.emoji_emotions),
          onSelected: (emoji) => _controller.sendReaction(emoji),
          itemBuilder: (context) => [
            const PopupMenuItem(value: '🔥', child: Text('🔥 Fire')),
            const PopupMenuItem(value: '❤️', child: Text('❤️ Heart')),
            const PopupMenuItem(value: '👍', child: Text('👍 Thumbs up')),
            const PopupMenuItem(value: '😂', child: Text('😂 Laugh')),
            const PopupMenuItem(value: '🎉', child: Text('🎉 Party')),
          ],
        ),
        // End stream (host only)
        if (widget.isHost)
          IconButton(
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.red),
            onPressed: _showEndStreamDialog,
            tooltip: 'End stream',
          ),
      ],
    );
  }

  Widget _buildAudioVisualizer(LivestreamState state) {
    final isConnected = true;
    final localLevel = 0.5;
    final remoteLevel = 0.5;
    final isSpeaking = remoteLevel > 0.05;

    return Column(
      children: [
        // Animated circle for audio visualization
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    isSpeaking ? Colors.blue : Colors.grey,
                    Colors.transparent,
                  ],
                  stops: const [0.3, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isSpeaking ? Colors.blue : Colors.grey)
                        .withOpacity(0.3 * _pulseController.value),
                    blurRadius: 30,
                    spreadRadius: 10 * _pulseController.value,
                  ),
                ],
              ),
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isSpeaking ? Icons.mic : Icons.mic_off,
                        size: 50,
                        color: isSpeaking ? Colors.blue : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isSpeaking ? 'Assistant Speaking' : 'Waiting...',
                        style: TextStyle(
                          color: isSpeaking ? Colors.blue : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        // Audio level meter
        if (isConnected) ...[
          _buildAudioLevelMeter('You', localLevel, Colors.green),
          const SizedBox(height: 12),
          _buildAudioLevelMeter('Assistant', remoteLevel, Colors.blue),
        ],
      ],
    );
  }

  Widget _buildAudioLevelMeter(String label, double level, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 4),
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            widthFactor: level.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildVideoGrid(LivestreamState state) {
    // Show active speakers or screen share in main view
    final activeSpeakers =
        state.participants.where((p) => p.isSpeaker).toList();

    if (activeSpeakers.isNotEmpty) {
      // Show active speakers grid
      return SizedBox(
        height: 200,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(8),
          itemCount: activeSpeakers.length,
          itemBuilder: (_, i) {
            final p = activeSpeakers[i];
            return SizedBox(
              height: 50,
              width: 50,
              child: Text(p.displayName),
            );
          },
        ),
      );
    }

    // Show placeholder when no video
    return Container(
      height: 200,
      color: Colors.grey.shade900,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.videocam_off, size: 48, color: Colors.white54),
            SizedBox(height: 8),
            Text(
              'No video streams available',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsBar(LivestreamState state) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.participants.length,
        itemBuilder: (_, i) {
          final p = state.participants[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Chip(
              label: Text(p.displayName),
              avatar: p.isSpeaker ? const Icon(Icons.mic, size: 14) : null,
              backgroundColor: p.isSpeaker ? Colors.green.shade100 : null,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandQueue(LivestreamState state) {
    return Container(
      color: Colors.amber.shade50,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hand Raised:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: state.handQueue
                .map((id) => ActionChip(
                      label: Text(id),
                      onPressed: () => _controller.approveHandRaise(id),
                      backgroundColor: Colors.amber.shade100,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(LivestreamState state) {
    if (state.messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Be the first to chat!'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: state.messages.length,
      itemBuilder: (_, i) {
        final m = state.messages[i];
        return ListTile(
          dense: true,
          leading: CircleAvatar(
            radius: 16,
            child: Text(m.displayName[0].toUpperCase()),
          ),
          title: Text(
            m.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(m.message),
          trailing: Text(
            _formatTime(m.timestamp),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  Widget _buildControlBar(LivestreamState state) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reactions bar (quick reactions)
            if (state.reactions.isNotEmpty)
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.reactions.take(5).length,
                  itemBuilder: (_, i) {
                    final r = state.reactions[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(
                        label: Text('${r.emoji} ${r.identity}'),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    );
                  },
                ),
              ),

            // Chat input and actions
            Row(
              children: [
                if (!widget.isHost)
                  IconButton(
                    icon: Icon(
                      state.handQueue.contains(_controller
                              .mediaService.localParticipant?.identity)
                          ? Icons.back_hand
                          : Icons.back_hand_outlined,
                      color: state.handQueue.contains(_controller
                              .mediaService.localParticipant?.identity)
                          ? Colors.amber
                          : null,
                    ),
                    onPressed: _toggleHandRaise,
                    tooltip: 'Raise hand',
                  ),
                Expanded(
                  child: TextField(
                    controller: _chatInput,
                    decoration: const InputDecoration(
                      hintText: 'Say something…',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (msg) {
                      if (msg.trim().isEmpty) return;
                      _controller.sendChat(msg.trim());
                      _chatInput.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final msg = _chatInput.text.trim();
                    if (msg.isEmpty) return;
                    _controller.sendChat(msg);
                    _chatInput.clear();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleHandRaise() {
    final isHandRaised = _controller.state.handQueue
        .contains(_controller.mediaService.localParticipant?.identity);

    if (isHandRaised) {
      _controller.lowerHand();
    } else {
      _controller.raiseHand();
    }
  }

  void _showEndStreamDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Stream'),
        content: const Text('Are you sure you want to end this stream?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.endStream();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('End Stream'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }
}
