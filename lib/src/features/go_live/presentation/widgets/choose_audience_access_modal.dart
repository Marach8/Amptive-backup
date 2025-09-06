import 'package:amptive/src/features/profile/bloc/fees_setup_bloc.dart';
import 'package:amptive/src/features/profile/presentation/views/profile_views_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/radio_button.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/dismiss_modal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<String?> chooseAudienceAccess4ShowModal({
  required BuildContext context,
  required String initialAccessType,
}) async {
  return await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: ATColors.black,
    builder: (BuildContext dContext) {
      return BlocProvider<_AudienceAccessBloc>(
        create: (_) => _AudienceAccessBloc()..initializeAccessType(initialAccessType),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 1,
          builder: (BuildContext bContext, _) {
            return Container(
              margin: const EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 10),
              padding: const EdgeInsets.all(15),
              height: context.screenHeight,
              width: context.screenWidth,
              decoration: BoxDecoration(
                color: ATColors.hex202020,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Align(alignment: Alignment.center, child: ATModalDismisser()),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      ATStrings.AUDIENCE_ACCESS,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Text(
                    maxLines: 5,
                    ATStrings.PROMPTED_2_SETUP_SUB_PLAN,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                    ),
                  ),

                  const SizedBox(height: 15,),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: BlocBuilder<_AudienceAccessBloc, String?>(
                        builder: (_, String? state) {
                          final bool isFree = state == ATStrings.FREE;
                          final bool isPaid = state == ATStrings.SUBSCRIBERS_ONLY;

                          return Column(
                            children: <Widget>[
                              ATContainer(
                                duration: 100,
                                onTap: () => bContext.read<_AudienceAccessBloc>().chooseAudAccessType(
                                  isFree ? null : ATStrings.FREE
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: isFree ? ATColors.hex307FE2 : ATColors.trsprnt
                                ),
                                child: Row(
                                  children: <Widget>[
                                    const ATImgLoader(imgPath: ATImgStrings.PEOPLE),
                                    const Gap(10),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            ATStrings.FREE,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontSize: ATSizes.size15
                                            )
                                          ),
                                          Text(
                                            maxLines: 5,
                                            ATStrings.SHOW_FREE_ACCESS,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                              color: ATColors.hexC2C2C2, fontSize: ATSizes.size13
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    ATRadioBtn(isSelected: isFree),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 15,),

                              ATContainer(
                                onTap: () => bContext.read<_AudienceAccessBloc>().chooseAudAccessType(
                                  isPaid ? null : ATStrings.SUBSCRIBERS_ONLY
                                ),
                                padding: const EdgeInsets.fromLTRB(10, 13, 15, 13),
                                radius: 15, duration: 100, color: ATColors.hex2D2D2D,
                                border: Border.all(
                                  width: 2,
                                  color: isPaid ? ATColors.hex307FE2 : ATColors.trsprnt
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        const ATImgLoader(imgPath: ATImgStrings.PADLOCK),
                                        const Gap(10),
                                        Expanded(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ATStrings.SUBSCRIBERS_ONLY,
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  fontSize: ATSizes.size15
                                                )
                                              ),
                                              Text(
                                                maxLines: 5,
                                                ATStrings.ACCESS_2_ONLY_SUBSCRIBERS,
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: ATColors.hexC2C2C2, fontSize: ATSizes.size13
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 15,),
                                        ATRadioBtn(isSelected: isPaid),
                                      ],
                                    ),
                                      
                                    const SizedBox(height: 15,),
                                    const ATDivider(),
                                    const SizedBox(height: 15,),

                                    BlocBuilder<SubPlanSetupBloc, List<int?>>(
                                      builder: (_, List<int?> state) {
                                        return Row(
                                          children: <Widget>[
                                            ATContainer(
                                              onTap: (){                                            
                                                context.pushNamed(
                                                  ATRoutes.CREATOR_SUB_PLAN,
                                                  extra: SubPlanScreenEntryPoint.programCreationSetup,
                                                );
                                              },
                                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                              color: ATColors.white.withValues(alpha: 0.1), radius: 5,
                                              child: Text(
                                                state.first == null ? ATStrings.SETUP_SUB_PLAN : ATStrings.EDIT_SUB_PLAN,
                                                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                  color: ATColors.white.withValues(alpha: 0.7)
                                                )
                                              ),
                                            ),
                                            const SizedBox(width: 10,),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  state.first == null ? '' : '${ATStrings.NAIRA_TEXT}${state.first}/month',
                                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                    fontSize: ATSizes.size14,
                                                  )
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    )
                  ),
                  const SizedBox(height: 15,),

                  BlocBuilder<_AudienceAccessBloc, String?>(
                    builder: (_, String? state) {
                      return ATPlainElevatedBtn(
                        height: 50,
                        onPressed: state == null ? null : () => dContext.pop(state),
                        btnTitle: ATStrings.CONTINUE,
                      );
                    }
                  )
                ],
              )
            );
          },
        ),
      );
    },
  );
}



class _AudienceAccessBloc extends Cubit<String?>{
  _AudienceAccessBloc(): super(null);

  void chooseAudAccessType(String? type)
    => emit(type);

  void initializeAccessType(String initialAccessType){
    if(initialAccessType == ATStrings.SELECT_WHO_CAN_ACCESS_SHOW){
      emit(null);
    }
    else{
      emit(initialAccessType);
    }
  }
}