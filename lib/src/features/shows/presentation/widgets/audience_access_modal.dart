import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/radio_button.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import '../../../switch_account/presentation/switch_acct/switch_acct_export.dart';
import 'package:figma_squircle/figma_squircle.dart';

enum ProgramAccessType { free, paid }

class ProgramAccessTypeSelectionData {
  const ProgramAccessTypeSelectionData({
    this.accessType,
    this.subscriptionAmount,
    this.oneTimePaymentAmount,
  });

  final ProgramAccessType? accessType;
  final double? subscriptionAmount, oneTimePaymentAmount;
}

Future<ProgramAccessTypeSelectionData?> showAudienceAccessTypeModal({
  required BuildContext context,
  required ProgramAccessTypeSelectionData initialAccessTypeData,
}) async {
  return await showModalBottomSheet<ProgramAccessTypeSelectionData>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: ATColors.black.withValues(alpha: 0.5),
    builder: (BuildContext dContext) {
      return Stack(
        children: <Widget>[
          DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.94,
        builder: (_, ScrollController controller) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            child: Material(
              color: const Color(0xFF1C1C1E),
              child: _SubWidget(
                initialOneTimePaymentAmount:
                    initialAccessTypeData.oneTimePaymentAmount,
                initialSubAmount: initialAccessTypeData.subscriptionAmount,
                initialAccessType: initialAccessTypeData.accessType,
                controller: controller,
              ),
            ),
          );
        },
          ),
        ],
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
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Center(
              child: Container(
                width: 38,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  ATStrings.audienceAccess,
                  style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                ATStrings.promptToSetupSubPlan,
                maxLines: 5,
                style: context.textTheme.labelSmall
                    ?.copyWith(color: ATColors.hexC2C2C2.withValues(alpha: 0.76)),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                controller: widget.controller,
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
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
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ATBlurredBgBtn(
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
        ),
      ],
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

    final double? subPlanPrice =
        initialSubPlan.subAmount ?? initialSubPlan.oneTimePaymentAmount;
    String recurrence = '';
    if (initialSubPlan.subAmount != null) {
      recurrence = 'month';
    } else if (initialSubPlan.oneTimePaymentAmount != null) {
      recurrence = 'one time';
    }

    return ATContainer(
      onTap: () => onPaidAccessTapped(isPaid),
      padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
      radius: 15,
      duration: 100,
      color: ATColors.hex2D2D2D,
      border: Border.all(
          width: 2, color: isPaid ? ATColors.white.withValues(alpha: 0.1) : ATColors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              const ATImgLoader(
                imgPath: ATImgStrings.padlockHighRes,
                width: 32,
                height: 32,
              ),
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
              AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isPaid ? ATColors.white : ATColors.transparent,
                    border: Border.all(color: ATColors.white, width: 2),
                    shape: BoxShape.circle,
                  ),
                  height: 24,
                  width: 24,
                  child: Icon(Icons.check,
                      size: 20,
                      color: isPaid
                          ? ATColors.hex0D0D0D
                          : ATColors.transparent)),
            ],
          ),
          const SizedBox(height: 15),
          const ATDivider(),
          const SizedBox(height: 15),
          Row(
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final SubscriptionPlanData? selectedSubPlan =
                      await context.pushNamed(
                    ATRoutes.creatorSubPlanSetup,
                    extra: initialSubPlan,
                  );
                  if (selectedSubPlan != null) {
                    onSubscriptionPlanSet(selectedSubPlan);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6), // Expanded touch area
                  child: ClipSmoothRect(
                    radius: SmoothBorderRadius(
                        cornerRadius: 6, cornerSmoothing: 0.8),
                    child: ColoredBox(
                      color: ATColors.white.withValues(alpha: 0.1),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        child: Text(
                          hasExistingSubPlan
                              ? ATStrings.editSubPlan
                              : ATStrings.setupSubPlan,
                          style: context.textTheme.labelSmall?.copyWith(
                              color: ATColors.white.withValues(alpha: 0.7),
                              height: 1.1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                      hasExistingSubPlan
                          ? '${ATStrings.nairaText}$subPlanPrice/$recurrence'
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
          color: isFreeSelected ? ATColors.white.withValues(alpha: 0.1) : ATColors.transparent),
      child: Row(
        children: <Widget>[
          const ATImgLoader(
            imgPath: ATImgStrings.peopleHighRes,
            width: 32,
            height: 32,
          ),
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
          AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isFreeSelected ? ATColors.white : ATColors.transparent,
                border: Border.all(color: ATColors.white, width: 2),
                shape: BoxShape.circle,
              ),
              height: 24,
              width: 24,
              child: Icon(Icons.check,
                  size: 20,
                  color: isFreeSelected
                      ? ATColors.hex0D0D0D
                      : ATColors.transparent)),
        ],
      ),
    );
  }
}
