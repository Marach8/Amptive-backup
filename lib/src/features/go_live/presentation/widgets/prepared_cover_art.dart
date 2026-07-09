import 'dart:async';
import 'dart:io';

import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/cover_image_picker_sheet.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Pre-picks the random cover art for the next create-show/event form and
/// warms everything it needs — the image file and its color palette — before
/// the user ever opens the form. The form then renders fully dressed on its
/// first frame instead of assembling itself in front of the user.
class PreparedCoverArt {
  PreparedCoverArt._();

  static String? _path;
  static Uint8List? _bytes;
  static Future<void>? _inFlight;

  /// The cover the next create form should open with. Falls back to picking
  /// one on the spot if nothing was prepared yet.
  static String get path => _path ??= randomCoverTemplateImage();

  /// The cover's raw bytes, if the warm-up finished. May be null in the rare
  /// case the form opens before preparation completes.
  static Uint8List? get bytes => _bytes;

  /// Marks the current cover as used and immediately starts preparing a
  /// fresh one for the next visit.
  static void consumeAndPrepareNext() {
    _path = null;
    _bytes = null;
    unawaited(prepareNext());
  }

  /// Picks the next random cover and warms its bytes + palette. Safe to call
  /// repeatedly; concurrent calls share the same work.
  static Future<void> prepareNext() {
    if (_path != null && _bytes != null) return Future<void>.value();
    return _inFlight ??= _prepare().whenComplete(() => _inFlight = null);
  }

  static Future<void> _prepare() async {
    final String coverPath = _path ?? randomCoverTemplateImage();
    _path = coverPath;
    try {
      _bytes = await loadCoverArtBytes(coverPath);
      await DominantColorCubit.warmPalette(coverPath);
    } catch (_) {
      // Warm-up is best-effort; the form falls back to loading on demand.
    }
  }
}

/// Reads cover bytes from the on-disk image cache (downloading once if
/// needed) for network covers, or from the asset bundle for local ones.
Future<Uint8List> loadCoverArtBytes(String imagePath) async {
  if (imagePath.startsWith('http')) {
    final File file = await DefaultCacheManager().getSingleFile(imagePath);
    return file.readAsBytes();
  }
  final ByteData data = await rootBundle.load(imagePath);
  return data.buffer.asUint8List();
}
