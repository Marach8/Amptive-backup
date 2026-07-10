import 'dart:async' show StreamSubscription, Timer, StreamController;
import 'dart:io' show Directory, File;
import 'dart:math' as math;
import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:audio_session/audio_session.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/episodes/cubits/episodes_of_a_show_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/data/repository/episodes_repo_impl.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/data/repository/go_live_repo_impl.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/dashboard.dart';
import 'package:amptive/src/features/go_live/cubits/get_live_program_entry_token_cubit.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/go_live_onboarding_bottom_sheet.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:flutter/scheduler.dart' show Ticker;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// A go-live episode that hasn't been created yet. Nothing exists on the
/// backend until the host passes the mic test and the 3-2-1 countdown — so
/// abandoning onboarding leaves no orphan/live episode behind.
class PendingGoLiveEpisode {
  const PendingGoLiveEpisode({
    required this.showId,
    required this.payload,
  });

  final String showId;
  final CreateEpisodePayload payload;
}

class GoLiveOnboardingScreen extends StatelessWidget {
  const GoLiveOnboardingScreen({
    super.key,
    this.liveProgramEntryParams,
    this.pendingEpisode,
  });

  final LiveProgramData? liveProgramEntryParams;
  final PendingGoLiveEpisode? pendingEpisode;

  @override
  Widget build(BuildContext context) {
    final String paletteImage = pendingEpisode?.payload.thumbnailUrl ??
        liveProgramEntryParams?.coverUrl ??
        '';
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<GoLiveOnboardBloc>(
          create: (_) => GoLiveOnboardBloc(),
        ),
        BlocProvider<DominantColorCubit>(
          create: (_) {
            final DominantColorCubit cubit = DominantColorCubit();
            if (paletteImage.trim().isNotEmpty) {
              cubit.extractColor(paletteImage);
            }
            return cubit;
          },
        ),
      ],
      child: _SubWidget(
        liveProgramEntryParams: liveProgramEntryParams,
        pendingEpisode: pendingEpisode,
      ),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({this.liveProgramEntryParams, this.pendingEpisode});

  final LiveProgramData? liveProgramEntryParams;
  final PendingGoLiveEpisode? pendingEpisode;

  @override
  State<_SubWidget> createState() => _SubWidgetState();
}

class _SubWidgetState extends State<_SubWidget> with TickerProviderStateMixin {
  late final AnimationController _gradientAnimCntrl;
  late final AnimationController _entranceAnimCntrl;

