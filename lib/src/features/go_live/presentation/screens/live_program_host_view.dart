import 'dart:ui';
import 'package:amptive/src/features/go_live/cubits/livestream_cubit1.dart';
import 'package:amptive/src/features/go_live/data/models/livestream_state.dart';
import 'package:amptive/src/livestream/livestream.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/live_program_header.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/reactions_overlay.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/gift_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global_export.dart';
import '../../go_live_export.dart';

class LiveProgramHostView extends StatelessWidget {
  const LiveProgramHostView({super.key});

  @override
  Widget build(BuildContext context) {
    final LiveStreamState1 state = context
      .read<LiveStreamCubit1>().state;
    final Community? community = state.community;
    final String? programCoverUrl = state.programCoverUrl;

    return Scaffold(
      body: Stack(
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
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(
                    10, kToolbarHeight * 0.5, 15, 20),
                  child: LiveProgramHeader(),
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
                        // BlocBuilder<LiveStreamCubit1, LiveStreamState1>(
                        //   builder: (_, state){
                        //     return Text(
                        //       '${state.connectionStatus}',
                        //     );
                        //   }
                        // ),
                        const SizedBox(width: 5),
                        Text(
                          community?.name ?? '',
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
                    child: LayoutBuilder(builder: (_, BoxConstraints kst) {
                  final bool isPortrait = kst.maxHeight > kst.maxWidth;
                  return Flex(
                    direction: isPortrait ? Axis.vertical : Axis.horizontal,
                    children: <Widget>[
                      if (isPortrait)
                        Container(
                          height: 250,
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: const HostViewOfHostNdCohostDisplay()
                        )
                      else
                        const Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: SizedBox(
                                height: 250,
                                child: HostViewOfHostNdCohostDisplay()
                              )
                            )
                          ),
                      const Expanded(child: GoLiveComments()),
                    ],
                  );
                }))
              ],
            ),
          ),
          const Positioned.fill(child: ReactionsOverlay()),
          const Positioned.fill(child: GiftOverlay()),
        ],
      ),

      resizeToAvoidBottomInset: false,
      bottomSheet: BlocBuilder<GoLiveControlsVisibilityBloc, bool>(
          builder: (BuildContext context, bool isVisible) {
        final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        final double extraSpace = bottomInset == 0 ? 10.0 : bottomInset + 10;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          color: bottomInset == 0 ? ATColors.black : ATColors.hex2C2F33,
          padding: EdgeInsets.fromLTRB(15, 5, 15, extraSpace),
          child: const HostModerationToolsBtns(),
        );
      }),
    );
  }
}
