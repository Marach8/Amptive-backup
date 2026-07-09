import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:cached_network_image/cached_network_image.dart';

abstract class DominantColorState {}

class DominantColorInitial extends DominantColorState {}

class DominantColorLoading extends DominantColorState {}

class DominantColorLoaded extends DominantColorState {
  final Color dominantColor;
  final Color vibrantColor;
  final Color mutedColor;
  final Color darkVibrantColor;

  DominantColorLoaded({
    required this.dominantColor,
    required this.vibrantColor,
    required this.mutedColor,
    required this.darkVibrantColor,
  });
}

class DominantColorError extends DominantColorState {
  final Color defaultColor;
  DominantColorError(this.defaultColor);
}

class DominantColorCubit extends Cubit<DominantColorState> {
  DominantColorCubit() : super(DominantColorInitial());

  /// Session-long palette cache. Extracting a palette means decoding and
  /// scanning the image's pixels — expensive enough to jank a page
  /// transition — so each path is only ever analyzed once.
  static final Map<String, DominantColorLoaded> _paletteCache =
      <String, DominantColorLoaded>{};

  void reset() => emit(DominantColorInitial());

  /// Whether [imagePath]'s palette is already in the session cache, meaning
  /// [extractColor] for it will emit synchronously with zero pixel work.
  static bool isPaletteWarm(String imagePath) =>
      _paletteCache.containsKey(imagePath);

  /// Computes and caches [imagePath]'s palette ahead of time (e.g. before
  /// navigating to a screen that will need it), so the screen itself never
  /// pays the extraction cost.
  static Future<void> warmPalette(String imagePath) async {
    if (_paletteCache.containsKey(imagePath)) return;
    final DominantColorCubit cubit = DominantColorCubit();
    try {
      await cubit.extractColor(imagePath);
    } finally {
      await cubit.close();
    }
  }

  Future<void> extractColorFromBytes(
    Uint8List bytes, {
    Color defaultColor = const Color(0xFF1C1C1E),
  }) async {
    emit(DominantColorLoading());
    try {
      final ImageProvider imageProvider = MemoryImage(bytes);
      await _extractFromProvider(imageProvider, defaultColor);
    } catch (e) {
      emit(DominantColorError(defaultColor));
    }
  }

  Future<void> extractColor(
    String imagePath, {
    Color defaultColor = const Color(0xFF1C1C1E),
  }) async {
    final DominantColorLoaded? cached = _paletteCache[imagePath];
    if (cached != null) {
      emit(cached);
      return;
    }
    emit(DominantColorLoading());
    try {
      final bool isNetworkImage = imagePath.startsWith('http');
      final ImageProvider imageProvider = isNetworkImage
          ? CachedNetworkImageProvider(imagePath) as ImageProvider
          : AssetImage(imagePath);

      await _extractFromProvider(imageProvider, defaultColor,
          cacheKey: imagePath);
    } catch (e) {
      emit(DominantColorError(defaultColor));
    }
  }

  Future<void> _extractFromProvider(
      ImageProvider imageProvider, Color defaultColor,
      {String? cacheKey}) async {
    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        imageProvider,
        // Downscale before scanning pixels — palettes don't need full
        // resolution, and this keeps extraction cheap enough not to jank.
        size: const Size(112, 112),
        maximumColorCount: 20,
      );

      final Color rawDominant =
          paletteGenerator.dominantColor?.color ?? defaultColor;

      final HSLColor dominantHsl = HSLColor.fromColor(rawDominant);

      // 1. Base Canvas Color
      // We ensure the dominant color isn't pitch black so the mesh is visible,
      // but keep it deeply rich and clamped so it doesn't wash out the UI.
      final double darknessLift = dominantHsl.lightness < 0.12 ? 0.08 : 0.0;
      final Color dominantColor = dominantHsl
          .withLightness(
              (dominantHsl.lightness + darknessLift).clamp(0.15, 0.4))
          .toColor();

      // 2. The Glow Ribbon Color
      // IGNORE the palette generator's "vibrant" color, which often picks up
      // stray red/purple pixel artifacts from dark images.
      // Instead, we mathematically derive a perfectly analogous glow from the TRUE dominant color.
      // This guarantees the ribbons will ALWAYS match the cover art perfectly.
      final double glowHue =
          (dominantHsl.hue + 12.0) % 360.0; // Subtle 12-degree analogous shift
      final double glowSaturation = (dominantHsl.saturation + 0.2)
          .clamp(0.3, 0.75); // Vivid, but not neon
      final double glowLightness =
          (dominantHsl.lightness + 0.25 + darknessLift).clamp(0.35, 0.6);

      final Color vibrantColor = HSLColor.fromAHSL(
        1.0,
        glowHue,
        glowSaturation,
        glowLightness,
      ).toColor();

      // We no longer use muted and darkVibrant in the 2-color mesh,
      // but we satisfy the state requirement by passing the dominant color.
      final Color mutedColor = dominantColor;
      final Color darkVibrantColor = dominantColor;

      final DominantColorLoaded loaded = DominantColorLoaded(
        dominantColor: dominantColor,
        vibrantColor: vibrantColor,
        mutedColor: mutedColor,
        darkVibrantColor: darkVibrantColor,
      );
      if (cacheKey != null) {
        _paletteCache[cacheKey] = loaded;
      }
      emit(loaded);
    } catch (e) {
      emit(DominantColorError(defaultColor));
    }
  }
}
