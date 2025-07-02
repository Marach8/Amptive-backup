import '../../utils/helpers/helper_classes/otp_model.dart';

class OtpService {

  factory OtpService() => _instance;
  OtpService._();

  static final OtpService _instance = OtpService._();

  final OTPModel otpModel = OTPModel();

  // fields setter
  void setOtp(String pin, int index) {
    if (index == 0) {
      otpModel.pin1 = pin;
    } else if (index == 1) {
      otpModel.pin2 = pin;
    } else if (index == 2) {
      otpModel.pin3 = pin;
    } else if (index == 3) {
      otpModel.pin4 = pin;
    }
  }

  bool get isOTPValid => otpModel.isOTPValid;

  Future<bool> validateOtp() async {
    // send http request to validate otp
    int otp = otpModel.getOTP();
    print(otp);
    await Future.delayed(const Duration(seconds: 2), () {});
    return true;
  }
}
