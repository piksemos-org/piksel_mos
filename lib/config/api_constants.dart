class ApiConstants {
  static const String baseUrl = 'http://159.223.79.18';

  static const String register = '$baseUrl/api/auth/register';
  static const String login = '$baseUrl/api/auth/login';
  static const String verifyOtp = '$baseUrl/api/auth/verify-otp';
  static const String resendOtp = '$baseUrl/api/auth/resend-otp';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';
  static const String resetPassword = '$baseUrl/api/auth/reset-password';
  static const String feed = '$baseUrl/api/feed';
  static const String uploadPhoto = '$baseUrl/api/users/upload-photo';
}