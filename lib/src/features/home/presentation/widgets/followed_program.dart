import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/extensions/num_extensions.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/live_indicators.dart';
import 'package:amptive/src/shared/list_tile_with_leading_picture_widget.dart';
import 'package:amptive/src/shared/overlapping_widgets.dart';
import 'package:amptive/src/features/home/presentation/widgets/with_2_others_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/features/home/data/models/following_status.dart';
import 'package:amptive/src/features/home/cubits/toggle_following_cubit.dart';
import 'package:amptive/src/features/home/presentation/widgets/program_actions_modal.dart';
import '../../../../services/create_show/create_show_service.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/added_or_removed_from_calender_dialog.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/features/home/presentation/widgets/cohosts_list_modal.dart';
import 'package:amptive/src/shared/global_model_objects.dart' hide Host;
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:figma_squircle/figma_squircle.dart';

class FollowedProgram extends StatefulWidget {
  const FollowedProgram({super.key, this.isEvent = false});
  final bool isEvent;

  @override
  State<FollowedProgram> createState() => _FollowedProgramState();
}

class _FollowedProgramState extends State<FollowedProgram> {
  bool isAdded2Calender = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ToggleFollowingCubit>(
      create: (_) => ToggleFollowingCubit(
        initialStatus: const FollowingStatus(isFollowing: true, followerCount: 0),
      ),
      child: Builder(
        builder: (context) {
          return Column(
            children: <Widget>[
        TileWithLeadingImage(
          leadingImagePath: '',
          trailingOnPressed: () async {
            await showProgramOptions(
              context: context,
              toggleFollowingCubit: context.read<ToggleFollowingCubit>(),
              targetUserName: 'glennodoyle',
              targetUserId: 'mock_glenn_id',
            );
          },
          title: 'glennodoyle',
          subtitle: widget.isEvent ? 'scheduled an event' : 'scheduled an episode',
        ),
        const SizedBox(height: 2),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: ShapeDecoration(
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 16,
                cornerSmoothing: 0.6,
              ),
            ),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ATImgLoader(
                  imgPath: ATImgStrings.weCanDoHardThingsBgImage,
                  height: MediaQuery.sizeOf(context).width - 16,
                  width: MediaQuery.sizeOf(context).width,
                  boxFit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.fromLTRB(17, 15, 17, 15),
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 16,
                      cornerSmoothing: 0.6,
                    ),
                  ),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const <double>[0.0, 0.5, 0.65, 0.75, 1.0],
                      colors: <Color>[
                        ATColors.transparent,
                        ATColors.transparent,
                        ATColors.containerGradientColorB.withValues(alpha: 0.95),
                        ATColors.containerGradientColorB,
                        ATColors.containerGradientColorB,
                      ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    With2OthersWidget(
                      coHosts: [
                        const CoHost(userId: 'c1', name: 'Abby Wambach', username: 'abbywambach'),
                        const CoHost(userId: 'c2', name: 'Amanda Doyle', username: 'amandadoyle'),
                      ],
                      onTap: () {
                        showCohostsModal(
                          context: context,
                          coHosts: [
                            const CoHost(userId: 'c1', name: 'Abby Wambach', username: 'abbywambach'),
                            const CoHost(userId: 'c2', name: 'Amanda Doyle', username: 'amandadoyle'),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 200),
                    Text(
                      maxLines: 2,
                      "Don't Forget Who You Are ft. Jacob Scipio",
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: ATSizes.size24,
                                fontWeight: ATFontWeights.w700,
                                height: 1.2,
                              ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Sun, 15 Jul • 5:00 PM',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                            fontSize: ATSizes.size14,
                            fontWeight: ATFontWeights.w600,
                            color: ATColors.hexFED601,
                          ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ATOverlappingImages(
                          imgPaths: getHostList()
                              .take(3)
                              .map<String>((ObjectWithNotifier<Host> host) =>
                                  host.obj.profilePicture ?? '')
                              .toList(),
                          imgSize: 35,
                          overlapOffset: 15,
                          borderWidth: 2,
                          borderColor: ATColors.containerGradientColorB,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text('${656.compactFormat} listening',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontSize: ATSizes.size13)),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: ATContainer(
                            color: ATColors.hex0D0D0D,
                            radius: 5,
                            padding: const EdgeInsets.all(8.5),
                            child: Text(ATStrings.paidShow.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                        fontWeight: ATFontWeights.w500,
                                        fontSize: ATSizes.size10)),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final bool currentlyAdded = isAdded2Calender;
                            
                            setState(() {
                              isAdded2Calender = !currentlyAdded;
                            });

                            showAddedOrRemovedSnackbar(
                                context: context,
                                content: currentlyAdded
                                    ? ATStrings.REMOVED_4RM_CAL
                                    : ATStrings.ADDED_2_CALL);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              transitionBuilder: (Widget child, Animation<double> animation) {
                                return ScaleTransition(
                                  scale: animation,
                                  child: child,
                                );
                              },
                              child: Container(
                                key: ValueKey('rsvp_btn_$isAdded2Calender'),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isAdded2Calender ? ATColors.hexFED601 : ATColors.hexB6B6B6.withOpacity(0.15),
                                  border: isAdded2Calender 
                                      ? null 
                                      : Border.all(color: ATColors.hexB6B6B6.withOpacity(0.4), width: 1.5),
                                ),
                                child: Icon(
                                  isAdded2Calender ? Icons.check_rounded : Icons.add_rounded,
                                  color: isAdded2Calender ? ATColors.hex0D0D0D : Colors.white,
                                  size: 28,
                                ),
                              ),
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
      ),
    );
  }
}
