import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
import '../../../../config/utils/dialogs/options_dialog.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';


class ScheduledProgram extends StatefulWidget {
  const ScheduledProgram({
    super.key,
    this.scheduleDateAndTime
  });
  final String? scheduleDateAndTime;

  @override
  State<ScheduledProgram> createState() => _ScheduledProgramState();
}

class _ScheduledProgramState extends State<ScheduledProgram> {
  bool isAdded2Calender = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
            children: <Widget>[
              const ATImgLoader(imgPath: ATImgStrings.weCanDoHardThingsBgImage),
              ATContainer(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                radius: 15,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ATColors.transparent,
                    ATColors.transparent,
                    ATColors.transparent,
                    ATColors.transparent,
                    ATColors.containerGradientColorB.withOpacity(0.5),
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                    ATColors.containerGradientColorB,
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const AmptiveWith2OthersWidget(),
                    const Spacer(),
                    Text(
                      '15 Jul 2024 at 17:00',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: ATSizes.size16
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: ATSizes.size24,
                        fontWeight: ATFontWeights.w600,
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ATOverlappingImages(
                          imgPaths: getHostList().take(3).map(
                            (ObjectWithNotifier<Host> host) => host.obj.profilePicture ?? ''
                          ).toList(),
                          imgSize: 30, overlapOffset: 18,
                        ),
                        const SizedBox(width: 8,),
                        Text(
                          '656 going',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: ATSizes.size13
                          )
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ATContainer(
                          color: ATColors.hex0D0D0D, radius: 5,
                          padding: const EdgeInsets.all(8.5),
                          child: Text(
                            ATStrings.paidShow.toUpperCase(),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: ATFontWeights.w500,
                              fontSize: ATSizes.size10
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
                                  (bool? result){}
                                );
                                setter(() => isAdded2Calender = !isAdded2Calender);
                              },
                              height: 45, width: 45, radius: 30,
                              color: ATColors.hexB6B6B6,
                              child: Icon(
                                isAdded2Calender ? Icons.check : Icons.add,
                                color: ATColors.hex0D0D0D, size: 30,
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
