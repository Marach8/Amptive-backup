class ATEndpoints {
  const ATEndpoints._();

  static const String baseUrl = 'https://amptive.onrender.com';
  static const String wsBaseUrl = 'wss://amptive.onrender.com';


  static const String checkIdentityAvailability =
      '/api/v1/auth/check-availability';
  static const String sendOtp = '/api/v1/auth/init';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String login = '/api/v1/auth/login';
  static const String resetPasswordOtp = '/api/v1/auth/forgot-password';
  static const String verifyresetPasswordOtp =
      '/api/v1/auth/verify-password-reset-otp';
  static const String register = '/api/v1/auth/register';
  static const String uploadImage = '/api/v1/extras/upload-image';
  static const String communities = '/api/v1/communities/';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String users = '/api/v1/shows/users';
  static const String homeFeed = '/api/v1/shows/feed/home';
  static const String followedShowsFeed = '/api/v1/shows/feed/following';
  static const String liveUsersFeed = '/api/v1/shows/feed/live-now';
  static const String shows = '/api/v1/shows/';
  static const String events = '/api/v1/events/';
  static const String episodes = '/api/v1/episodes/';
  static const String getUserprofile = '/api/v1/users/me';
  static const String followers = '/api/v1/users/following';
  static const String getUsers = '/api/v1/users';
  static const String tags = '/api/v1/tags/';
  static const String createHashtag = '${tags}hashtags';
  static const String updateUserProfile = '/api/v1/users/me';
  static const String trendingHashtags = '/api/v1/tags/trending';
  static const String updateEmailAndPhone = '/api/v1/users/me/contact';
  static const String verifyEmailOrPhoneOtp = '/api/v1/users/me/verify-otp';
  static const String searchUsers = '/api/v1/search/users';
  static const String unifiedSearch = '/api/v1/search';
  static const String searchShows = '/api/v1/search/shows';
  static const String searchEvents = '/api/v1/search/events';
  static const String searchHashtags = '/api/v1/search/hashtags';
  static const String searchSuggestions = '/api/v1/search/suggestions';
  static const String registerDevice = '/api/v1/notif/devices/register';
  static const String fcmRegisterDevice = '/api/v1/notif/devices/register';
  static const String getNotifications = '/api/v1/notif';
  static const String setWalletPin = '/api/v1/auth/set-pin';
  static const String getWalletBalance = '/api/v1/payments/wallet/balance';

  static String getStreamTokenEndpoint(String streamId) =>
      '/api/v1/livestreams/$streamId/token';
  static String startStreamEndpoint(String contentId) =>
      '/api/v1/livestreams/$contentId/start';
  static String endStreamEndpoint(String streamId) =>
      '/api/v1/livestreams/$streamId/end';
  static String reactToStream(String streamId) =>
      '/api/v1/livestreams/$streamId/react';

  static String markEventGoing(String eventId) =>
      '${ATEndpoints.events}standalone/$eventId/going';
  static String markEpisodeGoing(String episodeId) =>
      '${ATEndpoints.events}episode/$episodeId/going';

  // websockets
  static const String wsUsers = '$wsBaseUrl/api/v1/ws/user';

  static String wsSignalEndpoint(String streamId, String authToken) =>
      '$wsBaseUrl/api/v1/ws/stream/$streamId?token=$authToken';
}
