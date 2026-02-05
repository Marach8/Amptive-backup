import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/bloc/fees_setup_bloc.dart';
import '../switch_acct/switch_acct_export.dart';


enum SubPlanScreenEntryPoint{creatorProfileSetup, programCreationSetup}

class CreatorSubPlanScreen extends StatelessWidget {
  const CreatorSubPlanScreen({
    super.key,
    required this.entryPoint,
  });

  final SubPlanScreenEntryPoint? entryPoint;

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(   
        appBar: const ATAppBar(
          leadingWidth: 30,
          leading: ATRoundedBackBtn(),
          titleText: ATStrings.SUB_PLAN,
          padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
        ),  

        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, kBottomNavigationBarHeight),
          child: Column(
            children: <Widget>[
              const SubPlanWidget(),
              const SizedBox(height: 10,),
              BlocSelector<SubPlanSetupBloc, List<int?>, int?>(
                selector: (List<int?> state) => state.last,
                builder: (_, int? state) {
                  final bool shouldHide = state != null && state != 0;
                  final bool hideSetupLaterBtn = entryPoint == SubPlanScreenEntryPoint.programCreationSetup 
                    || shouldHide;

                  return ATAnimatedXFade(
                    condition: hideSetupLaterBtn,
                    firstChild: const SizedBox.shrink(),
                    secondChild: Text(
                      ATStrings.ALLOW_FREE_SUB, maxLines: 2,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontSize: ATSizes.size11,
                      ),
                    ),
                  );
                }
              )
            ],
          ),
        ),
      
        bottomSheet: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 50),
          child: BlocSelector<SubPlanSetupBloc, List<int?>, int?>(
            selector: (List<int?> state) => state.last,
            builder: (_, int? state) {
              final bool shouldActivateBtn = state != null && state != 0;
              final bool is4rmProgramCreation = entryPoint == SubPlanScreenEntryPoint.programCreationSetup;
              final bool hideSetupLaterBtn = is4rmProgramCreation || shouldActivateBtn;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ATPlainElevatedBtn(
                    onPressed: shouldActivateBtn ? (){
                      if(is4rmProgramCreation){
                        context.pop();
                      }
                      else{
                        context.pushNamed(ATRoutes.CO_HOST_FEE_SETUP);
                      }
                    } : null,
                    btnTitle: is4rmProgramCreation ? ATStrings.DONE : ATStrings.SETUP_COHOST_FEE
                  ),
                  if(!hideSetupLaterBtn) const SizedBox(height: 15),
                  hideSetupLaterBtn ? const SizedBox.shrink() : InkWell(
                    onTap: (){},
                    radius: 5,
                    child: Text(
                      ATStrings.SETUP_LATER,
                      style: context.textTheme.bodyLarge
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