  @override
  void initState() {
    super.initState();
    _gradientAnimCntrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _entranceAnimCntrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    )..forward();
    Future<void>.delayed(const Duration(milliseconds: 220), () {
      if (!mounted) return;
      SystemSound.play(SystemSoundType.click);
      HapticFeedback.lightImpact();
    });
  }

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final ValueNotifier<double> _amplitudeNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> _rippleRingNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _countDownIsVisibleNotifier =
      ValueNotifier<bool>(false);
  final ValueNotifier<bool> _reRecordBtnNotifier = ValueNotifier<bool>(false);

  int _maxTime = 5;
  final StreamController<int> _timeRemainingStreamCntrl =
      StreamController<int>.broadcast();
  Timer? _timer;

  StreamSubscription<RecordingDisposition>? _progressSub;
  StreamSubscription<PlaybackDisposition>? _playProgressSub;
  String? _currentRecordingPath;
  bool _hasPlayedAlready = false;

  Future<void> _closeOnboarding() async {
    _timer?.cancel();
    _countDownIsVisibleNotifier.value = false;
    _amplitudeNotifier.value = 0.0;
    try {
      await _recorder.stopRecorder();
    } catch (_) {}
    try {
      await _player.stopPlayer();
    } catch (_) {}
    if (mounted) context.pop(false);
  }

  // The voice's loudness over time, captured while recording, then replayed in
  // sync during playback so the orb reacts to the output exactly as it did to
  // the input. Entries are (elapsedMs, decibels).
  final List<(int, double)> _ampTimeline = <(int, double)>[];

  double _ampAt(int positionMs) {
    if (_ampTimeline.isEmpty) return 0;
    for (int i = _ampTimeline.length - 1; i >= 0; i--) {
      if (_ampTimeline[i].$1 <= positionMs) return _ampTimeline[i].$2;
    }
    return _ampTimeline.first.$2;
  }

  void _startAudioPlayCountDown() {
    _timer?.cancel();
    _maxTime = 5;
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

  /// Routes play-and-record audio to the LOUD (bottom) speaker — iOS defaults
  /// this mode to the quiet earpiece, which makes playback sound tiny.
  Future<void> _configureAudioSession() async {
    try {
      final AudioSession session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.defaultMode,
      ));
    } catch (e) {
      debugPrint('Audio session config failed: $e');
    }
  }

  Future<void> _startRecording() async {
    final PermissionStatus permStatus =
        await ATHelperFuncs.requestUserPermission(Permission.microphone);
    if (permStatus.isGranted) {
      try {
        await _configureAudioSession();
        _currentRecordingPath = await _getRecordingPath();
        await _player.stopPlayer();
        await _recorder.openRecorder();
        _ampTimeline.clear();
        _progressSub = _recorder.onProgress?.listen(
          (RecordingDisposition disposition) {
            _amplitudeNotifier.value = disposition.decibels ?? 0.0;
            _ampTimeline.add((
              disposition.duration.inMilliseconds,
              disposition.decibels ?? 0.0,
            ));
            if ((disposition.decibels ?? 0.0) >= 68) {
              _rippleRingNotifier.value = true;
              Future<void>.delayed(const Duration(milliseconds: 1000),
                  () => _rippleRingNotifier.value = false);
            }
          },
        );

        // Fast enough for the orb to track speech in real time.
        await _recorder
            .setSubscriptionDuration(const Duration(milliseconds: 60));

        _countDownIsVisibleNotifier.value = true;

        // Voice-memo quality: flutter_sound's defaults are telephone-grade
        // (16kHz / 16kbps) which sounds muffled — record at 44.1kHz / 128kbps.
        await _recorder.startRecorder(
          toFile: _currentRecordingPath,
          codec: Codec.aacADTS,
          sampleRate: 44100,
          bitRate: 128000,
          numChannels: 1,
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
      await _player.setVolume(1.0);
      // Drive the orb from the recorded loudness timeline, synced to the
      // playback position, so it moves with the voice on the way out too.
      await _player.setSubscriptionDuration(const Duration(milliseconds: 60));
      _playProgressSub?.cancel();
      _playProgressSub = _player.onProgress?.listen(
        (PlaybackDisposition d) {
          _amplitudeNotifier.value = _ampAt(d.position.inMilliseconds);
        },
      );
      await _player.startPlayer(
        fromURI: _currentRecordingPath!,
        codec: Codec.aacADTS,
        whenFinished: () async {
          _playProgressSub?.cancel();
          _amplitudeNotifier.value = 0.0;
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
    // The livestream is only started at the go-live countdown, so leaving
    // onboarding before that never marks the episode live — nothing to undo.
    _gradientAnimCntrl.dispose();
    _entranceAnimCntrl.dispose();
    _progressSub?.cancel();
    _playProgressSub?.cancel();
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
    final DominantColorLoaded? orbPalette =
        context.select<DominantColorCubit, DominantColorLoaded?>(
      (DominantColorCubit cubit) => cubit.state is DominantColorLoaded
          ? cubit.state as DominantColorLoaded
          : null,
    );
    double interval(
      double begin,
      double end, {
      Curve curve = Curves.easeOutCubic,
    }) {
      return curve.transform(
        ((_entranceAnimCntrl.value - begin) / (end - begin)).clamp(0.0, 1.0),
      );
    }

    return ATAnnotatedRegion(
      child: Scaffold(
          backgroundColor: ATColors.black,
          appBar: ATAppBar(
            leadingWidth: 48,
            leading: ATXBackBtn(onTapOverride: _closeOnboarding),
            padding: const EdgeInsets.fromLTRB(7, 0, 15, 0),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: AnimatedBuilder(
                    animation: Listenable.merge(
                      <Listenable>[_gradientAnimCntrl, _entranceAnimCntrl],
                    ),
                    builder: (_, __) {
                      final double bgOpacity = interval(0.1, 0.58);
                      return Transform(
                        transform: Matrix4.diagonal3Values(1.0, 1.8, 1.0),
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                          opacity: bgOpacity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: RadialGradient(
                                center: Alignment.bottomCenter,
                                radius:
                                    0.75 + (_gradientAnimCntrl.value * 0.15),
                                colors: const <Color>[
                                  Color(0xFF282828),
                                  Color(0xFF000000)
                                ],
                                stops: const <double>[0.0, 1.0],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(0, 96, 0, 100),
                  child: Column(
                    children: <Widget>[
                      AnimatedBuilder(
                        animation: _entranceAnimCntrl,
                        builder: (_, Widget? child) {
                          final double textEntrance = interval(0.62, 1);
                          return Opacity(
                            opacity: textEntrance,
                            child: Transform.scale(
                              scale: 0.96 + (0.04 * textEntrance),
                              child: child,
                            ),
                          );
                        },
                        child: BlocSelector<GoLiveOnboardBloc,
                            (OnboardStage, bool), OnboardStage>(
                          selector: ((OnboardStage, bool) state) => state.$1,
                          builder: (_, OnboardStage state) {
                            return InstructionsSwitcher(
                              stageIndex: state.index,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocSelector<GoLiveOnboardBloc, (OnboardStage, bool),
                              OnboardStage>(
                          selector: ((OnboardStage, bool) state) => state.$1,
                          builder: (_, OnboardStage state) {
                            final bool showPicture =
                                state == OnboardStage.isRecording ||
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
                                        onCountDownFinished: () async {
                                          if (!context.mounted) return;
                                          //Mark that this organizer has tested his mic
                                          final LocalUserDataCubit cubit =
                                              context
                                                  .read<LocalUserDataCubit>();
                                          final CachedUserData? data =
                                              cubit.currentUserData;
                                          cubit.updateUserDataLocally(
                                            (data ?? const CachedUserData())
                                                .copyWith(hasTestedMic: 'true'),
                                          );

                                          // Committed to going live: only NOW
                                          // create the episode and start its
                                          // livestream. Nothing exists on the
                                          // backend before this point, so
                                          // abandoning onboarding leaves no
                                          // orphan/live episode.
                                          String episodeId = '';
                                          String coverUrl = '';
                                          String title = '';
                                          String desc = '';

                                          final PendingGoLiveEpisode? pending =
                                              widget.pendingEpisode;
                                          if (pending != null) {
                                            final ApiResponse<Episode> resp =
                                                await EpisodesRepoImpl()
                                                    .createEpisode(
                                              showId: pending.showId,
                                              episodeData: pending.payload,
                                            );
                                            if (!context.mounted) return;
                                            final Episode? created =
                                                resp is Successful<Episode>
                                                    ? resp.data
                                                    : null;
                                            if (created == null) {
                                              showAppNotification2(
                                                context: context,
                                                text:
                                                    'Could not start the episode. Please try again.',
                                                type: NotificationType.failure,
                                              );
                                              context
                                                  .read<GoLiveOnboardBloc>()
                                                  .setStage(
                                                      OnboardStage.isPlaying);
                                              return;
                                            }
                                            EpisodesOfAShowCubit.invalidate(
                                                pending.showId);
                                            episodeId = created.episodeId ?? '';
                                            coverUrl =
                                                created.thumbnailUrl ?? '';
                                            title = created.title ?? '';
                                            desc = created.description ?? '';
                                          } else {
                                            final LiveProgramData? params =
                                                widget.liveProgramEntryParams;
                                            episodeId = params?.programId ?? '';
                                            coverUrl = params?.coverUrl ?? '';
                                            title = params?.programTitle ?? '';
                                            desc = params?.programDesc ?? '';
                                          }

                                          if (episodeId.isEmpty) {
                                            context.pop(true);
                                            return;
                                          }

                                          // Start the livestream and grab the
                                          // room token to enter the live room.
                                          final ApiResponse<
                                                  LiveProgramEntryToken>
                                              startResp =
                                              await GoLiveRepoImpl()
                                                  .startLiveProgram(
                                                      contentId: episodeId);
                                          if (!context.mounted) return;
                                          if (startResp
                                              is! Successful<
                                                  LiveProgramEntryToken>) {
                                            showAppNotification2(
                                              context: context,
                                              text:
                                                  'Could not go live. Please try again.',
                                              type: NotificationType.failure,
                                            );
                                            context
                                                .read<GoLiveOnboardBloc>()
                                                .setStage(
                                                    OnboardStage.isPlaying);
                                            return;
                                          }

                                          final LiveProgramEntryToken? token =
                                              startResp.data;
                                          final LiveProgramData liveData =
                                              LiveProgramData(
                                            roomEntryToken:
                                                token?.roomEntryToken ?? '',
                                            roomUrl: token?.roomUrl ?? '',
                                            streamId: token?.streamId ?? '',
                                            roomParticipantId:
                                                token?.roomParticipantId ?? '',
                                            role: ParticipantRole.host,
                                            programId: episodeId,
                                            coverUrl: coverUrl,
                                            programTitle: title,
                                            programDesc: desc,
                                          );

                                          // Close onboarding, then open the
                                          // live room.
                                          context.pop(true);
                                          dashboardKey.currentState
                                              ?.showLiveStreamOverlay(
                                                  liveProgramData: liveData);
                                        },
                                      )
                                    : ValueListenableBuilder<double>(
                                        key: const ValueKey<double>(1.01),
                                        valueListenable: _amplitudeNotifier,
                                        builder: (_, double db, __) {
                                          // Map mic decibels → 0..1 so the
                                          // orb reacts to the voice while
                                          // recording; calm otherwise.
                                          final double intensity = showPicture
                                              ? ((db - 30) / 25).clamp(0.0, 1.0)
                                              : 0.0;
                                          return AnimatedBuilder(
                                            animation: _entranceAnimCntrl,
                                            builder: (_, Widget? child) {
                                              final double orbEntrance =
                                                  interval(
                                                0.08,
                                                0.78,
                                                curve: Curves.easeOutBack,
                                              );
                                              final double orbOpacity =
                                                  interval(0.06, 0.38);
                                              return Opacity(
                                                opacity: orbOpacity,
                                                child: Transform.translate(
                                                  offset: Offset(
                                                    0,
                                                    240 * (1 - orbEntrance),
                                                  ),
                                                  child: Transform.scale(
                                                    scale: 0.54 +
                                                        (0.46 * orbEntrance),
                                                    child: child,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: _FluidOrb(
                                              size: 190,
                                              intensity: intensity,
                                              dominantColor:
                                                  orbPalette?.dominantColor ??
                                                      const Color(0xFF282828),
                                              vibrantColor:
                                                  orbPalette?.vibrantColor ??
                                                      const Color(0xFF5A5A5A),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomSheet: AnimatedBuilder(
            animation: _entranceAnimCntrl,
            builder: (_, Widget? child) {
              final double controlsEntrance = interval(0.72, 1);
              return IgnorePointer(
                ignoring: controlsEntrance < 0.98,
                child: Opacity(
                  opacity: controlsEntrance,
                  child: Transform.translate(
                    offset: Offset(0, 18 * (1 - controlsEntrance)),
                    child: child,
                  ),
                ),
              );
            },
            child: GoLiveOnboardingBottomSheet(
              countDownVisibilityNotifier: _countDownIsVisibleNotifier,
              reRecordButtonNotifier: _reRecordBtnNotifier,
              timeRemainingStreamController: _timeRemainingStreamCntrl,
              onShouldRecord: () => _startRecording(),
              onPlayRefresh: () => _hasPlayedAlready = false,
              onAutoPlayCountDownEnd: () =>
                  _hasPlayedAlready ? null : _startAudioPlayCountDown(),
            ),
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

/// A soft multicolour "voice orb" (like AI assistants) whose colours
/// flow continuously. Pass [intensity] 0..1 to make it react to voice level.
class _FluidOrb extends StatefulWidget {
  const _FluidOrb({
    required this.size,
    required this.dominantColor,
    required this.vibrantColor,
    this.intensity = 0,
  });

  final double size;
  final double intensity;
  final Color dominantColor;
  final Color vibrantColor;

  @override
  State<_FluidOrb> createState() => _FluidOrbState();
}

class _FluidOrbState extends State<_FluidOrb>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _lastTick = 0;
  // Accumulated shader time — advances faster while the host is talking, so
  // the flow speed follows the voice with no jumps (integrated, not scaled).
  double _shaderTime = 0;
  // Smoothed voice level (fast attack, slower release) so the reaction feels
  // alive but not jittery.
  double _level = 0;
  FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((Duration d) {
      final double now = d.inMicroseconds / 1e6;
      final double dt = (now - _lastTick).clamp(0.0, 0.05);
      _lastTick = now;

      final double target = widget.intensity;
      final double rate = target > _level ? 14.0 : 3.5;
      _level += (target - _level) * (dt * rate).clamp(0.0, 1.0);

      // Idle drifts at 1×; full voice pushes the flow up to ~5× speed.
      setState(() => _shaderTime += dt * (1.0 + 4.0 * _level));
    })
      ..start();
    _loadShader();
  }

  Future<void> _loadShader() async {
    final FragmentProgram program =
        await FragmentProgram.fromAsset('shaders/fluid_orb.frag');
    if (mounted) setState(() => _shader = program.fragmentShader());
  }

  @override
  void dispose() {
    _ticker.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double orbSize = widget.size;
    final double haloSize = widget.size * 1.2;
    final double scale = 1.0 + 0.08 * _level;
    return SizedBox(
      width: haloSize,
      height: haloSize,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Transform.scale(
            scale: scale,
            child: SizedBox(
              width: orbSize,
              height: orbSize,
              child: ClipOval(
                child: Stack(
                  children: <Widget>[
                    // GPU fragment-shader colour layer (domain-warped noise), so the
                    // colours stir and fold like liquid — ElevenLabs style.
                    if (_shader != null)
                      RepaintBoundary(
                        child: CustomPaint(
                          size: Size(orbSize, orbSize),
                          painter: _ShaderOrbPainter(
                            shader: _shader!,
                            time: _shaderTime,
                            intensity: _level,
                            dominantColor: widget.dominantColor,
                            vibrantColor: widget.vibrantColor,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _OrbDotsPainter(
                  intensity: _level,
                  time: _shaderTime,
                  dominantColor: widget.dominantColor,
                  vibrantColor: widget.vibrantColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbDotsPainter extends CustomPainter {
  _OrbDotsPainter({
    required this.intensity,
    required this.time,
    required this.dominantColor,
    required this.vibrantColor,
  });

  final double intensity;
  final double time;
  final Color dominantColor;
  final Color vibrantColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double shortest = math.min(size.width, size.height);
    final double orbRadius = shortest / 2.4;
    final double baseRadius = orbRadius * 1.14;
    final double maxPush = shortest * 0.065;
    const int dotCount = 68;

    _paintDotRing(
      canvas: canvas,
      center: center,
      shortest: shortest,
      dotCount: dotCount,
      radius: baseRadius,
      maxPush: maxPush,
      timeOffset: 0,
      angleOffset: 0,
      sizeScale: 1,
      alphaScale: 1,
    );
    _paintDotRing(
      canvas: canvas,
      center: center,
      shortest: shortest,
      dotCount: dotCount,
      radius: baseRadius + (shortest * 0.036),
      maxPush: maxPush * 0.82,
      timeOffset: 0.65,
      angleOffset: math.pi / dotCount,
      sizeScale: 0.86,
      alphaScale: 0.82,
    );
  }

  void _paintDotRing({
    required Canvas canvas,
    required Offset center,
    required double shortest,
    required int dotCount,
    required double radius,
    required double maxPush,
    required double timeOffset,
    required double angleOffset,
    required double sizeScale,
    required double alphaScale,
  }) {
    for (int i = 0; i < dotCount; i++) {
      final double angle = ((math.pi * 2 * i) / dotCount) + angleOffset;
      final double wave =
          (math.sin((time + timeOffset) * 4.2 + i * 0.72) + 1) / 2;
      final double groupedWave =
          (math.sin((time + timeOffset) * 2.4 + angle * 3.0) + 1) / 2;
      final double voicePush =
          maxPush * intensity * (0.35 + (0.65 * wave * groupedWave));
      final double idleBreath =
          shortest * 0.006 * math.sin((time + timeOffset) * 1.5 + i * 0.31);
      final double dotRadius = radius + voicePush + idleBreath;
      final Offset dotCenter = Offset(
        center.dx + math.cos(angle) * dotRadius,
        center.dy + math.sin(angle) * dotRadius,
      );
      final double dotSize = shortest *
          (0.009 + (0.009 * intensity * (0.35 + 0.65 * wave))) *
          sizeScale;

      final Color dotColor = Color.lerp(
            dominantColor,
            vibrantColor,
            0.35 + (0.65 * wave),
          ) ??
          vibrantColor;

      canvas.drawCircle(
        dotCenter,
        dotSize,
        Paint()
          ..color = dotColor.withValues(
            alpha: (0.34 + (0.44 * intensity)) * alphaScale,
          )
          ..maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            1.2 + (2.8 * intensity),
          ),
      );
      canvas.drawCircle(
        dotCenter,
        dotSize * 0.45,
        Paint()
          ..color = Colors.white.withValues(
            alpha: (0.18 + (0.22 * intensity)) * alphaScale,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbDotsPainter old) {
    return old.intensity != intensity ||
        old.time != time ||
        old.dominantColor != dominantColor ||
        old.vibrantColor != vibrantColor;
  }
}

class _ShaderOrbPainter extends CustomPainter {
  _ShaderOrbPainter({
    required this.shader,
    required this.time,
    required this.intensity,
    required this.dominantColor,
    required this.vibrantColor,
  });

  final FragmentShader shader;
  final double time;
  final double intensity;
  final Color dominantColor;
  final Color vibrantColor;

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, intensity)
      ..setFloat(4, dominantColor.r)
      ..setFloat(5, dominantColor.g)
      ..setFloat(6, dominantColor.b)
      ..setFloat(7, vibrantColor.r)
      ..setFloat(8, vibrantColor.g)
      ..setFloat(9, vibrantColor.b);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_ShaderOrbPainter old) =>
      old.time != time ||
      old.intensity != intensity ||
      old.dominantColor != dominantColor ||
      old.vibrantColor != vibrantColor;
}
