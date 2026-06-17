import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/profile/data/models/request/upgrade_account_data.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AccountType {
  creator(value: 'creator'),
  business(value: 'business'),
  regular(value: 'regular');

  const AccountType({
    required this.value,
  });

  final String value;

  String toJson() => value;

  static AccountType fromJson(String? val) {
    return AccountType.values.firstWhere(
      (AccountType type) => type.value == val,
      orElse: () => AccountType.regular,
    );
  }
}

class SelectAcctTypeScreen extends StatefulWidget {
  const SelectAcctTypeScreen({super.key});

  @override
  State<SelectAcctTypeScreen> createState() => _SelectAcctTypeScreenState();
}

class _SelectAcctTypeScreenState extends State<SelectAcctTypeScreen> {
  AccountType? acctType;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
            leadingWidth: 30,
            padding: EdgeInsets.only(left: 7),
            leading: ATRoundedBackBtn(),
            titleText: 'Account Type'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                ATStrings.selectAcctTypeToProceed,
                maxLines: 3,
                style: context.textTheme.bodySmall
                    ?.copyWith(color: ATColors.hexC2C2C2),
              ),
              const SizedBox(height: 20),
              _SelectAcct(
                title: ATStrings.creatorAccount,
                subTitle: ATStrings.creatorAcctDesc,
                imgPath: ATImgStrings.creatorAcctLogo,
                isSelected: acctType == AccountType.creator,
                onTap: () {
                  setState(() => acctType = acctType == 
                    AccountType.creator ? null : AccountType.creator);
                },
              ),
              const SizedBox(height: 20),
              _SelectAcct(
                isSelected: acctType == AccountType.business,
                title: ATStrings.businessAcct,
                subTitle: ATStrings.businessAcctDesc,
                imgPath: ATImgStrings.businessAcctMicLogo,
                onTap: () {
                  setState(() => acctType = acctType == 
                    AccountType.business ? null : AccountType.business);
                },
              )
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: ATPlainElevatedBtn(
            onPressed: acctType == null ? null
            : () {
              UpgradeProfileData().copyWith(
                accountType: acctType,
              );
              context.pushNamed(
                ATRoutes.selectedAcctOnboardScreen,
                extra: acctType,
              );
            },
            btnTitle: ATStrings.next,
          ),
        ),
      ),
    );
  }
}

class _SelectAcct extends StatelessWidget {
  const _SelectAcct(
      {required this.title,
      required this.subTitle,
      required this.imgPath,
      required this.onTap,
      required this.isSelected});
  final String title, subTitle, imgPath;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 14,
      duration: 200,
      padding: const EdgeInsets.all(15),
      border:
          isSelected ? Border.all(color: ATColors.hex307FE2, width: 0.5) : null,
      color: ATColors.white.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style:
                context.textTheme.bodySmall?.copyWith(fontSize: ATSizes.size15),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text(
                  subTitle,
                  maxLines: 3,
                  style: context.textTheme.titleSmall?.copyWith(
                      fontSize: ATSizes.size13, color: ATColors.hexC2C2C2),
                ),
              ),
              const SizedBox(width: 30),
              ATImgLoader(imgPath: imgPath)
            ],
          ),
          const SizedBox(height: 15),
          const ATDivider(),
          const SizedBox(height: 10),
          ATContainer(
            onTap: onTap,
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            color: ATColors.white.withValues(alpha: 0.1),
            radius: 5,
            child: Text(
              ATStrings.setUpAcct(title.toLowerCase()),
              style: context.textTheme.bodySmall?.copyWith(
                  fontSize: ATSizes.size12,
                  color: ATColors.white.withValues(alpha: 0.7)),
            ),
          )
        ],
      ),
    );
  }
}
