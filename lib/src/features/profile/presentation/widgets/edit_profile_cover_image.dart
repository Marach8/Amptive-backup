import 'package:amptive/src/features/profile/data/models/profile_data.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/screens/image_cropper_screen.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:custom_image_crop/custom_image_crop.dart' show CustomCropShape;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart' show ImageSource, XFile;
import 'package:nested/nested.dart';
import '../../../../shared/custom_container_widget.dart';


typedef ProfileImages = ({
  String? coverImageUrl,
  String? profileImageUrl,
});

enum _UploadType{coverPhoto, profilePhoto}
class EditProfileCoverImage extends StatefulWidget {
  const EditProfileCoverImage({super.key});

  @override
  State<EditProfileCoverImage> createState() => _EditProfileCoverImageState();
}

class _EditProfileCoverImageState extends State<EditProfileCoverImage> {

  dynamic _coverImage, _profileImage;
  _UploadType? _uploadType;

  @override
  Widget build(BuildContext context) {
    final ProfileImages profileImages = context
      .select<LocalUserDataCubit, ProfileImages>(
        (LocalUserDataCubit cubit) => (
          coverImageUrl: cubit.currentUserData?.coverPhoto,
          profileImageUrl: cubit.currentUserData?.profilePhoto)
      );

      //Anytime the build is called by setState or select,
      //we set these things if they are null.
      _profileImage ??= profileImages.profileImageUrl;
      _coverImage ??= profileImages.coverImageUrl;

    return MultiBlocListener(
      listeners: <SingleChildWidget>[
        BlocListener<RemoteUserDataCubit, ATAppState<ProfileData>>(
          listener: (_, ATAppState<ProfileData> state){
            if(context.mounted && state is SuccessState<ProfileData>){

              ///After updating the cover photo in BE, update locally.
              ProfileData currentLocalData = context
                .read<LocalUserDataCubit>().currentUserData
                  ?? const ProfileData();
              
              
              if(_uploadType == _UploadType.profilePhoto){
                currentLocalData = currentLocalData.copyWith(
                  profilePhoto: state.newData?.profilePhoto,
                );
              }
              else if(_uploadType == _UploadType.coverPhoto){
                currentLocalData = currentLocalData.copyWith(
                  coverPhoto: state.newData?.coverPhoto,
                );
              }
              context.read<LocalUserDataCubit>().updateUserDataLocally(
                currentLocalData,
              );

              setState(() => _uploadType = null);
            }
            else if(context.mounted && state is FailureState<ProfileData>){
              //If we fail here, reset photo we are uploading and loadingState
              setState((){
                if(_uploadType == _UploadType.coverPhoto){
                  _coverImage = null;
                }
                else if (_uploadType == _UploadType.profilePhoto){
                  _profileImage = null;
                }
                _uploadType = null;
              });

              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure,
              );
            }
          },
        ),
        BlocListener<UploadImageCubit, ATAppState<String>>(
          listener: (_, ATAppState<String> state){
            if(context.mounted && state is SuccessState<String>){
              //After uploading the image, send the image URL to BE
              context.read<RemoteUserDataCubit>().updateRemoteUserProfile(
                userProfileData: ProfileData(
                  coverPhoto: _uploadType == _UploadType.coverPhoto ? state.newData : null,
                  profilePhoto: _uploadType == _UploadType.profilePhoto ? state.newData : null,
                ),
              );
            }
            else if(context.mounted && state is FailureState<String>){
              //If we fail here, reset photo we are uploading and loadingState
              setState((){
                if(_uploadType == _UploadType.coverPhoto){
                  _coverImage = null;
                }
                else if (_uploadType == _UploadType.profilePhoto){
                  _profileImage = null;
                }
                _uploadType = null;
              });

              showAppNotification2(
                context: context,
                text: state.message,
                type: NotificationType.failure,
              );
            }
          },
        )
      ],
      child: Container(
        height: 150,
        color: ATColors.white.withValues(alpha: 0.5),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                if(_uploadType != null) return;

                final ImageSource? selectedSrc =
                    await showImageSourceOptions(context);
                final XFile? selectedFile =
                    await ATHelperFuncs.pickImage(selectedSrc);
                if (context.mounted && selectedFile != null) {
                  final File file = File(selectedFile.path);
                  final MemoryImage? memImage = await context.pushNamed(
                    ATRoutes.imageCropperScreen,
                    extra: ImageCroppingParams(imageFile: file),
                  ) as MemoryImage?;
                  if(context.mounted && memImage != null){
                    setState((){
                      context.read<UploadImageCubit>().uploadBytesImage(
                        bytes: memImage.bytes);
                        _uploadType = _UploadType.coverPhoto;
                      _coverImage = memImage.bytes;
                    });
                  }
                }
              },
              child: _coverImage is Uint8List ? Image.memory(
                _coverImage!,
                fit: BoxFit.cover,
                height: 150,
                width: context.screenWidth,
              ) : _coverImage != null ? ATImgLoader(
                height: 150,
                boxFit: BoxFit.cover,
                width: context.screenWidth,
                imgPath: _coverImage!,
              ) : null,
            ),

            if(_uploadType == _UploadType.coverPhoto) Container(
              height: 150,
              width: context.screenWidth,
              alignment: Alignment.center,
              color: ATColors.black.withValues(alpha: 0.5),
              child: ATLoadingIndicator(
                size: 50, color: ATColors.white,)
            ),

            Positioned(
              bottom: -35,
              child: ATContainer(
                height: 70, width: 70, radius: 40,
                onTap:() async {
                  if(_uploadType != null) return;

                  final ImageSource? selectedSrc =
                      await showImageSourceOptions(context);
                  final XFile? selectedFile =
                      await ATHelperFuncs.pickImage(
                          selectedSrc);
                  if (context.mounted &&
                      selectedFile != null) {
                    final File file = File(selectedFile.path);
                    final MemoryImage? memImage =
                        await context.pushNamed(
                      ATRoutes.imageCropperScreen,
                      extra: ImageCroppingParams(
                        imageFile: file,
                        shape: CustomCropShape.Circle,
                      ),
                    ) as MemoryImage?;
          
                    if(context.mounted && memImage != null){
                      setState((){
                        context.read<UploadImageCubit>().uploadBytesImage(
                          bytes: memImage.bytes);
                          _uploadType = _UploadType.profilePhoto;
                        _profileImage = memImage.bytes;
                      });
                    }
                  }
                },
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 70, width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ATColors.black,
                          width: 3,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: _profileImage is Uint8List ? 
                        Image.memory(
                          _profileImage!,
                          fit: BoxFit.cover,
                          height: 70, width: 70,
                        ) :
                        ATImgLoader(
                          imgPath: _profileImage 
                            ?? ATImgStrings.noAvatarImage,
                          height: 70, width: 70,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 67,
                      width: 67,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ATColors.black.withValues(alpha: 0.5),
                      ),
                      child: _uploadType == _UploadType.profilePhoto ? 
                        ATLoadingIndicator(
                          size: 30, color: ATColors.white)
                        : const ATImgLoader(
                          imgPath: ATImgStrings.addImageIcon,
                          height: 30,
                          width: 30,
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
