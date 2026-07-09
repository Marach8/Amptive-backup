import 'dart:typed_data';

import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/go_live/cubits/program_cover_art_bloc.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The animated mesh-gradient backdrop for the create/edit form screens —
/// the same treatment the show/episode detail modals use. It watches the
/// screen's [BgImageCubit] and re-tints the mesh from whichever cover art
/// the user selects.
class ProgramFormMeshBackground extends StatefulWidget {
  const ProgramFormMeshBackground({super.key, required this.child});

  final Widget child;

  @override
  State<ProgramFormMeshBackground> createState() =>
      _ProgramFormMeshBackgroundState();
}

class _ProgramFormMeshBackgroundState extends State<ProgramFormMeshBackground> {
  late final DominantColorCubit _colorCubit;

  /// The last fully-loaded palette. Shown while a new cover's colors are
  /// being extracted so the mesh cross-fades instead of flashing to black.
  DominantColorLoaded? _lastLoaded;

  /// The last path we ran palette extraction for — cover changes flow in as
  /// a path event followed by a bytes event for the same image, and the
  /// second one must not trigger a redundant (expensive) pixel scan.
  String? _extractedPath;

  /// The mesh drift stays paused (a single static paint) until the page's
  /// entrance transition finishes, so the two animations never compete.
  bool _routeSettled = false;

  @override
  void initState() {
    super.initState();
    _colorCubit = DominantColorCubit();
    // The create flow's cover is prepared (palette pre-cached) before this
    // screen opens, so this emits synchronously and the very first frame is
    // already tinted — no work happens during the page transition.
    _extractFrom(context.read<BgImageCubit>().state);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final Animation<double>? routeAnimation =
          ModalRoute.of(context)?.animation;
      if (routeAnimation == null || routeAnimation.isCompleted) {
        setState(() => _routeSettled = true);
        return;
      }
      void onStatus(AnimationStatus status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          routeAnimation.removeStatusListener(onStatus);
          if (mounted) setState(() => _routeSettled = true);
        }
      }

      routeAnimation.addStatusListener(onStatus);
    });
  }

  @override
  void dispose() {
    _colorCubit.close();
    super.dispose();
  }

  void _extractFrom((String, Uint8List?) bgState) {
    final (String path, Uint8List? bytes) = bgState;
    // Library-cropped images carry the placeholder path and real bytes —
    // the bytes are the only source of truth for their colors.
    if (bytes != null && path == ATImgStrings.createShowPlaceholder) {
      _extractedPath = null;
      _colorCubit.extractColorFromBytes(bytes);
      return;
    }
    if (path == _extractedPath) return;
    _extractedPath = path;
    _colorCubit.extractColor(path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BgImageCubit, (String, Uint8List?)>(
      listener: (_, (String, Uint8List?) bgState) => _extractFrom(bgState),
      // The mesh lives in its own layer beneath the form. Keeping the form
      // subtree out of the mesh's changing widget tree preserves its state
      // (stream subscriptions, text fields, scroll positions) across
      // palette changes.
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          BlocBuilder<DominantColorCubit, DominantColorState>(
            bloc: _colorCubit,
            builder: (_, DominantColorState state) {
              if (state is DominantColorLoaded) {
                _lastLoaded = state;
              }
              return ATMeshGradientBackground(
                state: _lastLoaded ?? state,
                animate: _routeSettled,
                child: const SizedBox.expand(),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}
