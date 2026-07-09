import 'dart:typed_data';

import 'package:amptive/src/config/config_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BgImageCubit extends Cubit<(String, Uint8List?)> {
  BgImageCubit({this.initialImage}) : super((
    initialImage ?? ATImgStrings.createShowPlaceholder, null));
  final String? initialImage;

  void setBgImage(Uint8List imageBytes) => emit((state.$1, imageBytes));

  void setBgImageUrl(String imageUrl) => emit((imageUrl, null));

  void setBgImageAndUrl(String imageUrl, Uint8List imageBytes) => emit((imageUrl, imageBytes));

  void reset() => emit((ATImgStrings.createShowPlaceholder, null));
}
