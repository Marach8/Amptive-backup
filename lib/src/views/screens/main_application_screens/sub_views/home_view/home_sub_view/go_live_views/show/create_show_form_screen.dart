import 'dart:io';
import 'dart:ui';

import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/modals/show_text_area_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../../models/host.dart';
import '../../../../../../../../utils/constants/font_weights.dart';
import '../../../../../../../../utils/dialogs/add_co_host_dialog.dart';
import '../../../../../../../../utils/dialogs/add_communities_dialog.dart';
import '../../../../../../../../utils/dialogs/add_hastags_dialog.dart';
import '../../../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../../../widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../../../../../widgets/other_widgets/main_application_widgets/widgets_in_create_show_event/create_show_text_form_field.dart';
import '../../../../../../../widgets/other_widgets/main_application_widgets/widgets_in_create_show_event/selected_community.dart';

class CreateShowScreen extends StatefulWidget {
  const CreateShowScreen({super.key});

  @override
  State<CreateShowScreen> createState() => _CreateShowScreenState();
}

class _CreateShowScreenState extends State<CreateShowScreen> {
  late TextEditingController _titleController;
  final ImagePicker _picker = ImagePicker();
  List<dynamic> selectedHosts = [1, 2, 3, 4, 5];
  CreateShowService service = GetIt.I<CreateShowService>();

  final ValueNotifier<File?> _selectedImage = ValueNotifier(null);
  final ValueNotifier<bool> _communitySelected = ValueNotifier(false);

  AssetImage? _defaultAssetImage;
  Community? _selectedCommunityCard = null;

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
    service.initNotifiers();
    _defaultAssetImage =
        const AssetImage(AmptiveImageStrings.createShowPlaceholderImage);

    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    service.disposeNotifiers();
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
                    AmptiveRebuilderWidget(
                        notifier: service.titleCharLength,
                        builder: (ctx, len, _) {
                          var noRemaining = Constants.kMaxTitleCharacters - len;
                          return CreateShowTextFieldTitle(
                            title: "Title",
                            otherInfo: "$noRemaining remaining",
                          );
                        }),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: _titleController,
                      hintText: "What is the title of your show?",
                      maxLength: Constants.kMaxTitleCharacters,
                      onChanged: (val) {
                        service.titleCharLength.value =
                            _titleController.text.length;
                      },
                    ),
                    SizedBox(height: 33.5.h),

                    AmptiveRebuilderWidget(
                        notifier: service.descCharactersLength,
                        builder: (ctx, len, _) {
                          var noRemaining =
                              Constants.kMaxDescriptionCharacters - len;
                          return CreateShowTextFieldTitle(
                            title: "Description",
                            otherInfo: "$noRemaining remaining",
                          );
                        }),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      controller: service.descController,
                      readOnly: true,
                      hintText: "Tell your listeners what your show is about",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                      onChanged: (val) {
                        service.descCharactersLength.value =
                            service.descController.text.length;
                      },
                      onTap: () {
                        showTextAreaModal(context);
                      },
                    ),
                    SizedBox(height: 33.5.h),
                    const CreateShowTextFieldTitle(
                      title: "Community",
                    ),
                    SizedBox(height: 11.5.h),
                    AmptiveCustomContainer(
                      child: AmptiveRebuilderWidget(
                        builder: (ctx, selected, _) {
                          return selected && _selectedCommunityCard != null
                              ? SelectedCommunity(
                                  selectedCommunity: _selectedCommunityCard!,
                                  onClose: () {
                                    _communitySelected.value = false;
                                  },
                                  onView: () async {
                                    _communitySelected.value = false;
                                    await _openCommunitySelection(context);
                                  },
                                )
                              : CreateShowTextFormField(
                                  controller: TextEditingController(),
                                  hintText: "Select a community for your show",
                                  suffixIcon: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20.w,
                                    color: AmptiveColors.whiteColor
                                        .withOpacity(0.4),
                                  ),
                                  readOnly: true,
                                  onTap: () async {
                                    await _openCommunitySelection(context);
                                  },
                                );
                        },
                        notifier: _communitySelected,
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
                    AmptiveRebuilderWidget(
                      notifier: service.coHostSelected,
                      builder: (ctx, selected, _) {
                        return selected
                            ? Container(
                                height: 98.h,
                                padding: EdgeInsets.symmetric(
                                    vertical: 13.h, horizontal: 16.w),
                                decoration: BoxDecoration(
                                    color: AmptiveColors.whiteColor
                                        .withOpacity(0.1),
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
                                          onPressed: () async {
                                            await _editCoHosts(context);
                                          },
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
                                controller: TextEditingController(),
                                hintText:
                                    "Search and add co-hosts for your show",
                                readOnly: true,
                                onTap: () async {
                                  await _editCoHosts(context);
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
                      controller: TextEditingController(),
                      hintText: "Enter your own hashtag",
                      readOnly: true,
                      onTap: () async {
                        service.hashtags.value =
                            await showAddHashtagDialog(context);
                        service.hashTagSelected.value = true;
                      },
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: AmptiveColors.whiteColor.withOpacity(0.4),
                      ),
                    ),
                    AmptiveRebuilderWidget(
                        notifier: service.hashTagSelected,
                        builder: (ctx, selected, _) {
                          return SizedBox(height: selected ? 8.h : 0);
                        }),
                    AmptiveRebuilderWidget(
                      notifier: service.hashTagSelected,
                      builder: (ctx, selected, _) {
                        return selected
                            ? AmptiveRebuilderWidget(
                                notifier: service.hashtags,
                                builder: (ctx, hashtags, _) {
                                  return SelectedHashTags(
                                    hashtags: hashtags,
                                    onRemove: (hashtag) {
                                      setState(() {
                                        service.hashtags.value.remove(hashtag);
                                      });
                                    },
                                  );
                                },
                              )
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
                      controller: TextEditingController(),
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

  Future<void> _openCommunitySelection(BuildContext context) async {
    _selectedCommunityCard = await showAddCommunitiesDialog(context);
    _communitySelected.value = true;
  }

  Future<void> _editCoHosts(BuildContext context) async {

    var temp = await showAddCoHostDialog(context);

    if(temp != null){
      service.coHostSelected.value = false;
      selectedHosts = processSelectedHost(temp.toList());
      service.coHostSelected.value = hostSelected();
    }

  }

  _imageSelected() {
    return _selectedImage.value != null;
  }

  processSelectedHost(List<HostWithNotifier> ls) {
    if (ls.length >= 5) {
      return ls.sublist(0, 5);
    } else {
      List<dynamic> dynamicList = List.from(ls);
      for (int i = ls.length; i < 5; i++) {
        dynamicList.add(i + 1);
      }
      return dynamicList;
    }
  }

  bool hostSelected() {
    return !selectedHosts.every((element) => element is int);
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
                child: item is HostWithNotifier
                    ? Image.asset(
                        item.host.profilePicture!,
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
    required this.onRemove,
  });

  final List<String> hashtags;
  final Function(String) onRemove;

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
                    onTap: () => onRemove(hashtag),
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
