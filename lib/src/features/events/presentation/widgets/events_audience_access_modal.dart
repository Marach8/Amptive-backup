import 'package:amptive/src/features/events/presentation/widgets/events_subscription_setup_modal.dart';
import 'package:amptive/src/features/shows/presentation/widgets/audience_access_modal.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:go_router/go_router.dart';


import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import '../../../switch_account/presentation/switch_acct/switch_acct_export.dart';


Future<ProgramAccessTypeSelectionData?> showEventsAudienceAccessTypeModal({
  required BuildContext context,
  required ProgramAccessTypeSelectionData initialAccessTypeData,
}) async {
  return await showModalBottomSheet<ProgramAccessTypeSelectionData>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: ATColors.hex202020,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (BuildContext dContext) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        builder: (_, ScrollController controller) {
          return _SubWidget(
            initialOneTimePaymentAmount:
                initialAccessTypeData.oneTimePaymentAmount,
            initialSubAmount: initialAccessTypeData.subscriptionAmount,
            initialAccessType: initialAccessTypeData.accessType,
            controller: controller,
          );
        },
      );
    },
  );
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({
    this.initialOneTimePaymentAmount,
    this.initialSubAmount,
    this.initialAccessType,
    required this.controller,
  });

  final double? initialOneTimePaymentAmount, initialSubAmount;
  final ProgramAccessType? initialAccessType;
  final ScrollController controller;

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  ProgramAccessType? _localAccessType;
  late SubscriptionPlanData _localSubPlan;

  @override
  void initState() {
    super.initState();
    _localAccessType = widget.initialAccessType;
    _localSubPlan = SubscriptionPlanData(
      entryPoint: SubPlanScreenEntryPoint.programCreationSetup,
      subAmount: widget.initialSubAmount,
      oneTimePaymentAmount: widget.initialOneTimePaymentAmount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ATModalDismisser(),
          Align(
            alignment: Alignment.center,
            child: Text(
              ATStrings.audienceAccess,
              style: context.textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            maxLines: 5,
            ATStrings.promptToSetupSubPlan,
            style: context.textTheme.labelSmall
                ?.copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
          ),
          const SizedBox(height: 15),
          Expanded(
              child: SingleChildScrollView(
            controller: widget.controller,
            child: Column(
              spacing: 15,
              children: <Widget>[
                _FreeAccessWidget(
                  isFreeSelected: _localAccessType == ProgramAccessType.free,
                  onFreeTapped: (bool isFree) {
                    setState(() {
                      _localAccessType = isFree ? null : ProgramAccessType.free;
                    });
                  },
                ),
                _PaidAccessWidget(
                  isPaid: _localAccessType == ProgramAccessType.paid,
                  initialSubPlan: _localSubPlan,
                  onSubscriptionPlanSet: (SubscriptionPlanData newSubPlan) {
                    setState(() {
                      _localSubPlan = newSubPlan;
                      if (_localAccessType != ProgramAccessType.paid) {
                        _localAccessType = ProgramAccessType.paid;
                      }
                    });
                  },
                  onPaidAccessTapped: (bool isPaid) {
                    setState(() {
                      _localAccessType = isPaid ? null : ProgramAccessType.paid;
                    });
                  },
                ),
              ],
            ),
          )),
          const SizedBox(height: 15),
          ATPlainElevatedBtn(
            height: 50,
            onPressed: _localAccessType == null
                ? null
                : () {
                    final bool hasExistingSubSetup =
                        _localSubPlan.subAmount != null ||
                            _localSubPlan.oneTimePaymentAmount != null;

                    if (_localAccessType == ProgramAccessType.paid &&
                        !hasExistingSubSetup) {
                      showAppNotification2(
                        context: context,
                        text: 'Please setup a subscription plan to continue.',
                        type: NotificationType.failure,
                      );
                      return;
                    }
                    context.pop(
                      ProgramAccessTypeSelectionData(
                        accessType: _localAccessType,
                        subscriptionAmount: _localSubPlan.subAmount,
                        oneTimePaymentAmount:
                            _localSubPlan.oneTimePaymentAmount,
                      ),
                    );
                  },
            btnTitle: ATStrings.cContinue,
          ),
          const SizedBox(height: 54)
        ],
      ),
    );
  }
}



