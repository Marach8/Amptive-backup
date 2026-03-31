// ════════════════════════════════════════════════════════════════
//  Example: wiring LivestreamController in a Flutter widget
// ════════════════════════════════════════════════════════════════
//
//  Add these to pubspec.yaml:
//    dependencies:
//      http: ^1.2.0
//      web_socket_channel: ^2.4.0
//      livekit_client: ^2.2.0        # WebRTC media
//
// ════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import './src/livestream/livestream.dart';

class LivestreamPage extends StatefulWidget {
  LivestreamPage({
    super.key,
    this.isHost = false,
  });

  String streamId = "";
  String userAuthToken = "";
  final bool isHost;

  @override
  State<LivestreamPage> createState() => _LivestreamPageState();
}

class _LivestreamPageState extends State<LivestreamPage> {
  late final LivestreamController _controller;
  final _chatInput = TextEditingController();
  bool _joining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = LivestreamController(
      streamId: widget.streamId,
      apiService: LivestreamApiService(
        baseUrl: 'https://api.amptive.io',
        authToken: widget.userAuthToken,
      ),
      baseWsUrl: 'wss://api.amptive.io',
      userAuthToken: widget.userAuthToken,
      isHost: widget.isHost,
    );
    _joinStream();
  }

  Future<void> _joinStream() async {
    setState(() => _joining = true);
    try {
      if (widget.isHost) {
        // Host starts the stream first, then joins
        await _controller.startStream();
      }
      await _controller.join();
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
    _controller.dispose();
    _chatInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_joining) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    return StreamBuilder<LivestreamState>(
      stream: _controller.stateStream,
      initialData: _controller.state,
      builder: (context, snapshot) {
        final state = snapshot.requireData;

        if (state.status == StreamStatus.ended) {
          return const Scaffold(
            body: Center(child: Text('Stream has ended.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Viewers: ${state.viewerCount}'),
            actions: [
              // Mute toggle
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: _controller.toggleMute,
              ),
              // React
              IconButton(
                icon: const Icon(Icons.local_fire_department),
                onPressed: () => _controller.sendReaction('🔥'),
              ),
              // Host: end stream
              if (widget.isHost)
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: _controller.endStream,
                ),
            ],
          ),
          body: Column(
            children: [
              // ── Participants ─────────────────────────────────────────
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.participants.length,
                  itemBuilder: (_, i) {
                    final p = state.participants[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Chip(
                        label: Text(p.displayName),
                        avatar: p.isSpeaker
                            ? const Icon(Icons.mic, size: 14)
                            : null,
                      ),
                    );
                  },
                ),
              ),

              // ── Hand queue (host view) ───────────────────────────────
              if (widget.isHost && state.handQueue.isNotEmpty)
                Container(
                  color: Colors.amber.shade50,
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 8,
                    children: state.handQueue
                        .map((id) => ActionChip(
                      label: Text(id),
                      onPressed: () =>
                          _controller.approveHandRaise(id),
                    ))
                        .toList(),
                  ),
                ),

              // ── Chat ─────────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: state.messages.length,
                  itemBuilder: (_, i) {
                    final m = state.messages[i];
                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        radius: 14,
                        child: Text(m.displayName[0]),
                      ),
                      title: Text(m.displayName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(m.message),
                    );
                  },
                ),
              ),

              // ── Chat input + hand raise ──────────────────────────────
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      if (!widget.isHost)
                        IconButton(
                          icon: const Icon(Icons.back_hand_outlined),
                          onPressed: _controller.raiseHand,
                          tooltip: 'Raise hand',
                        ),
                      Expanded(
                        child: TextField(
                          controller: _chatInput,
                          decoration: const InputDecoration(
                            hintText: 'Say something…',
                            border: OutlineInputBorder(),
                            isDense: true,
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}