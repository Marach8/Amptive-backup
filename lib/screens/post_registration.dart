import 'dart:async';
import 'dart:io';

import 'package:amptive/utils/common_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../routers/amptive_routes.dart';
import '../utils/utils.dart';

class PostRegistrationScreen extends StatefulWidget {
  const PostRegistrationScreen({super.key});

  @override
  State<PostRegistrationScreen> createState() => _PostRegistrationScreenState();
}

class _PostRegistrationScreenState extends State<PostRegistrationScreen> {
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();
  late File _image;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () => setState(() {
        _isLoading = false;
      }),
    );
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }

    // var croppedFile = await _cropImage(_image);

    // setState(() {
    //   _image = croppedFile!;
    // });

    MemoryImage? img = await context.pushNamed(AmptiveRoutes.cropImage, extra: _image);


  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  // Function to crop the selected image using the image_cropper package
  Future<File?> _cropImage(File pickedFile) async {
    final croppedFile = await ImageCropper().cropImage(
      cropStyle: CropStyle.circle,
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
          doneButtonTitle: "done",
          cancelButtonTitle: "cancel",
        ),
      ],
    );

    // Returning the edited/cropped image if available, otherwise the original image
    if (croppedFile != null) {
      return File(croppedFile.path);
    } else {
      return File(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AmpColors.brandBlack,
      appBar: BuildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.w),
        child: _isLoading ? const LoadingAccount() : _addPicture(),
      ),
    ));
  }

  Widget _addPicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add a profile picture",
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
            color: AmpColors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Text(
          "Use one of your favourite image or selfie",
          textAlign: TextAlign.start,
          style: GoogleFonts.inter(
            color: const Color(0xFFCDCDCD),
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 79.h, left: 105.w),
          height: 153.h,
          width: 132.h,
          child: Stack(
            children: [
              SizedBox(
                  height: 132.h,
                  width: 132.w,
                  child: Image.asset(
                    "assets/no_avatar_image.png",
                    height: 110.h,
                    width: 84.w,
                    fit: BoxFit.contain,
                  )),
              Positioned(
                top: 111.h,
                left: 45.w,
                child: SizedBox(
                  width: 41.25.w,
                  height: 41.25.h,
                  child: RawMaterialButton(
                    onPressed: () {
                      showOptions();
                    },
                    elevation: 2.0,
                    fillColor: AmpColors.brandBlue,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.add,
                      size: 35.0.w,
                      color: AmpColors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 1.h,
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.h),
          padding: EdgeInsets.symmetric(vertical: 7.h),
          alignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              context.pushNamed(AmptiveRoutes.preference);
            },
            child: Text(
              "Skip for now",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AmpColors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Container(
          width: 350.w,
          height: 50.w,
          margin: EdgeInsets.only(bottom: 29.h),
          child: ElevatedButton(
            onPressed: () {},
            style:
                ElevatedButton.styleFrom(backgroundColor: AmpColors.brandBlue),
            child: Text(
              "Next",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                  color: AmpColors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingAccount extends StatelessWidget {
  const LoadingAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            "We are creating your account",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AmpColors.white,
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 17.h),
          width: 32.w,
          height: 32.h,
          child: CircularProgressIndicator(
            color: AmpColors.brandBlue,
            backgroundColor: AmpColors.brandBlue.withOpacity(0.5),
            strokeWidth: 5.w,
          ),
        )
      ],
    );
  }
}
