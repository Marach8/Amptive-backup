class ATEndpoints {
  const ATEndpoints._();

  static const String baseUrl = 'https://amptive.onrender.com';

  static const String checkIdentityAvailability = '/api/v1/auth/check-availability';
  static const String sendOtp = '/api/v1/auth/init';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String login = '/api/v1/auth/login';
  static const String resetPasswordOtp = '/api/v1/auth/forgot-password';
  static const String verifyresetPasswordOtp = '/api/v1/auth/verify-password-reset-otp';
  static const String register = '/api/v1/auth/register';
  static const String uploadImage = '/api/v1/extras/upload-image';
  static const String communities = '/api/v1/communities/';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String users = '/api/v1/shows/users';
  static const String homeFeed = '/api/v1/shows/feed/home';
  static const String followedShowsFeed = '/api/v1/shows/feed/following';
  static const String liveShowsFeed = '/api/v1/shows/feed/live-now';
  static const String shows = '/api/v1/shows/';
  static const String getUserprofile = '/api/v1/users/me';

}
