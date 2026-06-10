import 'dart:io';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/screens/image_cropper_screen.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart' show ImageSource, XFile;

class EditProfileBgImage extends StatelessWidget {
  const EditProfileBgImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RemoteUserDataCubit>(
      create: (_) => RemoteUserDataCubit(),
      child: Builder(
        builder: (BuildContext context) {
          return BlocConsumer<RemoteUserDataCubit, ATAppState<UserProfileData>>(
            listener: (BuildContext context, ATAppState<UserProfileData> state) {
              if (state is FailureState<UserProfileData>) {
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure
                );
              }
              if (state is SuccessState<UserData>) {
                // final UserProfileData? currentUser =
                //     context.read<LocalUserDataCubit>().currentUserData;
                // if (currentUser != null && state.newData != null) {
                //   context.read<LocalUserDataCubit>().updateUserDataLocally(
                //         currentUser.copyWith(
                //             pictureUrl: "${state.newData!.profilePicture}"),
                //       );
                // }
              }
            },
            builder: (BuildContext context, ATAppState<UserProfileData> state) {
              return BlocBuilder<LocalUserDataCubit,
                  ATAppState<UserProfileData>>(
                builder: (BuildContext context,
                    ATAppState<UserProfileData> localState) {
                  final UserProfileData? userData =
                      context.read<LocalUserDataCubit>().currentUserData;
                  final bool isLoading = state is LoadingState<UserData>;
                  final String? profileImageUrl = userData?.pictureUrl;

                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () async {
                                final ImageSource? selectedSrc =
                                    await showImageSourceOptions(context);
                                final XFile? selectedFile =
                                    await ATHelperFuncs.pickImage(selectedSrc);
                                if (context.mounted && selectedFile != null) {
                                  final File file = File(selectedFile.path);
                                  await context.pushNamed(
                                    ATRoutes.imageCropperScreen,
                                    extra: ImageCroppingParams(imageFile: file),
                                  );
                                }
                              },
                        child: ATImgLoader(
                          height: 150,
                          boxFit: BoxFit.cover,
                          width: context.screenWidth,
                          imgPath: ATImgStrings.weCanDoHardThingsBgImage,
                        ),
                      ),
                      Positioned(
                        bottom: -35,
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          alignment: Alignment.center,
                          children: <Widget>[
                            ATCircularImage(
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      final ImageSource? selectedSrc =
                                          await showImageSourceOptions(context);
                                      final XFile? selectedFile =
                                          await ATHelperFuncs.pickImage(
                                              selectedSrc);
                                      if (context.mounted &&
                                          selectedFile != null) {
                                        final File file =
                                            File(selectedFile.path);
                                        final MemoryImage? imageData =
                                            await context.pushNamed(
                                          ATRoutes.imageCropperScreen,
                                          extra: ImageCroppingParams(imageFile: file),
                                        ) as MemoryImage?;

                                        if (context.mounted &&
                                            imageData != null) {
                                          // context
                                          //     .read<RemoteUserDataCubit>()
                                          //     .updateRemoteUserProfile(
                                          //         imageUrl: imageData.bytes);
                                        }
                                      }
                                    },
                              diameter: 70,
                              addBorder: true,
                              borderColor: ATColors.black,
                              borderWidth: 3,
                              imagePath: profileImageUrl ?? ATImgStrings.jpeg2,
                            ),
                            IgnorePointer(
                              child: Container(
                                height: 67,
                                width: 67,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ATColors.black.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            IgnorePointer(
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.white))
                                  : const ATImgLoader(
                                      imgPath: ATImgStrings.addImageIcon,
                                      height: 30,
                                      width: 30,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}




// class EditProfileBgImage extends StatelessWidget {
//   const EditProfileBgImage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Uint8List? imageBytes;
//     return StatefulBuilder(
//       builder: (BuildContext context, StateSetter setter) {
//         return Stack(
//           alignment: Alignment.center,
//           clipBehavior: Clip.none,
//           children: <Widget>[
//             GestureDetector(
//               onTap: () async{
//                 final ImageSource? selectedSrc = await showImageSourceOptions(context);
//                 final XFile? selectedFile = await ATHelperFuncs.pickImage(selectedSrc);
//                 if(context.mounted && selectedFile != null){
//                   final File file = File(selectedFile.path);
//                   final MemoryImage? imageData = await context.pushNamed(
//                     ATRoutes.rectImageCropperScreen,
//                     extra: (file, null, null,),
//                   ) as MemoryImage?;
//                   if(imageData != null){
//                     setter(() => imageBytes = imageData.bytes);
//                   }
//                 }
//               },
//               child: imageBytes == null ? ATImgLoader(
//                 height: 150, boxFit: BoxFit.cover,
//                 width: context.screenWidth,
//                 imgPath: ATImgStrings.weCanDoHardThingsBgImage
//               ) : Image.memory(
//                 imageBytes!,
//                 //frameBuilder: ,
//                 height: 150, fit: BoxFit.cover,
//                 width: context.screenWidth,
//               )
//             ),
//             Positioned(
//               bottom: -35,
//               child: Stack(
//                 clipBehavior: Clip.hardEdge,
//                 alignment: Alignment.center,
//                 children: <Widget>[
//                   ATCircularImage(
//                     onTap: () => context.pushNamed(
//                       ATRoutes.PROFILE_PIC_SCREEN,
//                       extra: ATImgStrings.jpeg2
//                     ),
//                     diameter: 70, addBorder: true,
//                     borderColor: ATColors.black,
//                     borderWidth: 3,
//                     imagePath: ATImgStrings.jpeg2
//                   ),
//                   Container(
//                     height: 67, width: 67,
//                     color: ATColors.black.withValues(alpha: 0.5),
//                   ),
//                   const ATImgLoader(
//                     imgPath: ATImgStrings.addImageIcon,
//                     height: 30, width: 30,
//                   )
//                 ],
//               )
//             ),
//           ],
//         );
//       }
//     );
//   }
// }
