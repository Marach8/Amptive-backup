import 'dart:ui';
import 'package:amptive/src/features/go_live/presentation/views/audience_view_controls.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/host.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/utils/dialogs/minimized_go_live_dialog.dart';
import '../../go_live_export.dart';
import '../widgets/audience_view_of_host_and_cohosts.dart';
import '../widgets/go_live_screen_header.dart';


class LiveProgramAudienceView extends StatelessWidget {
  const LiveProgramAudienceView({super.key, required this.goLiveHost});
  final ObjectWithNotifier<Host> goLiveHost;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AddCohostsBloc>(create: (_) => AddCohostsBloc()),
        BlocProvider<GoLiveControlsVisibilityBloc>(create: (_) => GoLiveControlsVisibilityBloc()),
      ],
      child: _SubWidget(goLiveHost: goLiveHost),
    );
  }
}


class _SubWidget extends StatelessWidget {
  const _SubWidget({
    required this.goLiveHost
  });

  final ObjectWithNotifier<Host> goLiveHost;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const ATImgLoader(
                imgPath: ATImgStrings.jpeg1,
                boxFit: BoxFit.fill
              ),
            ),
          ),
          
          ColoredBox(
            color: ATColors.hex0D0D0D.withValues(alpha: 0.9),
            child: Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, kToolbarHeight * 0.5, 15, 20),
                  child: GoLiveScreenHeader(exitIcon: _AudienceViewExitIcon(),),
                ),
            
                Align(
                  alignment: Alignment.centerLeft,
                  child: ATContainer(
                    onTap: (){},
                    margin: const EdgeInsets.only(left: 15), radius: 30,
                    padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                    color: ATColors.white.withValues(alpha: 0.1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ATImgLoader(imgPath: ATImgStrings.GROUP_ICON),
                        const SizedBox(width: 5),
                        Text(
                          ATStrings.SOCIETY,
                          style: context.textTheme.bodyMedium?.copyWith(
                            overflow: TextOverflow.fade, fontSize: ATSizes.size13,
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
                          if(isPortrait) Container(
                            height: 250,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: const AudienceViewOfHostAndCohostWidget(),
                          ) else const Expanded(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              child: SizedBox(height: 250, child: AudienceViewOfHostAndCohostWidget(),)
                            )
                          ),
    
                          const Expanded(
                            child: GoLiveComments()
                          ),
                        ],
                      );
                    }
                  )
                )
              ],
            ),
          ),
        ],
      ),
      
      resizeToAvoidBottomInset: false,
      bottomSheet: BlocBuilder<GoLiveControlsVisibilityBloc, bool>(
        builder: (BuildContext context, bool isVisible) {
          final double bottomInset = MediaQuery.viewInsetsOf(context).bottom;
          final double extraSpace = bottomInset == 0 ? 5.0 : bottomInset + 10;
          
          return ATAnimatedSlide(
            shouldSlide: isVisible,
            startOffset: const Offset(0, 1.5),
            endOffset: const Offset(0, 0),
            child: Container(
              color: bottomInset == 0 ? ATColors.black : ATColors.hex2C2F33,
              padding: EdgeInsets.fromLTRB(15, 5, 15, extraSpace),
              child: const GoLiveAudienViewControlsWidget(),
            ),
          );
        }
      ),
    );
  }
}


class _AudienceViewExitIcon extends StatelessWidget {
  const _AudienceViewExitIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: (){
        showMinimizedGoLiveState();
      },
      color: ATColors.white.withValues(alpha: 0.1),
      height: 35, width: 35, boxShape: BoxShape.circle,
      child: Icon(Icons.keyboard_arrow_down, size: 20,),
    );
  }
}
