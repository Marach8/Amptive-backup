import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/string_extensions.dart';
import 'package:amptive/src/config/utils/extensions/integer_extensions.dart';
import 'package:amptive/src/features/home/data/models/response/home_feed_response_model.dart';
import 'package:amptive/src/features/shows/data/models/response/followed_shows_response_model.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:amptive/src/shared/row_of_people_listening_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../shared/image_loader_widget.dart';

class FollowedProgram extends StatelessWidget {
  const FollowedProgram({super.key, this.showItem});
  final FollowedShowItem? showItem;

  @override
  Widget build(BuildContext context) {
    final bool isLive = showItem?.status?.toUpperCase() == 'LIVE';

    final int coHostCount = showItem?.coHosts?.length ?? 0;

    final String programLabel = getProgramLabel(
      type: showItem?.showType,
      category: showItem?.contentType,
    );

    return Column(
      children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: showItem?.hostProfileImageUrl ?? '',
          trailingOnPressed: () {},
          title: showItem?.hostName ?? '',
          subtitle: 'started a ${isLive ? 'live show' : 'show'}',
        ),
        const SizedBox(height: 2),
        ATContainer(
          height: 425,
          clipBehavior: Clip.hardEdge,
          radius: 15,
          child: Stack(
            children: <Widget>[
              ATImgLoader(
                imgPath: showItem?.showCoverUrl ?? '',
                boxFit: BoxFit.cover,
                height: 425,
                width: context.screenWidth,
              ),
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
                    // FIX: Pass co-host count
                    With2OthersWidget(coHostCount: coHostCount),
                    const Spacer(),
                    // FIX: Use isLive from correct comparison
                    if (isLive) ...<Widget>[
                      const LiveIndicatorWithAnimatingDot(),
                      const SizedBox(height: 10),
                    ],

                    Text(
                      maxLines: 2,
                      showItem?.showTitle ?? " ",
                      overflow: TextOverflow.clip,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: ATSizes.size24,
                                fontWeight: ATFontWeights.w600,
                              ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ATOverlappingImages(
                          imgPaths:
                              (showItem?.avatarUrls ?? <String>[]).take(3).toList(),
                          imgSize: 30,
                          overlapOffset: 18,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                            '${showItem?.viewerCount?.compactFormat ?? 0} listening',
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
                        Container(
                          padding: const EdgeInsets.all(8.5),
                          margin: const EdgeInsets.only(top: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ATColors.hex0D0D0D),
                          child: Text(
                            programLabel,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontWeight: FontWeight.w500, fontSize: 10),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 22.5,
                            backgroundColor: ATColors.hexB6B6B6,
                            child: Icon(
                              Icons.play_arrow,
                              color: ATColors.hex0D0D0D,
                              size: 30,
                            ),
                          ),
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

String getProgramLabel({
  String? type,
  String? category,
}) {
  final String upperType = type?.toUpperCase() ?? 'PAID';
  final String upperCategory = category?.toUpperCase() ?? 'EPISODE';

  return switch ((upperCategory, upperType)) {
    ('EPISODE', 'FREE') => 'SHOW',
    ('EPISODE', 'PAID') => '\$PAID SHOW',
    ('STANDALONE', 'FREE') => 'EVENT',
    ('STANDALONE', 'PAID') => '\$PAID EVENT',
    _ => 'SHOW',
  };
}
