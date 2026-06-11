import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/switch_account/presentation/screens/subscription_plan_screen.dart';
import 'package:amptive/src/features/switch_account/presentation/widgets/subscription_plan_setup_modal.dart';
import 'package:amptive/src/features/switch_account/presentation/widgets/delete_subscription_plan_modal.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';

class AddOrEditSubPlanWidget extends StatelessWidget {
  const AddOrEditSubPlanWidget({
    super.key,
    required this.existingSubPlanData,
    required this.onSubPlanDataChanged,
    required this.onDeleteSubPlan,
  });

  final SubscriptionPlanData? existingSubPlanData;
  final ValueChanged<SubscriptionPlanData> onSubPlanDataChanged;
  final VoidCallback onDeleteSubPlan;

  @override
  Widget build(BuildContext context) {
    final bool hasExistingSubPlan = existingSubPlanData?.subAmount != null ||
        existingSubPlanData?.oneTimePaymentAmount != null;

    final double? subPlanPrice =
        existingSubPlanData?.subAmount ?? existingSubPlanData?.oneTimePaymentAmount;
    String recurrence = '';
    if (existingSubPlanData?.subAmount != null) {
      recurrence = 'month';
    } else if (existingSubPlanData?.oneTimePaymentAmount != null) {
      recurrence = 'one time';
    }

    return ATContainer(
        onTap: () async {
          if (!hasExistingSubPlan) {
            final SubscriptionPlanData? newSubPlanData =
                await showSubPlanSetupModal(
              context: context,
              existingSubPlanData: existingSubPlanData,
            );
            if (newSubPlanData != null) {
              onSubPlanDataChanged(newSubPlanData);
            }
          }
        },
        color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
        radius: 14,
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
        width: double.infinity,
        child: hasExistingSubPlan
          ? Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const ATImgLoader(imgPath: ATImgStrings.padlock),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ATStrings.subPlanOverview,
                          style: context.textTheme.bodySmall
                              ?.copyWith(fontSize: ATSizes.size15),
                        ),
                        Text(
                          ATStrings.subPlanOverviewDesc,
                          maxLines: 3,
                          style: context.textTheme.titleSmall
                              ?.copyWith(fontSize: ATSizes.size13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      final bool? shouldDelete =
                          await showDeleteSubscriptionPlanOptionModal(
                              context);
                      if (context.mounted && shouldDelete == true) {
                        final bool? delete = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.deleteSubPlan,
                          content: ATStrings.deleteSubPlanDesc,
                          yesString: ATStrings.delete,
                          noString: ATStrings.cancel,
                        );
                        if (delete == true) {
                          onDeleteSubPlan();
                        }
                      }
                    },
                    icon: const Icon(Icons.more_horiz),
                  )
                ],
              ),
              const SizedBox(height: 10),
              const ATDivider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ATContainer(
                      onTap: () async {
                        final SubscriptionPlanData? newSubPlanData =
                            await showSubPlanSetupModal(
                          context: context,
                          existingSubPlanData: existingSubPlanData,
                        );
                        if (newSubPlanData != null) {
                          onSubPlanDataChanged(newSubPlanData);
                        }
                      },
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color: ATColors.white.withValues(alpha: 0.1),
                      radius: 5,
                      child: Text(
                        ATStrings.editSubPlan,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontSize: ATSizes.size12,
                            color: ATColors.white.withValues(alpha: 0.7)),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${ATStrings.nairaText}${subPlanPrice ?? 0.0}/$recurrence',
                        maxLines: 2,
                        style: context.textTheme.bodyMedium
                            ?.copyWith(fontSize: ATSizes.size14),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.add),
              Text(
                ATStrings.addNew,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: ATSizes.size16,
                ),
              )
            ],
          )
        );
  }
}

