import 'dart:async';
import 'dart:developer';

import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/screens/image_cropper_screen.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/app_bar_widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nested/nested.dart';

import '../../../../config/utils/font_sizes.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/user_profile_response_model.dart';
import 'package:amptive/src/features/profile/cubits/remote_user_data_cubit.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/app_notification_dialog.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/routing/route_strings.dart';

class AddProfilePictureScreen extends StatefulWidget {
  const AddProfilePictureScreen({super.key});

  @override
  State<AddProfilePictureScreen> createState() => _AddProfilePictureScreenState();
}

class _AddProfilePictureScreenState extends State<AddProfilePictureScreen> {
  Uint8List? _pickedImage;
  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<RemoteUserDataCubit>(
          create: (_) => RemoteUserDataCubit()),
        BlocProvider<UploadImageCubit>(
          create: (_) => UploadImageCubit())
      ],
      child: ATAnnotatedRegion(
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    ATStrings.addProfilePicture,
                    textAlign: TextAlign.start,
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ATStrings.useYourFavImage,
                    textAlign: TextAlign.start,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: ATColors.hexCDCDCD,
                    ),
                  ),
                  const SizedBox(height: 100),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 152,
                      width: 132,
                      child: Stack(
                        children: <Widget>[
                          if (_pickedImage == null)
                            const ATImgLoader(
                              imgPath: ATImgStrings.noAvatarImage,
                              height: 132,
                              width: 132,
                            )
                          else
                            Image.memory(
                              _pickedImage!,
                              height: 132,
                              width: 132,
                              fit: BoxFit.cover,
                            ),
                          Positioned(
                            bottom: 0, left: 44,
                            child: IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: _pickedImage != null
                                  ? ATColors.textRedColor
                                  : ATColors.hex307FE2,
                              ),
                              onPressed: () async {
                                if(_isLoadingNotifier.value) return;

                                if (_pickedImage == null) {
                                  final ImageSource? selectedSrc =
                                      await showImageSourceOptions(context);
                                  final XFile? selectedFile =
                                      await ATHelperFuncs.pickImage(selectedSrc);
                                  if (context.mounted && selectedFile != null) {
                                    final File file = File(selectedFile.path);
                                    final MemoryImage? memImage =
                                        await context.pushNamed(
                                      ATRoutes.imageCropperScreen,
                                      extra: ImageCroppingParams(
                                        imageFile: file,
                                        shape: CustomCropShape.Circle,
                                      ),
                                    ) as MemoryImage?;
                                    if (memImage != null) {
                                      setState(
                                          () => _pickedImage = memImage.bytes);
                                    }
                                  }
                                } else {
                                  setState(() => _pickedImage = null);
                                }
                              },
                              icon: Icon(
                                _pickedImage != null ? Icons.close : Icons.add,
                                color: ATColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),

            bottomSheet: MultiBlocListener(
              listeners: <SingleChildWidget>[
                BlocListener<RemoteUserDataCubit, ATAppState<UserProfileData>>(
                  listener: (_, ATAppState<UserProfileData> state)async{
                    if (state is SuccessState<UserProfileData>) {
                      _isLoadingNotifier.value = false;
                      context.read<LocalUserDataCubit>()
                        .updateUserDataLocally(state.newData ?? const UserProfileData());
                      if (context.mounted) {
                        context.pushNamed(ATRoutes.select5CommunitiesScreen);
                      }
                    } 
                    else if (state is FailureState<UserProfileData>) {
                      _isLoadingNotifier.value = false;
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                ),

                BlocListener<UploadImageCubit, ATAppState<String>>(
                  listener: (BuildContext ctx, ATAppState<String> state){
                    if(state is SuccessState<String>){
                      if(context.mounted){
                        ctx.read<RemoteUserDataCubit>()
                          .updateRemoteUserProfile(
                            userProfileData: UserProfileData(
                              pictureUrl: state.newData,
                            )
                          );
                      }
                    }
                    else if(state is FailureState<String>){
                      _isLoadingNotifier.value = false;
                      showAppNotification2(
                        context: context,
                        text: state.message,
                        type: NotificationType.failure,
                      );
                    }
                  },
                )
              ],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 54),
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isLoadingNotifier,
                  child: TextButton(
                    onPressed: () {
                      if(_isLoadingNotifier.value) return;
                      context.pushNamed(ATRoutes.select5CommunitiesScreen);
                    },
                    child: Text(
                      ATStrings.skipForNow,
                      textAlign: TextAlign.center,
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  builder: (BuildContext ctx, bool isLoading, Widget? child) {
                    return Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        child!,
                        ATPlainElevatedBtn(
                          btnTitle: ATStrings.next,
                          isLoading: isLoading,
                          onPressed: _pickedImage != null
                            ? () {
                              //Show loading indicator on this button.
                              _isLoadingNotifier.value = true;
                              //Start the first api call to upload image.
                              ctx.read<UploadImageCubit>()
                                .uploadBytesImage(bytes: _pickedImage!);
                            } : null,
                        )
                      ]
                    );
                  }
                ),
              ),
            )
          ),
        )
      ),
    );
  }
}
