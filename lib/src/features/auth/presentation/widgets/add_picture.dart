import 'dart:io';
import 'dart:typed_data';
import 'package:amptive/src/bloc/authentication/general/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/general/auth_states.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/shared/image_source_selection_dialog.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../bloc/authentication/general/auth_events.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/dialogs/app_notification_dialog.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';
import '../../../../config/routing/route_strings.dart';

class AddPictureWidget extends StatefulWidget {
  const AddPictureWidget({super.key});

  @override
  State<AddPictureWidget> createState() => _AddPictureWidgetState();
}

class _AddPictureWidgetState extends State<AddPictureWidget> {
  Uint8List? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UploadImageCubit>(
      create: (_) => UploadImageCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            ATStrings.addProfilePicture,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: ATFontWeights.w600,
                ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            ATStrings.useYOurFavImage,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ATColors.hexCDCDCD,
                ),
          ),
      
          const SizedBox(height: 100),
      
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 153,
              width: 132,
              child: Stack(
                children: <Widget>[
                  if(_pickedImage == null) const ATImgLoader(
                    imgPath: ATImgStrings.noAvatarImage,
                    height: 132, width: 132,
                  ) else Image.memory(
                    _pickedImage!,
                    height: 132, width: 132,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 111,
                    left: 49,
                    child: CircleAvatar(
                      backgroundColor: _pickedImage != null
                          ? ATColors.textRedColor
                          : ATColors.hex307FE2,
                      child: SizedBox(
                        child: IconButton(
                          style: IconButton.styleFrom(),
                          onPressed: () async{
                            if(_pickedImage == null){
                              final ImageSource? selectedSrc = await showImageSourceOptions(context);
                              final XFile? selectedFile = await ATHelperFuncs.pickImage(selectedSrc);
                              if(context.mounted && selectedFile != null){
                                final File file = File(selectedFile.path);
                                final MemoryImage? imageData = await context.pushNamed(
                                  ATRoutes.rectImageCropperScreen,
                                  extra: (file, null, CustomCropShape.Circle),
                                ) as MemoryImage?;
                                if(imageData != null){
                                  setState(() => _pickedImage = imageData.bytes);
                                }
                              }
                            }
                            else {setState(() => _pickedImage = null);}
                          },
                          icon: SizedBox(
                            width: 41.25,
                            height: 41.25,
                            child: Icon(
                              _pickedImage != null ? Icons.close : Icons.add,
                              color: ATColors.white,
                              opticalSize: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(vertical: 7),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(ATRoutes.select5CommunitiesScreen);
              },
              child: Text(
                ATStrings.skipForNow,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: ATFontWeights.w600,
                    ),
              ),
            ),
          ),
          BlocConsumer<UploadImageCubit, ATAppState<String>>(
            listener: (_, ATAppState<String> state)async{
              if(state is SuccessState<String>){
                await context.read<LocalUserDataCubit>().updateUserDataLocally(
                  CachedUserData(pictureUrl: state.newData,)
                );
                if(context.mounted){
                  context.pushNamed(ATRoutes.select5CommunitiesScreen);
                }
              }
              else if(state is FailureState<String>){
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
              }
            },
            builder: (BuildContext context, ATAppState<String> state) {
              return ATPlainElevatedBtn(
                btnTitle: ATStrings.next,
                isLoading: state is LoadingState<String>,
                onPressed: _pickedImage != null ? (){
                  context.read<UploadImageCubit>()
                    .uploadBytesImage(bytes: _pickedImage!); 
                } : null,
              );
            }
          )
        ],
      ),
    );
  }
}
