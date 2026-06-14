class UpgradeProfileData {
  // Factory constructor (singleton)
  factory UpgradeProfileData() {
    _instance ??= UpgradeProfileData._internal();
    return _instance!;
  }

  // Private constructor
  UpgradeProfileData._internal();

  // Static instance
  static UpgradeProfileData? _instance;

  String? profileType;  
  String? category;
  double? subAmount;
  int? coHostFee;

  void copyWith({
    String? profileType,
    String? category,
    double? subAmount,
    int? coHostFee,
  }) {
    this.profileType = profileType ?? this.profileType;
    this.category = category ?? this.category;
    this.subAmount = subAmount ?? this.subAmount;
    this.coHostFee = coHostFee ?? this.coHostFee;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (profileType != null) 'profile_type': profileType,
      if (category != null) 'category': category,
      if (subAmount != null) 'subscription_amount': subAmount,
      if (coHostFee != null) 'co_host_fee': coHostFee,
    };
  }

  void reset() {
    profileType = null;
    category = null;
    subAmount = null;
    coHostFee = null;
  }
}
