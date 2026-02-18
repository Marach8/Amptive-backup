import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo.dart';
import 'package:amptive/src/features/auth/data/repository/auth_repo_impl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class AddProfilePicCubit extends Cubit<ATAppState<dynamic>> {
  AddProfilePicCubit({
    AuthRepo? mockAuthRepo,
  })  : authRepo = mockAuthRepo ?? AuthRepoImpl(),
        super(const InitialState<dynamic>());

  final AuthRepo authRepo;

  Future<void> uploadImage({required Uint8List bytes}) async {
    emit(const LoadingState<dynamic>());

    File? file;

    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath =
          '${tempDir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png';

      file = File(filePath);
      await file.writeAsBytes(bytes);

      final ApiResponse<dynamic> response =
          await authRepo.uploadImage(filePath: file.path);

      await response.when(
        successful: (Successful<dynamic> data) async {
          if (await file?.exists() ?? false) {
            await file!.delete();
          }

          emit(SuccessState<dynamic>(newData: data.data));
        },
        unSuccessful: (Unsuccessful<dynamic> error) {
          emit(FailureState<dynamic>(error.error.message));
        },
      );
    } catch (e) {
      emit(FailureState<dynamic>('Unable to upload image: $e'));
    }
  }
}
