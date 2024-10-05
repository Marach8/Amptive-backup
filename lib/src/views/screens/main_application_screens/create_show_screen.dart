import 'dart:io';
import 'dart:ui';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants/font_weights.dart';

class CreateShowScreen extends StatefulWidget {
  const CreateShowScreen({super.key});

  @override
  State<CreateShowScreen> createState() => _CreateShowScreenState();
}

class _CreateShowScreenState extends State<CreateShowScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  AssetImage? _defaultAssetImage;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _defaultAssetImage =
        const AssetImage(AmptiveImageStrings.createShowPlaceholderImage);

    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    await handlePickedFile(pickedFile);

    // var croppedFile = await _cropImage(_image);
  }

  Future<void> handlePickedFile(XFile? pickedFile) async {
    if (pickedFile != null && mounted) {
      File image = File(pickedFile.path);

      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          backgroundColor: AmptiveColors.black.withOpacity(0.05),
          title: Container(
            margin: EdgeInsets.only(left: 54.w),
            child: Text(
              "Create your Show",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: _imageSelected()
                  ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                    )
                  : Image(
                      image: _defaultAssetImage!,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(),
                ),
              ),
            ),

            // Box containing the icon or the selected image
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 16.h, bottom: 34.h),
                      child: GestureDetector(
                        onTap: getImageFromGallery,
                        child: Container(
                          width: 160.w,
                          height: 160.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: _imageSelected()
                                      ? Image.file(
                                          _selectedImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image(
                                          image: _defaultAssetImage!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundColor:
                                        AmptiveColors.black.withOpacity(0.5),
                                    radius: 20.r,
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AmptiveColors.whiteColor,
                                      size: 25.w,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Title",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(fontSize: AmptiveFontSizes.size15),
                        ),
                        Expanded(
                            child: SizedBox(
                          width: 1.w,
                        )),
                        Text(
                          "140 remaining",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                  color: AmptiveColors.whiteColor
                                      .withOpacity(0.4)),
                        ),
                      ],
                    ),
                    SizedBox(height: 11.5.h),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 16.w),
                        hintText: 'What is the title of your show?',
                        hintStyle: TextStyle(
                          fontSize: AmptiveFontSizes.size14,
                          color: AmptiveColors.whiteColor.withOpacity(0.4),
                          fontWeight: AmptiveFontWeights.medium,
                        ),

                        filled: true,
                        fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.w,
                            color: AmptiveColors.transparentColor,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),

                    ),
                    SizedBox(height: 33.5.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _imageSelected() {
    return _selectedImage != null;
  }
}
