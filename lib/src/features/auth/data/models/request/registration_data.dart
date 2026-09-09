class RegistrationData {
  // Factory constructor
  factory RegistrationData() {
    _instance ??= RegistrationData._internal();
    return _instance!;
  }
  // Private constructor
  RegistrationData._internal();

  // Static instance
  static RegistrationData? _instance;

  // Fields
  String? email;
  String? phoneNumber;
  String name = '';
  String password = '';
  String dob = '';
  String username = '';

  /// Update fields (clean controlled mutation)
  void copyWith({
    String? email,
    String? phoneNumber,
    String? name,
    String? password,
    String? dob,
    String? username,
  }) {
    this.email = email ?? this.email;
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.name = name ?? this.name;
    this.password = password ?? this.password;
    this.dob = dob ?? this.dob;
    this.username = username ?? this.username;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      'name': name,
      'password': password,
      'dob': dob,
      'username': username,
    };
  }

  /// Clear data after successful submission
  void reset() {
    email = null;
    phoneNumber = null;
    name = '';
    password = '';
    dob = '';
    username = '';
  }
}
