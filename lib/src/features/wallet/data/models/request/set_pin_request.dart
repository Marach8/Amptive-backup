class SetPinData {
  // Factory constructor
  factory SetPinData() {
    _instance ??= SetPinData._internal();
    return _instance!;
  }
  // Private constructor
  SetPinData._internal();

  // Static instance
  static SetPinData? _instance;

  // Fields
  String? newPin;
  String? confirmNewPin;
  String? securityQuestion;
  String? securityQuestionAnswer;


  /// Update fields (clean controlled mutation)
  void copyWith({
    String? newPin,
    String? confirmNewPin,
    String? securityQuestion,
    String? securityQuestionAnswer,
  }) {
    this.newPin = newPin ?? this.newPin;
    this.confirmNewPin = confirmNewPin ?? this.confirmNewPin;
    this.securityQuestion = securityQuestion ?? this.securityQuestion;
    this.securityQuestionAnswer = securityQuestionAnswer ?? this.securityQuestionAnswer;
  }

  /// Convert to JSON

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (newPin != null) "new_pin": newPin,
      if (confirmNewPin != null) "confirm_new_pin": confirmNewPin,
      if (securityQuestion != null) "security_question": securityQuestion,
      if (securityQuestionAnswer != null) "security_question_answer": securityQuestionAnswer,
      
    };
  }

  /// Clear data after successful submission
  void reset() {
    newPin = null;
    confirmNewPin = null;
    securityQuestion = null;
    securityQuestionAnswer = null;
  }
}
