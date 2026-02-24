import 'dart:typed_data';

import 'package:amptive/src/config/config_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BgImageCubit extends Cubit<(String, Uint8List?)>{
  BgImageCubit(): super((ATImgStrings.createShowPlaceholder, null));

  void setBgImage(Uint8List imageBytes) => emit((state.$1, imageBytes));

  void reset() => emit((ATImgStrings.createShowPlaceholder, null));
}