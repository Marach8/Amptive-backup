import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/features/switch_account/presentation/widgets/subscription_plan_setup_modal.dart';
import 'package:amptive/src/features/switch_account/presentation/widgets/delete_subscription_plan_modal.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../profile/bloc/fees_setup_bloc.dart';


class SubPlanWidget extends StatelessWidget {
  const SubPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SubPlanSetupBloc, List<int?>, int?>(
      selector: (List<int?> state) => state.last,
      builder: (_, int? state) {
        return ATContainer(
          onTap: state == null ? () => showSubPlanSetupModal(context) : null,
          color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
          radius: 14, alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          width: double.infinity,
          child: state == null ? Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.add),
              Text(
                ATStrings.ADD_NEW,
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: ATSizes.size16,
                ),
              )
            ],
          ) : Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  const ATImgLoader(imgPath: ATImgStrings.PADLOCK),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ATStrings.SUB_OVERVIEW,
                          style: context.textTheme.bodySmall?.copyWith(
                            fontSize: ATSizes.size15
                          ),
                        ),
                        Text(
                          ATStrings.SUB_OVERVIEW_DESC, maxLines: 3,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontSize: ATSizes.size13
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
        
                  IconButton(
                    onPressed: ()async{
                      final bool? shouldDelete = await showDeleteSubscriptionPlanOptionModal(context);
                      if(context.mounted && shouldDelete == true){
                        final bool? delete = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.DELETE_SUB_PLAN,
                          content: ATStrings.DELETE_SUB_PLAN_DESC,
                          yesString: ATStrings.DELETE,
                          noString: ATStrings.cancel,
                        );
                        if(context.mounted && delete == true){
                          context.read<SubPlanSetupBloc>().resetPlan();
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
                      onTap: () => showSubPlanSetupModal(context),
                      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                      color: ATColors.white.withValues(alpha: 0.1),
                      radius: 5,
                      child: Text(
                        ATStrings.EDIT_SUB_PLAN,
                        style: context.textTheme.bodySmall?.copyWith(
                          fontSize: ATSizes.size12,
                          color: ATColors.white.withValues(alpha: 0.7)
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'N$state/month', maxLines: 2,
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontSize: ATSizes.size14
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        );
      }
    );
  }
}