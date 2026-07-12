import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/features/upgrade_account/presentation/screens/select_acct_type_screen.dart';
import 'package:flutter/material.dart';

class AccountUpgradeBadge extends StatelessWidget {
  const AccountUpgradeBadge({
    super.key,
    this.width,
    this.height,
    this.radius,
    required this.accountType,
  });
  final double? height, width, radius;
  final AccountType accountType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
      decoration: BoxDecoration(
        color: ATColors.hexFED601,
        border: Border.all(color: ATColors.black, width: 2),
        borderRadius: BorderRadius.circular(radius ?? 10),
      ),
      child: Text(
        accountType.value.toUpperCase(),
        style: context.textTheme.bodyMedium
          ?.copyWith(fontSize: ATSizes.size10, color: ATColors.black),
      ),
    );
  }
}
