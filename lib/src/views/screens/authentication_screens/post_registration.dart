import 'dart:async';
import 'dart:io';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../utils/constants/strings/route_strings.dart';


class PostRegistrationScreen extends StatefulWidget {
  const PostRegistrationScreen({super.key});

  @override
  State<PostRegistrationScreen> createState() => _PostRegistrationScreenState();
}

class _PostRegistrationScreenState extends State<PostRegistrationScreen> {
  bool _isLoading = true;
  bool _isProfilePicAdded = false;
  final ImagePicker _picker = ImagePicker();
  late MemoryImage _image;

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 15),
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
            child: Text(
              'Photo Gallery',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AmpColors.brandBlue,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
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
              'Camera',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AmpColors.brandBlue,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null && mounted) {
      File image = File(pickedFile.path);
      MemoryImage? img =
          await context.pushNamed(AmptiveRoutes.cropImage, extra: image);

      setState(() {
        _image = img!;
        _isProfilePicAdded = true;
      });
    }

    // var croppedFile = await _cropImage(_image);
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AmpColors.brandBlack,
      body: Padding(
          padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.w),
          child:
              _isLoading ? const LoadingAccount() : _addPicture(),
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
                child: CircleAvatar(
                  child: SizedBox(
                    height: 132.h,
                    width: 132.w,
                    child: _isProfilePicAdded
                        ? Image.memory(
                            _image.bytes,
                            height: 110.h,
                            width: 84.w,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            "assets/no_avatar_image.png",
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
                  backgroundColor: _isProfilePicAdded
                      ? AmpColors.textRed
                      : AmpColors.brandBlue,
                  child: SizedBox(
                    child: IconButton(
                      style: IconButton.styleFrom(),
                      onPressed: () {
                        if (_isProfilePicAdded) {
                          setState(() {
                            _isProfilePicAdded = false;
                          });
                        } else {
                          showOptions();
                        }
                      },
                      icon: SizedBox(
                        width: 41.25.w,
                        height: 41.25.h,
                        child: Icon(
                          _isProfilePicAdded ? Icons.close : Icons.add,
                          color: AmpColors.white,
                          opticalSize: 50.h,
                        ),
                      ),
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

class LoadingAccount extends StatefulWidget {
  const LoadingAccount({
    super.key,
  });

  @override
  State<LoadingAccount> createState() => _LoadingAccountState();
}

class _LoadingAccountState extends State<LoadingAccount> {
  late String text;

  var textList = [
    "We are creating your account",
    "Join or create live audio events",
    "Subscribe and support creators"
  ];

  int textListCounter = 1;

  @override
  void initState() {
    super.initState();
    text = textList[0];

    Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        setState(() {
          text = textList[textListCounter % textList.length];
          textListCounter++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 270.h),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final inAnimation = TweenSequence([
                  TweenSequenceItem(
                      tween: ConstantTween(const Offset(0.0, 1.0)), weight: 2),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0),
                      ),
                      weight: 1),
                ]).animate(animation);

                final outAnimation = TweenSequence([
                  TweenSequenceItem(
                      tween: ConstantTween(const Offset(0.0, 1.0)), weight: 1),
                  TweenSequenceItem(
                      tween: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0),
                      ),
                      weight: 1),
                ]).animate(animation);

                if (child.key == ValueKey(text)) {
                  return ClipRect(
                    child: SlideTransition(
                      position: inAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                } else {
                  return ClipRect(
                    child: SlideTransition(
                      position: outAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: child,
                      ),
                    ),
                  );
                }

              },

              child: Text(text,
                  key: ValueKey<String>(text),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AmpColors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  )),
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




