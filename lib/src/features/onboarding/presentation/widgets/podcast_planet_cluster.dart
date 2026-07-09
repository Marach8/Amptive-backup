import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'audio_creator_animation_widget.dart';

class PodcastPlanetCluster extends StatefulWidget {
  final List<String> avatars;
  
  const PodcastPlanetCluster({super.key, required this.avatars});

  @override
  State<PodcastPlanetCluster> createState() => _PodcastPlanetClusterState();
}

class _AvatarData {
  final int index;
  final String imgPath;
  final double x;
  final double y;
  _AvatarData({required this.index, required this.imgPath, required this.x, required this.y});
}

class _PodcastPlanetClusterState extends State<PodcastPlanetCluster> {
  Timer? _ticker;
  double _currentAngle = 0.0;
  bool _isSpeaking = false;
  int _speakerIndex = -1;
  double _targetAngle = 0.0;
  bool _isAnimatingToSpeaker = false;

  @override
  void initState() {
    super.initState();
    _startTicker();
    // Start the first speaker selection after a brief intro orbit
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _pickNextSpeaker();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      if (!mounted) return;
      
      setState(() {
        if (_isSpeaking) {
          // Hold steady while speaking
        } else if (_isAnimatingToSpeaker) {
          // Interpolate to target angle
          double diff = _targetAngle - _currentAngle;
          if (diff < 0.01) {
            _currentAngle = _targetAngle;
            _isAnimatingToSpeaker = false;
            _isSpeaking = true;
            _startSpeakingPhase();
          } else {
            // Ease out
            _currentAngle += diff * 0.05;
          }
        } else {
          // Continuous orbit
          _currentAngle += 0.015; // Orbital speed
          if (_currentAngle > 2 * math.pi) {
            _currentAngle -= 2 * math.pi;
          }
        }
      });
    });
  }

  void _pickNextSpeaker() {
    _speakerIndex = math.Random().nextInt(widget.avatars.length);
    
    // Target alpha for speaker to reach exactly front-center is pi/2
    // alpha = _currentAngle + speaker * 2pi/3
    // We want: targetAngle + speaker * 2pi/3 = pi/2
    double target = (math.pi / 2) - (_speakerIndex * 2 * math.pi / widget.avatars.length);
    
    // Ensure we rotate forward to the target
    while (target <= _currentAngle) {
      target += 2 * math.pi;
    }
    
    _targetAngle = target;
    _isAnimatingToSpeaker = true;
  }

  void _startSpeakingPhase() async {
    // Speak for 3 to 6 seconds
    int speakTime = 3000 + math.Random().nextInt(3000);
    await Future.delayed(Duration(milliseconds: speakTime));
    
    if (!mounted) return;
    setState(() {
      _isSpeaking = false;
      _speakerIndex = -1;
    });
    
    // Wait 1.5 to 3 seconds before next person speaks
    int waitTime = 1500 + math.Random().nextInt(1500);
    await Future.delayed(Duration(milliseconds: waitTime));
    
    if (mounted) _pickNextSpeaker();
  }

  @override
  Widget build(BuildContext context) {
    List<_AvatarData> sortedAvatars = [];
    
    for (int i = 0; i < widget.avatars.length; i++) {
      double angleOffset = i * (2 * math.pi / widget.avatars.length);
      double alpha = _currentAngle + angleOffset;
      
      double x = math.cos(alpha);
      double y = math.sin(alpha); // y acts as depth (-1 back, 1 front)
      
      sortedAvatars.add(_AvatarData(
        index: i,
        imgPath: widget.avatars[i],
        x: x,
        y: y,
      ));
    }
    
    // Z-index sort: items with lower Y (further back) paint first
    sortedAvatars.sort((a, b) => a.y.compareTo(b.y));

    return SizedBox(
      height: 120, // Height to accommodate scaling
      width: 260, // Width to accommodate orbit radius
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: sortedAvatars.map((avatar) {
          // X-axis spread (radius)
          double xOffset = avatar.x * 90;
          
          // Y-axis spread (tilt the orbit slightly so back is higher)
          double yOffset = -avatar.y * 10;
          
          // Map depth to visual scale
          double scale = 0.75 + ((avatar.y + 1) / 2) * 0.40;
          
          // Is this specific avatar currently speaking?
          bool isSpeaking = _isSpeaking && _speakerIndex == avatar.index;

          return Transform.translate(
            offset: Offset(xOffset, yOffset),
            child: Transform.scale(
              scale: scale,
              child: TestWidget(
                imgPath: avatar.imgPath,
                isAnimated: isSpeaking,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
