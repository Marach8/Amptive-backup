class UserData {
  const UserData({
    this.email = '',
    this.phoneNumber = '',
    this.name = '',
    this.password = '',
    this.dob = '',
    this.username = '',
    this.loading = false,
    this.error,
  });

  final String email;
  final String phoneNumber;
  final String name;
  final String password;
  final String dob;
  final String username;
  final bool loading;
  final String? error;

  UserData copyWith({
    String? email,
    String? phoneNumber,
    String? name,
    String? password,
    String? dob,
    String? username,
    bool? loading,
    String? error,
  }) {
    return UserData(
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      username: username ?? this.username,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'phone_number': phoneNumber,
      'name': name,
      'password': password,
      'dob': dob,
      'username': username,
    };
  }
}