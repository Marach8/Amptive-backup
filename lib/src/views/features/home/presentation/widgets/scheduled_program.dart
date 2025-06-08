import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/font_weights.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/overlapping_images.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/route_strings.dart';
import '../../../../../utils/dialogs/added_or_removed_from_calender_dialog.dart';
import '../../../../../utils/dialogs/options_dialog.dart';
import '../../../../widgets/common_widgets/image_loader_widget.dart';


class ScheduledProgram extends StatefulWidget {
  final String? scheduleDateAndTime;
  const ScheduledProgram({
    super.key,
    this.scheduleDateAndTime
  });

  @override
  State<ScheduledProgram> createState() => _ScheduledProgramState();
}

class _ScheduledProgramState extends State<ScheduledProgram> {
  bool isAdded2Calender = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TileWithLeadingImage(
          leadingImagePath: ATImgStrings.jpeg3,
          trailingOnPressed: (){
            showProgramOptions(context);
          },
          title: 'glennodoyle',
          subtitle: 'scheduled a live show',
        ),
        const SizedBox(height: 2),
        ATContainer(
          height: 425, clipBehavior: Clip.hardEdge, radius: 15,
          child: Stack(
            children: [
              const ATImgLoader(imgPath: ATImgStrings.weCanDoHardThingsBgImage),
              ATContainer(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 15,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.trsprnt,
                    ATColors.containerGradientColorB.withOpacity(0.5),
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    Text(
                      '15 Jul 2024 at 17:00',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATFontSizes.size16
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: ATFontSizes.size24,
                        fontWeight: ATFontWeights.w600,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ATOverlappingImages(
                          imgPaths: getHostList().take(3).map(
                            (host) => host.obj.profilePicture ?? ''
                          ).toList(),
                          imgSize: 30, overlapOffset: 18,
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          '656 going',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: ATFontSizes.size13
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ATContainer(
                          color: ATColors.brandBlack, radius: 5,
                          padding: const EdgeInsets.all(8.5),
                          child: Text(
                            ATStrings.PAID_SHOW.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: ATFontWeights.w500,
                              fontSize: ATFontSizes.size10
                            )
                          ),
                        ),
                        StatefulBuilder(
                          builder: (_, setter) {
                            return ATContainer(
                              onTap: (){
                                showAddedOrRemovedSnackbar(
                                  context: context,
                                  content: isAdded2Calender ? ATStrings.REMOVED_4RM_CAL
                                    : ATStrings.ADDED_2_CALL
                                ).then(
                                  (result){}
                                );
                                setter(() => isAdded2Calender = !isAdded2Calender);
                              },
                              height: 45, width: 45, radius: 30,
                              color: ATColors.authHintColor,
                              child: Icon(
                                isAdded2Calender ? Icons.check : Icons.add,
                                color: ATColors.brandBlack, size: 30,
                              )
                            );
                          }
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
