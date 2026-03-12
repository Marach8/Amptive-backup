class AmptiveUser {
  AmptiveUser({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.profilePicture,
    this.isSelected = false,
  });

  int? id;
  String? name;
  String? username;
  String? email;
  String? password;
  String? profilePicture;
  bool isSelected;
}
