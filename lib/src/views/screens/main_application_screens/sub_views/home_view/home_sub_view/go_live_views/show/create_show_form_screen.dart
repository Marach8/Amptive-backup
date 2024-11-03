import 'dart:io';
import 'dart:ui';

import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/constants/font_weights.dart';
import '../../../utils/dialogs/add_communities_dialog.dart';
import '../../widgets/common_widgets/custom_rebuilder_widget.dart';

class CreateShowScreen extends StatefulWidget {
  const CreateShowScreen({super.key});

  @override
  State<CreateShowScreen> createState() => _CreateShowScreenState();
}

class _CreateShowScreenState extends State<CreateShowScreen> {
  late TextEditingController _titleController;
  final ImagePicker _picker = ImagePicker();
  final List<dynamic> selectedHosts = [1, 2, 3, 4, 5];
  List<String> hashtags = [
    'amptive',
    'amptiveLive',
    'amptiveIsBack',
    'ui',
    'technology',
    'science'
  ];
  final ValueNotifier<File?> _selectedImage = ValueNotifier(null);
  final ValueNotifier<bool> _communitySelected = ValueNotifier(false);
  final ValueNotifier<bool> _coHostSelected = ValueNotifier(false);
  final ValueNotifier<bool> _hashTagSelected = ValueNotifier(false);

  AssetImage? _defaultAssetImage;

  final AndroidUiSettings _androidUiSettings = AndroidUiSettings(
    toolbarTitle: AmptiveOtherStrings.empty,
    toolbarColor: AmptiveColors.brandBlueColor,
    toolbarWidgetColor: AmptiveColors.whiteColor,
    initAspectRatio: CropAspectRatioPreset.square,
    lockAspectRatio: false,
    aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
    ],
  );

  final IOSUiSettings _iosUiSettings = IOSUiSettings(
    title: AmptiveOtherStrings.empty,
    aspectRatioPresets: [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio4x3,
    ],
  );

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
    final croppedFile = await _cropImage(pickedFile);

    await handlePickedFile(croppedFile);
  }

  Future<void> handlePickedFile(CroppedFile? pickedFile) async {
    if (pickedFile != null && mounted) {
      File image = File(pickedFile.path);
      _selectedImage.value = image;
    }
  }

  Future<CroppedFile?> _cropImage(XFile? pickedFile) async {
    if (pickedFile != null && mounted) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          _androidUiSettings,
          _iosUiSettings,
        ],
      );

      return croppedFile;
    }

    return null;
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
            AmptiveRebuilderWidget(
              notifier: _selectedImage,
              builder: (ctx, selectedImage, _) {
                return Positioned.fill(
                  child: _imageSelected()
                      ? Image.file(
                          selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : Image(
                          image: _defaultAssetImage!,
                          fit: BoxFit.cover,
                        ),
                );
              },
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
                              AmptiveRebuilderWidget(
                                notifier: _selectedImage,
                                builder: (ctx, selectedImage, _) {
                                  return Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: _imageSelected()
                                          ? Image.file(
                                              selectedImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image(
                                              image: _defaultAssetImage!,
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  );
                                },
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
                    const CreateShowTextFieldTitle(
                      title: "Community",
                    ),
                    SizedBox(height: 11.5.h),
                    AmptiveRebuilderWidget(
                      builder: (ctx, selected, _) {
                        return selected
                            ? SelectedCommunity(
                                selectedImage: _selectedImage.value)
                            : CreateShowTextFormField(
                                controller: _titleController,
                                hintText: "Select a community for your show",
                                suffixIcon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20.w,
                                  color:
                                      AmptiveColors.whiteColor.withOpacity(0.4),
                                ),
                                readOnly: true,
                                onTap: () {
                                  showAddCommunitiesDialog(context);
                                  //remove
                                  _communitySelected.value = true;
                                },
                              );
                      },
                      notifier: _communitySelected,
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
                    AmptiveRebuilderWidget(
                      notifier: _coHostSelected,
                      builder: (ctx, selected, _) {
                        return selected
                            ? Container(
                                height: 98.h,
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                    color: AmptiveColors.whiteColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14.r)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: OverlappingHosts(
                                          items: selectedHosts,
                                        )),
                                        ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AmptiveColors
                                                .whiteColor
                                                .withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.r),
                                            ),
                                          ),
                                          child: Text("Edit co-host",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      color: AmptiveColors
                                                          .whiteColor
                                                          .withOpacity(0.7),
                                                      fontWeight:
                                                          AmptiveFontWeights
                                                              .medium)),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "ABBYWAMBACH will be notified",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                              fontSize: AmptiveFontSizes.size13,
                                              color: AmptiveColors.whiteColor
                                                  .withOpacity(0.6),
                                              fontWeight:
                                                  AmptiveFontWeights.medium),
                                    )
                                  ],
                                ),
                              )
                            : CreateShowTextFormField(
                                controller: _titleController,
                                hintText:
                                    "Search and add co-hosts for your show",
                                readOnly: true,
                                onTap: () {
                                  setState(() {
                                    _coHostSelected.value = true;
                                  });
                                },
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 20.w,
                                  color:
                                      AmptiveColors.whiteColor.withOpacity(0.4),
                                ),
                              );
                      },
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
                      readOnly: true,
                      onTap: () {
                        _hashTagSelected.value = true;
                      },
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    AmptiveRebuilderWidget(
                        notifier: _hashTagSelected,
                        builder: (ctx, selected, _) {
                          return SizedBox(height: selected ? 8.h : 0);
                        }),
                    AmptiveRebuilderWidget(
                      notifier: _hashTagSelected,
                      builder: (ctx, selected, _) {
                        return selected
                            ? SelectedHashTags(hashtags: hashtags)
                            : const SizedBox();
                      },
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
    return _selectedImage.value != null;
  }
}

