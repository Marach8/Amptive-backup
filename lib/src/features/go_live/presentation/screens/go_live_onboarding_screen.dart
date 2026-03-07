import 'dart:async' show StreamSubscription, Timer, StreamController;
import 'dart:io' show Directory, File;
import 'dart:ui';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_onboarding_bottom_sheet.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../shared/image_loader_widget.dart';

class GoLiveOnboardingScreen extends StatelessWidget {
  const GoLiveOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GoLiveOnboardBloc>(
      create: (_) => GoLiveOnboardBloc(),
      child: const _SubWidget(),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final ValueNotifier<double> _amplitudeNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> _rippleRingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _countDownIsVisibleNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _reRecordBtnNotifier = ValueNotifier<bool>(false);
  final PageController _pageCntrl = PageController();

  int _maxTime = 10;
  final StreamController<int> _timeRemainingStreamCntrl =
      StreamController<int>();
  Timer? _timer;

  StreamSubscription<RecordingDisposition>? _progressSub;
  String? _currentRecordingPath;
  bool _hasPlayedAlready = false;

  void _startAudioPlayCountDown() {
    _timer?.cancel();
    _maxTime = 10;
    _timeRemainingStreamCntrl.add(_maxTime);
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer tm) {
      _maxTime--;
      if (_maxTime >= 0) {
        _timeRemainingStreamCntrl.add(_maxTime);
      } else {
        //When we are done with the recording countdown, we want to hide
        //the info, then start playing the recorded audio.
        tm.cancel();
        _timer = null;
        if (_maxTime == -1) {
          _hasPlayedAlready = true;
          _countDownIsVisibleNotifier.value = false;
          _startPlaying();
        }
      }
    });
  }

  Future<String> _getRecordingPath() async {
    final Directory tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/mic_test_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  Future<void> _startRecording() async {
    final PermissionStatus permStatus =
        await ATHelperFuncs.requestUserPermission(Permission.microphone);
    if (permStatus.isGranted) {
      try {
        _currentRecordingPath = await _getRecordingPath();
        await _player.stopPlayer();
        await _recorder.openRecorder();
        _progressSub = _recorder.onProgress?.listen(
          (RecordingDisposition disposition) {
            _amplitudeNotifier.value = disposition.decibels ?? 0.0;
            if ((disposition.decibels ?? 0.0) >= 68) {
              _rippleRingNotifier.value = true;
              Future<void>.delayed(const Duration(milliseconds: 1000),
                  () => _rippleRingNotifier.value = false);
            }
          },
        );

        await _recorder
            .setSubscriptionDuration(const Duration(milliseconds: 500));

        _countDownIsVisibleNotifier.value = true;

        await _recorder.startRecorder(
          toFile: _currentRecordingPath,
          codec: Codec.aacADTS,
        );
      } catch (e) {
        debugPrint(e.toString());
      }
    } else if (permStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _startPlaying() async {
    if (_currentRecordingPath != null &&
        await _isValidAudioFile(_currentRecordingPath!)) {
      _amplitudeNotifier.value = 0.0;
      await _recorder.stopRecorder();
      await _player.openPlayer();
      await _player.startPlayer(
        fromURI: _currentRecordingPath!,
        codec: Codec.aacADTS,
        whenFinished: () async {
          final bool hasCleanedUp = await _cleanUpRecording();
          if (mounted && hasCleanedUp) {
            //When we are done playing audio, we want to activate our button.
            context.read<GoLiveOnboardBloc>().activateBtn(true);
            _reRecordBtnNotifier.value = true;
          }
        },
      );
      if (mounted) {
        context.read<GoLiveOnboardBloc>().setStage(OnboardStage.isPlaying);
      }
    }
  }

  Future<bool> _cleanUpRecording() async {
    if (_currentRecordingPath != null) {
      try {
        final File file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
        return true;
      } catch (_) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _isValidAudioFile(String path) async {
    try {
      final File file = File(path);
      return await file.exists() && await file.length() > 1024;
    } catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    _timer?.cancel();
    _timeRemainingStreamCntrl.close();
    _amplitudeNotifier.dispose();
    _countDownIsVisibleNotifier.dispose();
    _reRecordBtnNotifier.dispose();
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
          appBar: const ATAppBar(
            leadingWidth: 30,
            leading: ATXBackBtn(),
            padding: EdgeInsets.fromLTRB(7, 0, 15, 0),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                  bottom: 0,
                  right: -context.screenWidth * 0.3,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.ROTOR_IMG,
                      height: 350,
                      width: 350,
                    ),
                  )
                  // child: const RotatingRadialLines(
                  //   duration: Duration(seconds: 8),
                  //   child: RadialLinesWidget(),
                  // ),
                  ),
              Positioned(
                  bottom: 0,
                  left: -context.screenWidth * 0.2,
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const ATImgLoader(
                      imgPath: ATImgStrings.ROTOR_IMG1,
                      height: 350,
                      width: 350,
                    ),
                  )
                  // child: const RotatingRadialLines(
                  //   child: RadialLinesWidget(startAngle: 210, endAngle: 20),
                  // ),
                  ),
              Positioned.fill(
                child: ATScrollBar(
                  child: SingleChildScrollView(
                    primary: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 100),
                    child: Column(
                      children: <Widget>[
                        BlocListener<GoLiveOnboardBloc, (OnboardStage, bool)>(
                            listenWhen: ((OnboardStage, bool) prev,
                                    (OnboardStage, bool) curr) =>
                                prev.$1 != curr.$1,
                            listener: (_, (OnboardStage, bool) state) {
                              if (state.$1 == OnboardStage.initial) {
                                _pageCntrl.animateToPage(
                                  0,
                                  curve: Curves.decelerate,
                                  duration: const Duration(milliseconds: 800),
                                );
                                return;
                              }
                              _pageCntrl.nextPage(
                                  duration: const Duration(milliseconds: 1500),
                                  curve: Curves.decelerate);
                            },
                            child: InstructionsSwitcher(pageCntrl: _pageCntrl)),
                        const SizedBox(height: 30),
                        BlocSelector<GoLiveOnboardBloc, (OnboardStage, bool),
                                OnboardStage>(
                            selector: ((OnboardStage, bool) state) => state.$1,
                            builder: (_, OnboardStage state) {
                              final bool showPicture =
                                  state == OnboardStage.isRecording ||
                                      state == OnboardStage.isPlaying;
                              final bool isPlaying =
                                  state == OnboardStage.isPlaying;
                              final bool show123CountDown =
                                  state == OnboardStage.isGoingLive;

                              return SizedBox(
                                height: 200,
                                width: 200,
                                child: ATScalingSwitcher(
                                  curve: Curves.decelerate,
                                  duration: 800,
                                  child: show123CountDown
                                      ? OneTwoThreeCountDown(
                                          key: const ValueKey<double>(1.04),
                                          onCountDownFinished: () {
                                            context.pushReplacementNamed(
                                                ATRoutes.MAIN_GO_LIVE_PROGRAM,
                                                extra: GoLiveUserType.host);
                                          },
                                        )
                                      : showPicture
                                          ? Stack(
                                              key: const ValueKey<double>(1.01),
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.none,
                                              children: <Widget>[
                                                SingleRingRippleAnimation(
                                                    rippleNotifier:
                                                        _rippleRingNotifier),
                                                if (isPlaying)
                                                  const PlayProgressIndicator(),
                                                ValueListenableBuilder<double>(
                                                    valueListenable:
                                                        _amplitudeNotifier,
                                                    builder:
                                                        (_, double value, __) {
                                                      final double width = 10 *
                                                          ((value - 35) /
                                                              (70 - 35));
                                                      return Container(
                                                        height: 130,
                                                        width: 130,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(3),
                                                        decoration:
                                                            BoxDecoration(
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              spreadRadius:
                                                                  width,
                                                              blurRadius: 1,
                                                              color: ATColors
                                                                  .white
                                                                  .withValues(
                                                                      alpha:
                                                                          0.3),
                                                            )
                                                          ],
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: const SizedBox(),
                                                      );
                                                    }),
                                                CircleAvatar(
                                                    radius: 65,
                                                    backgroundColor:
                                                        ATColors.black),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadiusGeometry
                                                          .circular(100),
                                                  child: const ATImgLoader(
                                                      height: 123,
                                                      width: 123,
                                                      imgPath:
                                                          ATImgStrings.jpeg1,
                                                      boxFit: BoxFit.cover),
                                                ),
                                              ],
                                            )
                                          : const SizedBox.shrink(
                                              key: ValueKey<double>(1.02),
                                            ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: GoLiveOnboardingBottomSheet(
            countDownVisibilityNotifier: _countDownIsVisibleNotifier,
            reRecordButtonNotifier: _reRecordBtnNotifier,
            timeRemainingStreamController: _timeRemainingStreamCntrl,
            onShouldRecord: () => _startRecording(),
            onPlayRefresh: () => _hasPlayedAlready = false,
            onAutoPlayCountDownEnd: () =>
                _hasPlayedAlready ? null : _startAudioPlayCountDown(),
          )),
    );
  }
}

enum OnboardStage { initial, isRecording, isPlaying, isGoingLive }

class GoLiveOnboardBloc extends Cubit<(OnboardStage, bool)> {
  GoLiveOnboardBloc() : super((OnboardStage.initial, true));

  void setFullState((OnboardStage?, bool?) input) =>
      emit((input.$1 ?? state.$1, input.$2 ?? state.$2));

  void setStage(OnboardStage stage) => emit((stage, state.$2));

  void activateBtn(bool activateBtn) => emit((state.$1, activateBtn));
}
