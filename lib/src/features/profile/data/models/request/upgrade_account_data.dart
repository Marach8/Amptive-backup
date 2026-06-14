import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';

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

  AccountType? accountType;  
  String? category;
  double? subAmount;
  int? coHostFee;

  void copyWith({
    AccountType? accountType,
    String? category,
    double? subAmount,
    int? coHostFee,
  }) {
    this.accountType = accountType ?? this.accountType;
    this.category = category ?? this.category;
    this.subAmount = subAmount ?? this.subAmount;
    this.coHostFee = coHostFee ?? this.coHostFee;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (accountType != null) 'profile_type': accountType?.toJson(),
      if (category != null) 'category': category,
      if (subAmount != null) 'subscription_amount': subAmount,
      if (coHostFee != null) 'co_host_fee': coHostFee,
    };
  }
}
