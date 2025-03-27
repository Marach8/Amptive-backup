import 'dart:io';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../services/create_show/create_show_service.dart';
import '../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../constants/strings/other_strings.dart';


Future<String> showSelectAudienceAccessForShowsDialog(
  BuildContext context
)async{
  final notifier = ValueNotifier<String>('');
  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
    backgroundColor: ATColors.brandBlack,
    constraints: BoxConstraints.expand(height: ATHelperFuncs.getScreenHeight(context)),
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    builder: (_){      
      return Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => context.pop(''),
                child: Platform.isAndroid
                  ? Icon(
                    Icons.keyboard_arrow_down,
                    color: ATColors.white.withOpacity(0.6),
                  ) : ATContainer(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    radius: 5, height: 4, width: 30,
                    color: ATColors.white.withOpacity(0.6),
                    child: const SizedBox.shrink(),
                  ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                ATStrings.AUDIENCE_ACCESS,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Gap(20),
            Text(
              maxLines: 5,
              ATStrings.SHOW_AUDIENCE_ACCESS_DESC,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: ATColors.hexC2C2C2
              ),
            ),
            const Gap(20),
        
            AmptiveRebuilderWidget(
              notifier: notifier,
              builder: (_, value, __) {
                final isActive = value == ATStrings.FREE;
                return ATContainer(
                  duration: 100,
                  onTap: (){
                    if(value != ATStrings.FREE){
                      notifier.value = ATStrings.FREE;
                      service.audienceAccessController.text = ATStrings.FREE;

                    }
                    else{notifier.value = '';}
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15,
                  color: ATColors.hex2D2D2D,
                  border: Border.all(
                    width: 2,
                    color: isActive ? ATColors.hex307FE2 : ATColors.trspntColor
                  ),
                  child: Row(
                    children: [
                      const ATImgLoader(imgPath: ATImgStrings.PEOPLE),
                      const Gap(10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ATStrings.FREE,
                              style: Theme.of(context).textTheme.bodyMedium
                            ),
                            Text(
                              maxLines: 5,
                              ATStrings.SHOW_FREE_ACCESS,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: ATColors.hexC2C2C2
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      ATContainer(
                        height: 20, width: 20, radius: 20,
                        padding: const EdgeInsets.all(3),
                        color: isActive ? ATColors.hex307FE2 : ATColors.trspntColor,
                        border: Border.all(
                          color: isActive ? ATColors.hex307FE2 : ATColors.white,
                          strokeAlign: 5.0
                        ),
                        child: const SizedBox.shrink()
                      )
                    ],
                  ),
                );
              }
            ),
        
            const Gap(15),
        
            AmptiveRebuilderWidget(
              notifier: notifier,
              builder: (_, value, __) {
                final isActive = value == ATStrings.SUBSCRIBERS_ONLY;
                return ATContainer(
                  onTap: (){
                    if(value != ATStrings.SUBSCRIBERS_ONLY){
                      notifier.value = ATStrings.SUBSCRIBERS_ONLY;
                      service.audienceAccessController.text = ATStrings.SUBSCRIBERS_ONLY;

                    }
                    else{notifier.value = '';}
                  },
                  padding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
                  radius: 15, duration: 100,
                  color: ATColors.hex2D2D2D,
                  border: Border.all(
                    width: 2,
                    color: isActive ? ATColors.hex307FE2 : ATColors.trspntColor
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const ATImgLoader(imgPath: ATImgStrings.PADLOCK),
                          const Gap(10),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ATStrings.SUBSCRIBERS_ONLY,
                                  style: Theme.of(context).textTheme.bodyMedium
                                ),
                                Text(
                                  maxLines: 5,
                                  ATStrings.ACCESS_2_ONLY_SUBSCRIBERS,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: ATColors.hexC2C2C2
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(15),
                          ATContainer(
                            height: 20, width: 20, radius: 20,
                            padding: const EdgeInsets.all(3),
                            color: isActive ? ATColors.hex307FE2 : ATColors.trspntColor,
                            border: Border.all(
                              color: isActive ? ATColors.hex307FE2 : ATColors.white,
                              strokeAlign: 5.0
                            ),
                            child: const SizedBox.shrink()
                          )
                        ],
                      ),
                        
                      const Gap(15),
                      const Divider(height: 0.5),
                      const Gap(15),
                      Row(
                        children: [
                          ATContainer(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            color: ATColors.grey2Color,
                            radius: 5,
                            child: Text(
                              ATStrings.EDIT_SUB_PLAN,
                              style: Theme.of(context).textTheme.titleMedium
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'N1,900/month',
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
            ),
            const Spacer(),
        
            AmptiveRebuilderWidget(
              notifier: notifier,
              builder: (_, value, __) {
                final isActive = value == ATStrings.FREE 
                  || value == ATStrings.SUBSCRIBERS_ONLY;
                return AmptiveElevatedButtonWidget(
                  margin: EdgeInsets.zero,
                  onPressed: isActive ? (){context.pop(value);} : null,
                  buttonTitle: ATStrings.CONTINUE,
                  bgColor: ATColors.white,
                  fgColor: ATColors.black,
                );
              }
            )
          ]
        ),
      );
    }
  );
}

