import 'dart:io';
import 'dart:typed_data';
import 'package:amptive/src/bloc/authentication/general/auth_bloc.dart';
import 'package:amptive/src/bloc/authentication/general/auth_states.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../bloc/authentication/general/auth_events.dart';
import '../../../config/utils/colors.dart';
import '../../../config/utils/font_weights.dart';
import '../../../config/utils/image_strings.dart';
import '../../../config/utils/other_strings.dart';
import '../../../config/routing/route_strings.dart';

class AddPictureWidget extends StatefulWidget {
  const AddPictureWidget({super.key});

  @override
  State<AddPictureWidget> createState() => _AddPictureWidgetState();
}

class _AddPictureWidgetState extends State<AddPictureWidget> {
  bool _isProfilePictureAdded = false;
  final ImagePicker _picker = ImagePicker();
  late Uint8List _image;

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    await handlePickedFile(pickedFile);
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    await handlePickedFile(pickedFile);
  }

  Future<void> handlePickedFile(XFile? pickedFile) async {
    if (pickedFile != null && mounted) {
      File image = File(pickedFile.path);
      MemoryImage? img =
          await context.pushNamed(ATRoutes.CIRCLE_IMG_CROPPER_SCREEN, extra: image);

      if (img != null && mounted) {
        context
            .read<AmptiveAuthBloc>()
            .add(ProfilePictureAddedEvent(image: img));
      }
    }
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              ATStrings.PHOTO_GALLERY,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: ATColors.hex307FE2,
                    fontWeight: ATFontWeights.w600,
                  ),
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              ATStrings.CAMERA,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: ATColors.hex307FE2,
                    fontWeight: ATFontWeights.w600,
                  ),
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AmptiveAuthBloc, AmptiveAuthState>(
      listener: (BuildContext context, AmptiveAuthState state) {
        if (state is AddProfilePictureState) {
          showOptions();
        } else if (state is ProfilePictureAddedState) {
          if (state.image != null) {
            _image = state.image!;
            _isProfilePictureAdded = true;
          } else {
            _isProfilePictureAdded = false;
          }
        }
      },
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
            height: 4.h,
          ),
          Text(
            ATStrings.useYOurFavImage,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: ATColors.hexCDCDCD,
                ),
          ),
          BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
              builder: (BuildContext context, AmptiveAuthState state) {
            return Container(
              margin: EdgeInsets.only(top: 79.h, left: 105.w),
              height: 153.h,
              width: 132.h,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 132.h,
                    width: 132.w,
                    child: CircleAvatar(
                      child: SizedBox(
                        height: 132.h,
                        width: 132.w,
                        child: _isProfilePictureAdded
                            ? Image.memory(
                                _image,
                                height: 110.h,
                                width: 84.w,
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                ATImgStrings.noAvatarImage,
                                height: 110.h,
                                width: 84.w,
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 111.h,
                    left: 49.w,
                    child: CircleAvatar(
                      backgroundColor: _isProfilePictureAdded
                          ? ATColors.textRedColor
                          : ATColors.hex307FE2,
                      child: SizedBox(
                        child: IconButton(
                          style: IconButton.styleFrom(),
                          onPressed: () {
                            context.read<AmptiveAuthBloc>().add(
                                AddProfilePictureEvent(
                                    cancel: _isProfilePictureAdded));
                          },
                          icon: SizedBox(
                            width: 41.25.w,
                            height: 41.25.h,
                            child: Icon(
                              _isProfilePictureAdded ? Icons.close : Icons.add,
                              color: ATColors.white,
                              opticalSize: 50.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          Expanded(
            child: SizedBox(
              height: 1.h,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(vertical: 7.h),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                context.pushNamed(ATRoutes.SELECT_5_COMMUNITIES_SCREEN);
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
          BlocBuilder<AmptiveAuthBloc, AmptiveAuthState>(
              builder: (BuildContext context, AmptiveAuthState state) {
            return ATPlainElevatedBtn(
              btnTitle: ATStrings.NEXT,
              onPressed:
                  state is ProfilePictureAddedState && state.image != null
                      ? () => context.pushNamed(ATRoutes.SELECT_5_COMMUNITIES_SCREEN)
                      : null,
                      
            );
          }),
        ],
      ),
    );
  }
}
