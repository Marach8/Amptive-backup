import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
              SineWaveImplementer() //_isLoading ? const LoadingAccount() : _addPicture(),
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
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

              // return SlideTransition(
              //   position: TweenSequence([
              //     TweenSequenceItem(
              //         tween: Tween<Offset>(
              //           begin: const Offset(0.0, 1.0),
              //           end: const Offset(0.0, 0.0),
              //         ),
              //         weight: 1),
              //
              //     TweenSequenceItem(
              //         tween: Tween<Offset>(
              //           begin: const Offset(0.0, 0.0),
              //           end: const Offset(0.0, -1.0),
              //         ),
              //         weight: 1)
              //   ]).animate(animation),
              //   child: child,
              // );
            },
            // layoutBuilder:
            //     (Widget? currentChild, List<Widget> previousChildren) {
            //   return currentChild!;
            // },
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

class SineWaveImplementer extends StatefulWidget {
  const SineWaveImplementer({Key? key}) : super(key: key);

  @override
  State<SineWaveImplementer> createState() => _SineWaveImplementerState();
}

class _SineWaveImplementerState extends State<SineWaveImplementer>
    with SingleTickerProviderStateMixin {
  late AnimationController _sineController;
  late Animation _sineAnimation;

  @override
  void initState() {
    _sineController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _sineAnimation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _sineController, curve: Curves.linear));

    _sineController.forward(from: 0);
    _sineController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AmpColors.white,
      body: AnimatedBuilder(
        builder: (context, child) {
          return CustomPaint(
            painter: SinePainter(_sineController),
            size: const Size(double.infinity, 200),
            child: Container(),
          );
        },
        animation: _sineAnimation,
      ),
    );
  }
}

class SinePainter extends CustomPainter {
  final AnimationController controller;

  SinePainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = AmpColors.brandBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    double width = size.width;
    double height = size.height;
    double centerY = height / 2;

    var originalArray = [20, 80, 120, 160, 250, 20, 80, 120, 160, 250]; // Define 5 amplitude values
    List<int> amplitudeValues = shuffleArray(originalArray);

    final index = (controller.value * (amplitudeValues.length - 1)).round();
    var temp = amplitudeValues[index];

    double period = width / 1.75; // Adjust the period of the sine wave
    double amplitude = ( height / temp); // Adjust the amplitude of the sine wave

    Path path = Path();
    path.moveTo(0, centerY);


    for (double x = 0; x <= width; x += 4) {
      double y =
          centerY + sin((x / period) * 2 * pi) * -amplitude ;
      path.lineTo(x, y);
    }

    // for (int i = 1; i <= pointsNumber; i++) {
    //   path.lineTo(i * size.width / pointsNumber,
    //       (size.height / 2) + sin(controller.value + i * pi / 15) * 20);
    // }

    // path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }


  List<int> shuffleArray(List<int> array) {
    Random random = Random();
    for (int i = array.length - 1; i > 0; i--) {
      int j = random.nextInt(i + 1);
      int temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }
    return array;
  }
}
