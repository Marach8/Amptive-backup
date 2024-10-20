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
import '../../../../../../../../utils/constants/font_weights.dart';
import '../../../../../../../../utils/dialogs/add_communities_dialog.dart';

class CreateShowFormScreen extends StatefulWidget {
  const CreateShowFormScreen({super.key});

  @override
  State<CreateShowFormScreen> createState() => _CreateShowFormScreenState();
}

class _CreateShowFormScreenState extends State<CreateShowFormScreen> {
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
                color: AmptiveColors.black.withOpacity(0.6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(),
                ),
              ),
            ),

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
                    const CreateShowTextFieldTitle(
                      title: "Title",
                      otherInfo: "140 remaining",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "What is the title of your show?",
                    ),
                    SizedBox(height: 33.5.h),

                    const CreateShowTextFieldTitle(
                      title: "Description",
                      otherInfo: "4000 remaining",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "Tell your listeners what your show is about",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    SizedBox(height: 33.5.h),
                    GestureDetector(
                      onTap: (){
                        showAddCommunitiesDialog(context);
                      },
                      child: const CreateShowTextFieldTitle(
                        title: "Community",
                      ),
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "Select a community for your show",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Text(
                        "Communities will help your Shows and Events reach more listeners. Listeners can also use communities to find your Shows and Events, easily. Learn more",
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: AmptiveFontWeights.medium,
                              color: AmptiveColors.whiteColor.withOpacity(0.4),
                            ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // add widget here

                    const CreateShowTextFieldTitle(
                      title: "Add Co-hosts",
                      otherInfo: "5 max",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "Search and add co-hosts for your show",
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Text(
                        "Added users must accept your invitation before they are added as your co-hosts.",
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: AmptiveFontWeights.medium,
                              color: AmptiveColors.whiteColor.withOpacity(0.4),
                            ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    const CreateShowTextFieldTitle(
                      title: "Hashtags",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "Enter your own hashtag",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      child: Text(
                        "You can add up to 5 hashtags, with each hashtag being up to 25 characters long and free of spaces or special characters.",
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: AmptiveFontWeights.medium,
                              color: AmptiveColors.whiteColor.withOpacity(0.4),
                            ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    const CreateShowTextFieldTitle(
                      title: "Audience Access",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "Select who can access this show",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      width: 360.w,
                      child: Text(
                        "You will be prompted to setup your subscription plan, if you haven't set it up yet.  ",
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: AmptiveFontWeights.medium,
                              color: AmptiveColors.whiteColor.withOpacity(0.4),
                            ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Divider(
                      height: 1.h,
                      color: AmptiveColors.brandBlackColor.withOpacity(0.10),
                    )
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

class CreateShowTextFieldTitle extends StatelessWidget {
  final String title;
  final String? otherInfo;

  const CreateShowTextFieldTitle({
    super.key,
    required this.title,
    this.otherInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
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
          otherInfo ?? "",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: AmptiveColors.whiteColor.withOpacity(0.4)),
        ),
      ],
    );
  }
}

class CreateShowTextFormField extends AmptiveTextFormFieldWidget {
  const CreateShowTextFormField({
    super.key,
    required super.controller,
    super.hintText,
    super.prefixIcon,
    super.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: AmptiveFontSizes.size14,
          color: AmptiveColors.whiteColor.withOpacity(0.4),
          fontWeight: AmptiveFontWeights.medium,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: AmptiveColors.whiteColor.withOpacity(0.1),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2.w,
            color: AmptiveColors.transparentColor,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.w,
            color: AmptiveColors.transparentColor,
          ),
          borderRadius: BorderRadius.circular(14.r),
        ), // Removes the border when not focused
      ),
    );
  }
}