class SelectedCommunity extends StatelessWidget {
  const SelectedCommunity({
    super.key,
    required File? selectedImage,
  }) : _selectedImage = selectedImage;

  final File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 98.h,
      padding: EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w),
      decoration: BoxDecoration(
          color: AmptiveColors.whiteColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100.328.w,
            height: 72.h,
            decoration: BoxDecoration(
                color: const Color(0xFF385EF2),
                borderRadius: BorderRadius.circular(5.r)),
            child: Stack(
              children: [
                Positioned(
                  top: 4.h,
                  left: 7.w,
                  child: Text(
                    "Technology",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontSize: AmptiveFontSizes.size9,
                        fontWeight: AmptiveFontWeights.semiBold),
                  ),
                ),
                Positioned(
                    bottom: 0.h,
                    right: 0.w,
                    child: SizedBox(
                      height: 52.h,
                      width: 55.w,
                      child: SvgPicture.asset(
                        AmptiveImageStrings.amptiveLogo,
                        fit: BoxFit.cover,
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            width: 18.w,
          ),
          Container(
            padding: EdgeInsets.only(top: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Technology",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AmptiveColors.whiteColor.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  child: Text("View Community",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AmptiveColors.whiteColor.withOpacity(0.7),
                          fontWeight: AmptiveFontWeights.medium)),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 1.w,
            ),
          ),
          Icon(Icons.close)
        ],
      ),
    );
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
    this.onTap,
    this.readOnly = false,
  });

  final bool readOnly;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
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

class OverlappingHosts extends StatelessWidget {
  const OverlappingHosts({
    super.key,
    required this.items,
  });

  final List items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.w,
      width: 180.w,
      child: Stack(
        children: items.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;

          return Positioned(
            left: index * 30.0, // Adjust the overlap by changing this value
            child: Container(
              width: 40.w, // Diameter of the circle
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AmptiveColors.whiteColor.withOpacity(0.4), width: 1),
              ),
              child: ClipOval(
                child: item is String
                    ? Image.network(
                        'https://via.placeholder.com/40',
                        // Replace with actual image URL
                        fit: BoxFit.cover,
                      )
                    : Stack(
                        children: [
                          BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 53.4, sigmaY: 53.4),
                            child: Container(
                              color: AmptiveColors.brandBlackColor
                                  .withOpacity(0.2),
                            ),
                          ),
                          Center(
                            child: Text(
                              '$item', // Display number
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontSize: AmptiveFontSizes.size10,
                                  ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SelectedHashTags extends StatelessWidget {
  const SelectedHashTags({
    super.key,
    required this.hashtags,
  });

  final List<String> hashtags;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: hashtags.map((hashtag) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: AmptiveColors.whiteColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Text(
                    hashtag,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: AmptiveFontSizes.size10,
                          color: AmptiveColors.whiteColor.withOpacity(0.7),
                        ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      hashtags.remove(hashtag); // Remove hashtag
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: AmptiveColors.whiteColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
