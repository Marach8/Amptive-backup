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