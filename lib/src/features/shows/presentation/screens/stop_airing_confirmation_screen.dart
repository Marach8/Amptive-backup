import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/shows/cubits/cancel_show_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/spotlight_beam.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';

class StopAiringConfirmationScreenParams {
  const StopAiringConfirmationScreenParams({
    required this.showId,
    required this.title,
    required this.coverUrl,
  });

  final String showId;
  final String title;
  final String? coverUrl;
}

class StopAiringConfirmationScreen extends StatefulWidget {
  const StopAiringConfirmationScreen({super.key, required this.params});
  final StopAiringConfirmationScreenParams params;

  @override
  State<StopAiringConfirmationScreen> createState() =>
      _StopAiringConfirmationScreenState();
}

class _StopAiringConfirmationScreenState
    extends State<StopAiringConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _spotlightFadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));

    _scaleAnimation = Tween<double>(begin: 4.5, end: 1.0).animate(
        CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack)));

    _spotlightFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.6, 1.0, curve: Curves.easeOut)));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animController.forward();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CancelShowCubit>(
      create: (_) => CancelShowCubit(),
      child: ATAnnotatedRegion(
        child: Scaffold(
          appBar: ATAppBar(
            leadingWidth: 30,
            leading: ATXBackBtn(
              onTapOverride: () => context.pop(),
            ),
            padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
          ),
          body: Container(
            height: context.screenHeight,
            width: context.screenWidth,
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 80),
                Text(
                  textAlign: TextAlign.center,
                  'Are you sure you want to stop airing this show?',
                  maxLines: 3,
                  style: context.textTheme.displaySmall?.copyWith(
                      fontSize: ATSizes.size23, letterSpacing: -0.39),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: LayoutBuilder(builder: (_, BoxConstraints kst) {
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Positioned(
                          top: 140,
                          child: FadeTransition(
                            opacity: _spotlightFadeAnimation,
                            child: SpotlightBeam(
                              height: kst.maxHeight,
                              width: context.screenWidth * 2,
                              halfWidthOfSpot: 67,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  ATColors.hex0D0D0D,
                                  ATColors.hex090909
                                ],
                              ),
                            ),
                          ),
                        ),
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: 140,
                              width: 134,
                              child: widget.params.coverUrl != null &&
                                      widget.params.coverUrl!.isNotEmpty
                                  ? ATImgLoader(
                                      imgPath: widget.params.coverUrl!,
                                      boxFit: BoxFit.cover,
                                      width: 134,
                                      height: 140,
                                    )
                                  : Container(
                                      color: const Color(0xFF1F1F1F),
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.white30, size: 40),
                                    ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: context.screenWidth,
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: BlocConsumer<CancelShowCubit,
                                ATAppState<HostedShow>>(
                              listener: (context, state) {
                                if (state is SuccessState<HostedShow>) {
                                  showAppNotification2(
                                    context: context,
                                    text: 'Show has been successfully cancelled.',
                                    type: NotificationType.success,
                                  );
                                  // Pop confirmation screen
                                  context.pop(true);
                                } else if (state is FailureState<HostedShow>) {
                                  showAppNotification2(
                                    context: context,
                                    text: state.message,
                                    type: NotificationType.failure,
                                  );
                                }
                              },
                              builder: (context, state) {
                                final bool isLoading =
                                    state is LoadingState<HostedShow>;

                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ATPlainElevatedBtn(
                                      onPressed: isLoading
                                          ? () {}
                                          : () {
                                              context
                                                  .read<CancelShowCubit>()
                                                  .cancelShow(
                                                      showId: widget
                                                          .params.showId);
                                            },
                                      btnTitle: 'Stop airing',
                                      bgColor: const Color(0xFFE50914),
                                      fgColor: ATColors.white,
                                      isLoading: isLoading,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: ATColors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                    InkWell(
                                        onTap: isLoading
                                            ? null
                                            : () => context.pop(),
                                        borderRadius: BorderRadius.circular(5),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: Text(
                                            'Cancel',
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                                    fontSize: ATSizes.size17),
                                          ),
                                        ))
                                  ],
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
