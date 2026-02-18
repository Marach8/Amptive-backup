class ATEndpoints {
  const ATEndpoints._();

  static const String baseUrl = 'https://amptive.onrender.com';

  static const String checkIdentityAvailability = '/api/v1/auth/check-availability';
  static const String sendOtp = '/api/v1/auth/init';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String login = '/api/v1/auth/login';
  static const String resetPasswordOtp = '/api/v1/auth/forgot-password';
  static const String verifyresetPasswordOtp = '/api/v1/auth/verify-password-reset-otp';

}