class _PaidAccessWidget extends StatelessWidget {
  const _PaidAccessWidget({
    required this.isPaid,
    required this.onPaidAccessTapped,
    required this.onSubscriptionPlanSet,
    required this.initialSubPlan,
  });

  final bool isPaid;
  final ValueChanged<bool> onPaidAccessTapped;
  final ValueChanged<SubscriptionPlanData> onSubscriptionPlanSet;
  final SubscriptionPlanData initialSubPlan;

  @override
  Widget build(BuildContext context) {
    final bool hasExistingSubPlan = initialSubPlan.subAmount != null ||
        initialSubPlan.oneTimePaymentAmount != null;

    final double? subPlanPrice = initialSubPlan.subAmount;

    return ATContainer(
      onTap: () => onPaidAccessTapped(isPaid),
      padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
      radius: 15,
      duration: 100,
      color: ATColors.hex2D2D2D,
      border: Border.all(
          width: 2, color: isPaid ? ATColors.hex307FE2 : ATColors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ATImgLoader(imgPath: ATImgStrings.padlock),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(ATStrings.subscribersOnly,
                        style: context.textTheme.bodySmall
                            ?.copyWith(fontSize: ATSizes.size15)),
                    Text(
                      maxLines: 5,
                      ATStrings.onlySubscribersCanAccess,
                      style: context.textTheme.titleMedium?.copyWith(
                          color: ATColors.hexC2C2C2, fontSize: ATSizes.size13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              ATRadioBtn(isSelected: isPaid),
            ],
          ),
          const SizedBox(height: 15),
          const ATDivider(),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              ATContainer(
                onTap: () async {
                  final SubscriptionPlanData? newSubPlan =
                    await showEventsSubscriptionSetupModal(
                    context: context,
                    existingSubPlanData: initialSubPlan,
                  );
                  if(newSubPlan != null){
                    onSubscriptionPlanSet(newSubPlan);
                  }
                },
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: ATColors.white.withValues(alpha: 0.1),
                radius: 5,
                child: Text(
                    hasExistingSubPlan
                        ? ATStrings.editSubPlan
                        : ATStrings.setupSubPlan,
                    style: context.textTheme.labelSmall?.copyWith(
                        color: ATColors.white.withValues(alpha: 0.7))),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      hasExistingSubPlan
                          ? '${ATStrings.nairaText}$subPlanPrice'
                          : '',
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: ATSizes.size14,
                      )),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}



class _FreeAccessWidget extends StatelessWidget {
  const _FreeAccessWidget({
    required this.isFreeSelected,
    required this.onFreeTapped,
  });

  final bool isFreeSelected;
  final ValueChanged<bool> onFreeTapped;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      duration: 100,
      onTap: () => onFreeTapped(isFreeSelected),
      padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
      radius: 15,
      color: ATColors.hex2D2D2D,
      border: Border.all(
          width: 2,
          color: isFreeSelected ? ATColors.hex307FE2 : ATColors.transparent),
      child: Row(
        children: <Widget>[
          const ATImgLoader(imgPath: ATImgStrings.people),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(ATStrings.free,
                    style: context.textTheme.bodySmall
                        ?.copyWith(fontSize: ATSizes.size15)),
                Text(
                  maxLines: 5,
                  ATStrings.freeAccessToShow,
                  style: context.textTheme.titleMedium?.copyWith(
                      color: ATColors.hexC2C2C2, fontSize: ATSizes.size13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ATRadioBtn(isSelected: isFreeSelected),
        ],
      ),
    );
  }
}
