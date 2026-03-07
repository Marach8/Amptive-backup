import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../switch_acct/switch_acct_export.dart';

enum SubPlanScreenEntryPoint { creatorProfileSetup, programCreationSetup }

class SubscriptionPlanData {
  const SubscriptionPlanData({
    this.subAmount,
    this.oneTimePaymentAmount,
    required this.entryPoint,
  });

  final double? subAmount, oneTimePaymentAmount;
  final SubPlanScreenEntryPoint entryPoint;

  SubscriptionPlanData copyWith({
    double? subAmount,
    double? oneTimePaymentAmount,
  }) =>
      SubscriptionPlanData(
        entryPoint: entryPoint,
        subAmount: subAmount ?? this.subAmount,
        oneTimePaymentAmount: oneTimePaymentAmount ?? this.oneTimePaymentAmount,
      );
}

class CreatorSubPlanScreen extends StatefulWidget {
  const CreatorSubPlanScreen({
    super.key,
    required this.incomingSubPlan,
  });

  final SubscriptionPlanData incomingSubPlan;

  @override
  State<CreatorSubPlanScreen> createState() => _CreatorSubPlanScreenState();
}

class _CreatorSubPlanScreenState extends State<CreatorSubPlanScreen> {
  late SubscriptionPlanData? _localSubPlan;

  @override
  void initState() {
    super.initState();
    _localSubPlan = widget.incomingSubPlan;
  }

  @override
  Widget build(BuildContext context) {
    final bool didComeFromProgramCreationFlow =
        widget.incomingSubPlan.entryPoint ==
            SubPlanScreenEntryPoint.programCreationSetup;
    final bool hasAddedSubPlanPrice = _localSubPlan?.subAmount != null ||
        _localSubPlan?.oneTimePaymentAmount != null;

    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: const ATAppBar(
          leadingWidth: 30,
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.subScriptionPlan,
          padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 56),
          child: Column(
            children: <Widget>[
              AddOrEditSubPlanWidget(
                existingSubPlanData: _localSubPlan,
                onSubPlanDataChanged: (SubscriptionPlanData newSubPlan) {
                  setState(() => _localSubPlan = newSubPlan);
                },
                onDeleteSubPlan: () {
                  setState((){
                    //We retain the entryPoint
                    _localSubPlan = SubscriptionPlanData(
                      entryPoint: widget.incomingSubPlan.entryPoint,
                    );
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              if (!didComeFromProgramCreationFlow)
                Text(
                  ATStrings.allowFreeSub,
                  maxLines: 2,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: ATSizes.size11,
                  ),
                )
            ],
          ),
        ),
        bottomSheet: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ATPlainElevatedBtn(
                    onPressed: hasAddedSubPlanPrice
                        ? () {
                            if (didComeFromProgramCreationFlow) {
                              context.pop(_localSubPlan);
                            } else {
                              context.pushNamed(
                                ATRoutes.cohostFeeSetup,
                                extra: _localSubPlan,
                              );
                            }
                          }
                        : null,
                    btnTitle: didComeFromProgramCreationFlow
                        ? ATStrings.done
                        : ATStrings.setupCohostFee),
                if (!didComeFromProgramCreationFlow) const SizedBox(height: 15),
                if (!didComeFromProgramCreationFlow)
                  InkWell(
                    onTap: () {},
                    radius: 5,
                    child: Text(ATStrings.setupLater,
                        style: context.textTheme.bodyLarge),
                  ),
              ],
            )),
      ),
    );
  }
}
