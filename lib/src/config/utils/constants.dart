class Constants {
  Constants._();

  static const int kTimerLimit = 10;
  static const int kMaxNumberCommunities = 5;
  static const List<String> kCountryList = <String>[
    'AR',
    'DE',
    'GB',
    'NG',
    'CN'
  ];
  static final String kDefaultCountrySelected = kCountryList[3];

  // create show
  static const int kMaxTitleCharacters = 140;
  static const int kMaxDescriptionCharacters = 4000;
}


// ── Outbound message type constants ────────────────────────────────────────

class OutboundMessageType {
  static const String chat        = 'chat';
  static const String reaction    = 'reaction';
  static const String handRaise   = 'hand_raise';
  static const String ping        = 'ping';
  static const String mediaToggle = 'media_toggle';
  static const String screenShare = 'screen_share';
}

// ── Inbound event type constants ───────────────────────────────────────────

class SignalingEventType {
  static const String initial          = 'initial_state';
  static const String streamStarted    = 'stream_started';
  static const String streamEnded      = 'stream_ended';
  static const String error            = 'error';
  static const String pong             = 'pong';
  static const String participantJoin  = 'participant_join';
  static const String participantLeave = 'participant_leave';
  static const String participantUpdated = 'participant_updated';
  static const String chat             = 'chat';
  static const String reaction         = 'reaction';
  static const String handRaise        = 'hand_raise';
  static const String viewerCount      = 'viewer_count';
  static const String participantCount = 'participant_count';
  static const String userMuted        = 'user_muted';
  static const String userBanned       = 'user_banned';
  static const String userKicked       = 'user_kicked';
  static const String mediaStateChanged  = 'media_state_changed';
  static const String screenShareStarted = 'screen_share_started';
  static const String screenShareEnded   = 'screen_share_ended';
  static const String pollCreated = 'poll_created';
  static const String pollVoted   = 'poll_voted';
  static const String pollEnded   = 'poll_ended';
}
