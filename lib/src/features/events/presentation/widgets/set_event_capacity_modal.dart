import 'dart:io';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/create_show/create_show_service.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import '../../../../config/utils/other_strings.dart';


import 'package:amptive/src/features/switch_account/presentation/screens/subscription_plan_screen.dart';
import 'package:amptive/src/features/switch_account/presentation/widgets/row_of_custom_fees.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';


Future<String?> showEventCapacitySelectionDialog({
  required BuildContext context,
  required String? currentCapacity,
}) async {
  return await showModalBottomSheet<String>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020,
      barrierColor: ATColors.black.withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14), topRight: Radius.circular(14)),
      ),
      builder: (_) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          builder: (BuildContext context, ScrollController scrollController) {
            return _SubPlanWidget(
              currentCapacity: currentCapacity,
              scrollController: scrollController,
            );
          }
        )
      );
}

class _SubPlanWidget extends StatefulWidget {
  const _SubPlanWidget({
    this.currentCapacity,
    required this.scrollController,
  });

  final String? currentCapacity;
  final ScrollController scrollController;

  @override
  State<_SubPlanWidget> createState() => _AddSubPlanWidgetState();
}

class _AddSubPlanWidgetState extends State<_SubPlanWidget> {
  late final TextEditingController _capacityCntrl;


  @override
  void initState() {
    super.initState();
    _capacityCntrl = TextEditingController(
      text: widget.currentCapacity
    );
  }

  @override
  void dispose() {
    _capacityCntrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 5, 15, 60),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ATModalDismisser(),
          const SizedBox(height: 10),
          Row(
            spacing: 5,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ATImgLoader(
                imgPath: ATImgStrings.usersIcon,
                height: 20, width: 20,
              ),
              Text(ATStrings.capacity, style: context.textTheme.bodyLarge),
            ],
          ),
          const SizedBox(height: 15),
          Text(ATStrings.maxCapacity,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                  color: ATColors.hexC2C2C2.withValues(alpha: 0.76))),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: <Widget>[
                   ATTextFormField(
                    controller: _capacityCntrl,
                    fillColor: ATColors.white.withValues(alpha: 0.1),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onTapOutside: (_) {},
                    disableBlueBorder: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: ATColors.transparent)),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: SizedBox.shrink()
                    ),
                    contentPadding: EdgeInsets.zero),
                ],
              ),
            ),
          ),
      
          Text(ATStrings.maxCapacityLimit,
              maxLines: 2,
              style: context.textTheme.labelSmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              )),
          const SizedBox(height: 15),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _capacityCntrl,
            builder: (_, TextEditingValue value, __) {
              final bool shouldSet = value.text.trim().isNotEmpty;
              return ATPlainElevatedBtn(
                  fgColor: ATColors.black,
                  bgColor: ATColors.white,
                  onPressed: shouldSet ? () {
                    context.pop(value.text.trim());
                  }
                : null,
                btnTitle: ATStrings.setCapacity);
            }
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: (){_capacityCntrl.clear();},
            child: Text(
              ATStrings.remove,
              style: context.textTheme.bodyMedium?.copyWith(
                fontSize: 17
              )
            ),
          )
        ],
      ),
    );
  }
}
