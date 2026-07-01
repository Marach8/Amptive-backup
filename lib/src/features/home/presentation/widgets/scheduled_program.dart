import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
import '../../../../shared/image_loader_widget.dart';

import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';

class ScheduledProgram extends StatefulWidget {
  const ScheduledProgram({super.key, this.showItem});
  final FollowedShowItem? showItem;

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
          leadingImagePath: widget.showItem?.hostProfileImageUrl ?? ATImgStrings.jpeg3,
          trailingOnPressed: () {},
          title: widget.showItem?.hostName ?? '',
          subtitle: 'scheduled a ${widget.showItem?.contentType ?? 'show'}',
        ),
        const SizedBox(height: 2),
        ATContainer(
          height: 425,
          clipBehavior: Clip.hardEdge,
          radius: 15,
          child: Stack(
            children: <Widget>[
              ATImgLoader(imgPath: widget.showItem?.showCoverUrl ?? ATImgStrings.weCanDoHardThingsBgImage),
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
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const With2OthersWidget(),
                    const Spacer(),
                    Text(
                      widget.showItem?.scheduledFor?.toFormattedDate ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontSize: ATSizes.size16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      maxLines: 2,
                      widget.showItem?.showTitle ?? " ",
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            fontSize: ATSizes.size24,
                            fontWeight: ATFontWeights.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ATOverlappingImages(
                          imgPaths: (widget.showItem?.avatarUrls ?? [])
                              .take(3)
                              .toList(),
                          imgSize: 30,
                          overlapOffset: 18,
                        ),
                        const SizedBox(width: 8),
                        Text('${widget.showItem?.goingCount ?? 0} going',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: ATSizes.size13)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ATContainer(
                          color: ATColors.hex0D0D0D,
                          radius: 5,
                          padding: const EdgeInsets.all(8.5),
                          child: Text(widget.showItem?.showType?.toUpperCase() ?? ATStrings.paidShow.toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontWeight: ATFontWeights.w500,
                                      fontSize: ATSizes.size10)),
                        ),
                        // Calendar button remains the same...
                      ],
                    ),
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
