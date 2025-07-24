import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/confirmation_alert_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/profile/creator_sub_plans_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/profile/delete_plan_dialog.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../../bloc/fees_setup_bloc.dart';

class CreatorSubPlanScreen extends StatelessWidget {
  const CreatorSubPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(     
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, kToolbarHeight * 0.8, 0, kBottomNavigationBarHeight),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const ATRoundedBackBtn(),
                    Text(
                      ATStrings.SUB_PLAN,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const Visibility(visible: false, child: ATRoundedBackBtn()),
                  ],
                ),
              ),
              const _AddNewSubPlan(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                child: Text(
                  ATStrings.ALLOW_FREE_SUB, maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: ATFontSizes.size11,
                  ),
                ),
              )
            ],
          ),
        ),
      
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
          child: BlocSelector<SubPlanSetupBloc, List<int?>, int?>(
            selector: (List<int?> state) => state.last,
            builder: (_, int? state) {
              final bool shouldActivate = state != null && state != 0;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ATPlainElevatedBtn(
                    onPressed: shouldActivate ? () => context.pushNamed(ATRoutes.CO_HOST_FEE_SETUP) : null,
                    btnTitle: ATStrings.SETUP_COHOST_FEE
                  ),
                  if(!shouldActivate) const SizedBox(height: 15),
                  shouldActivate ? const SizedBox.shrink() : InkWell(
                    onTap: (){},
                    radius: 5,
                    child: Text(
                      ATStrings.SETUP_LATER,
                      style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}




class _AddNewSubPlan extends StatelessWidget {
  const _AddNewSubPlan();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SubPlanSetupBloc,List<int?>, int?>(
      selector: (List<int?> state) => state.last,
      builder: (_, int? state) {
        return ATContainer(
          color: ATColors.hex9E9E9E.withValues(alpha: 0.3),
          radius: 14, alignment: Alignment.center,
          margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          width: double.infinity,
          child: state == null ? GestureDetector(
            onTap: () => showCreatorSubPlans(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.add),
                Text(
                  ATStrings.ADD_NEW,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: ATFontSizes.size16,
                  ),
                )
              ],
            ),
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
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: ATFontSizes.size15
                          ),
                        ),
                        Text(
                          ATStrings.SUB_OVERVIEW_DESC, maxLines: 3,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontSize: ATFontSizes.size13
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
        
                  IconButton(
                    onPressed: ()async{
                      final bool? shouldDelete = await showDeletePlanOption(context);
                      if(context.mounted && shouldDelete == true){
                        final bool? delete = await showConfirmationDialog(
                          context: context,
                          title: ATStrings.DELETE_SUB_PLAN,
                          content: ATStrings.DELETE_SUB_PLAN_DESC,
                          yesString: ATStrings.DELETE,
                          noString: ATStrings.CANCEL,
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
                    InkWell(
                      onTap: () => showCreatorSubPlans(context),
                      borderRadius: BorderRadius.circular(5),
                      child: ATContainer(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                        color: ATColors.white.withValues(alpha: 0.1),
                        radius: 5,
                        child: Text(
                          ATStrings.EDIT_SUB_PLAN,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: ATFontSizes.size12,
                            color: ATColors.white.withValues(alpha: 0.7)
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        'N$state/month', maxLines: 2,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: ATFontSizes.size14
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


