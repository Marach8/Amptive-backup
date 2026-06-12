import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

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
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png';

      file = File(filePath);
      await file.writeAsBytes(bytes!);

      final ApiResponse<String> response =
          await authRepo.uploadImage(filePath: file.path);

      if(isClosed) return;

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
      emit(const FailureState<String>('Unable to upload image'));
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
      
      if(isClosed) return;
      
      await response.when(
        successful: (Successful<String> data) async {
          emit(SuccessState<String>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<String> error) {
          emit(FailureState<String>(error.error.message));
        },
      );
    } catch (e) {
      emit(const FailureState<String>('Unable to upload image'));
    }
  }
}
