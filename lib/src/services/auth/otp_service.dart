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



class OTPModel {
  String? pin1;
  String? pin2;
  String? pin3;
  String? pin4;

  bool get isOTPValid {
    return pin1 != null &&
        pin2 != null &&
        pin3 != null &&
        pin4 != null &&
        pin1!.isNotEmpty &&
        pin2!.isNotEmpty &&
        pin3!.isNotEmpty &&
        pin4!.isNotEmpty;
  }

  int getOTP() {
    if (isOTPValid) {
      String temp = pin1! + pin2! + pin3! + pin4!;
      return int.parse(temp);
    }

    return -1;
  }
}