import 'dart:typed_data';

import 'package:amptive/src/config/config_export.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BgImageBloc extends Cubit<(String, Uint8List?)>{
  BgImageBloc(): super((ATImgStrings.CREATE_SHOW_PLACEHOLDER, null));

  void setBgImage(Uint8List imageBytes) => emit((state.$1, imageBytes));

  void reset() => emit((ATImgStrings.CREATE_SHOW_PLACEHOLDER, null));
}