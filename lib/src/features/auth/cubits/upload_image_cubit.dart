import 'package:flutter/foundation.dart' show compute;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Runs in a background isolate (via [compute]). Resizes to a max 1080px and
/// re-encodes as JPEG q80 — turning a multi-MB PNG cover into a ~100-200KB
/// file so the upload is fast. Returns the original bytes if decode fails.
Uint8List compressCoverBytes(Uint8List bytes) {
  try {
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) return bytes;
    final img.Image sized =
        (decoded.width > 1080 || decoded.height > 1080)
            ? img.copyResize(
                decoded,
                width: decoded.width >= decoded.height ? 1080 : null,
                height: decoded.height > decoded.width ? 1080 : null,
              )
            : decoded;
    return img.encodeJpg(sized, quality: 80);
  } catch (_) {
    return bytes;
  }
}

class UploadImageCubit extends Cubit<ATAppState<String>> {
  UploadImageCubit({
    AuthRepo? mockAuthRepo,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<String>());

  final AuthRepo authRepo;

  Future<void> uploadBytesImage({
    required Uint8List? bytes,
    String? purpose,
    String? existingImageUrl,
  }) async {
    if (bytes == null && existingImageUrl != null){
      emit(SuccessState<String>(newData: existingImageUrl));
      return;
    }

    emit(const LoadingState<String>());

    File? file;

    try {
      // Compress the cover to a small JPEG off the main thread — a big PNG is
      // what makes the upload (and the wait before the success screen) slow.
      final Uint8List uploadBytes =
          await compute(compressCoverBytes, bytes!);

      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/cover_${DateTime.now().millisecondsSinceEpoch}.jpg';

      file = File(filePath);
      await file.writeAsBytes(uploadBytes);

      final ApiResponse<String> response =
          await authRepo.uploadImage(filePath: file.path);

      await response.when(
        successful: (Successful<String> data) async {
          if (await file?.exists() ?? false) {
            await file!.delete();
          }

          emit(SuccessState<String>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<String> error) {
          emit(FailureState<String>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<String>('Unable to upload image: $e'));
    }
  }

  Future<void> uploadFileImage({
    required String filepath,
    String? purpose,
  }) async {
    emit(const LoadingState<String>());

    try {
      final ApiResponse<String> response =
          await authRepo.uploadImage(filePath: filepath);

      await response.when(
        successful: (Successful<String> data) async {
          emit(SuccessState<String>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<String> error) {
          emit(FailureState<String>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<String>('Unable to upload image: $e'));
    }
  }
}
