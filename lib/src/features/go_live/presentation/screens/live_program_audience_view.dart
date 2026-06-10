import 'dart:ui';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/features/go_live/presentation/screens/audience_view_controls.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/livestream/livestream.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/sentinel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/minimized_live_program_indicator.dart';
import '../../go_live_export.dart';
import '../widgets/audience_view_of_host_and_cohosts.dart';
import '../widgets/live_program_header.dart';
import '../widgets/reactions_overlay.dart';

class LiveProgramAudienceView extends StatelessWidget {
  const LiveProgramAudienceView({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = context
      .read<LiveStreamCubit1>().state;
    final Community? community = state.community;
    final String? programCoverUrl = state.programCoverUrl;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
            child: ATImgLoader(
              imgPath: programCoverUrl ?? '',
              boxFit: BoxFit.fill,
              height: context.screenHeight,
              width: context.screenWidth,
            )
          ),
        ),
      
        ColoredBox(
          color: ATColors.hex0D0D0D.withValues(alpha: 0.9),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(
                        10, kToolbarHeight * 0.2, 15, 20),
                    child: LiveProgramHeader(
                      audienceMinimizeIcon: _AudienceViewMinimizeIcon(),
                    ),
                  ),
      
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ATContainer(
                      onTap: () {},
                      margin: const EdgeInsets.only(left: 15),
                      radius: 30,
                      padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                      color: ATColors.white.withValues(alpha: 0.1),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const ATImgLoader(
                            imgPath: ATImgStrings.groupIcon,
                            height: 20, width: 20,
                            boxFit: BoxFit.cover,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            community?.name ?? 'General',
                            style: context.textTheme.bodyMedium?.copyWith(
                              overflow: TextOverflow.fade,
                              fontSize: ATSizes.size13,
                              color: ATColors.hexC2C2C2
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (_, BoxConstraints kst) {
                        final bool isPortrait = kst.maxHeight > kst.maxWidth;
                        return Flex(
                          direction: isPortrait ? Axis.vertical : Axis.horizontal,
                          children: <Widget>[
                            if (isPortrait)
                              Container(
                                height: 250,
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: const AudienceViewOfHostAndCohosts(),
                              )
                            else
                              const Expanded(
                                child: SingleChildScrollView(
                                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: SizedBox(
                                      height: 250,
                                      child: AudienceViewOfHostAndCohosts(),
                                    )
                                  )
                                ),
                            const Expanded(child: GoLiveCommentsAndNotifications()),
                          ],
                        );
                      }
                    )
                  ),
                ],
              ),
    
              Positioned(
                bottom: 0, right: 0, left: 0,
                child: BlocBuilder<GoLiveControlsVisibilityBloc, bool>(
                  builder: (BuildContext context, bool isVisible) {
                    final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
                    final double extraSpace = bottomInset == 0 ? 10.0 : bottomInset + 10;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: bottomInset == 0 ? ATColors.black
                        : ATColors.hex2C2F33,
                      padding: EdgeInsets.fromLTRB(15, 5, 15, extraSpace),
                      //child: Container(height: 40, color: Colors.green),
                      child: const AudienceViewControls(),
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _AudienceViewMinimizeIcon extends StatelessWidget {
  const _AudienceViewMinimizeIcon();

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: () {
        liveProgramOverlayKey.currentState?.minimize();
      },
      color: ATColors.white.withValues(alpha: 0.1),
      height: 35, width: 35, radius: 30,
      child: const Icon(
        Icons.keyboard_arrow_down,
        size: 20,
      ),
    );
  }
}
