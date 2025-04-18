import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/constants.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/utils/dialogs/select_audience_access_for_events_dialog.dart';
import 'package:amptive/src/utils/dialogs/select_audience_access_for_shows_dialog.dart';
import 'package:amptive/src/utils/dialogs/select_capacity_for_events_dialog.dart';
import 'package:amptive/src/utils/dialogs/select_hand_raising_dialog.dart';
import 'package:amptive/src/utils/dialogs/select_whispers_dialog.dart';
import 'package:amptive/src/utils/modals/select_date_modal.dart';
import 'package:amptive/src/utils/modals/show_text_area_modal.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../models/host.dart';
import '../../../../../utils/constants/font_weights.dart';
import '../../../../../utils/dialogs/add_co_host_dialog.dart';
import '../../../../../utils/dialogs/add_communities_dialog.dart';
import '../../../../../utils/dialogs/add_hastags_dialog.dart';
import '../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../../widgets/common_widgets/elevated_button_widget.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_create_show_event/create_show_text_form_field.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_create_show_event/selected_community.dart';

class CreateShowScreen extends StatefulWidget {
  final ShowType showType;

  const CreateShowScreen({super.key, this.showType = ShowType.show});

  @override
  State<CreateShowScreen> createState() => _CreateShowScreenState();
}

class _CreateShowScreenState extends State<CreateShowScreen> {
  final ImagePicker _picker = ImagePicker();
  List<dynamic> selectedHosts = [1, 2, 3, 4, 5];
  CreateShowService service = GetIt.I<CreateShowService>();
  String? showTypeTitle;
  final ValueNotifier<bool> _communitySelected = ValueNotifier(false);

  AssetImage? _defaultAssetImage;
  Community? _selectedCommunityCard;


  @override
  void initState() {
    super.initState();
    setShowTypeTitle();
    service.initFormControl();
    _defaultAssetImage =
    const AssetImage(ATImgStrings.createShowPlaceholderImage);
  }

  @override
  void dispose() {
    service.dispose();
    super.dispose();
  }

  setShowTypeTitle() {
    if (widget.showType == ShowType.episode) {
      showTypeTitle = "Episode";
    } else if (widget.showType == ShowType.event) {
      showTypeTitle = "Event";
    } else {
      showTypeTitle = "Show";
    }
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final croppedFile = await _customCrop(pickedFile);

    await handlePickedFile(croppedFile);
  }

  Future<void> handlePickedFile(MemoryImage? pickedFile) async {
    if (pickedFile != null && mounted) {
      Uint8List image = pickedFile.bytes;
      service.selectedImage.value = image;
    }
  }

  Future<MemoryImage?> _customCrop(XFile? pickedFile) async {
    if (pickedFile != null && mounted) {
      File image = File(pickedFile.path);
      MemoryImage? img =
      await context.pushNamed(ATRoutes.cropImageSquare, extra: image);
      return img;

    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: const BackButton(),
          backgroundColor: ATColors.black.withOpacity(0.05),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: Text(
                  "Create your $showTypeTitle",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          actions: [
            ShowTypeVisibilityWidget(
              showType: widget.showType,
              allowedShowTypes: const [ShowType.event],
              child: IconButton(
                icon: const Icon(Iconsax.calendar_2),
                onPressed: () async {
                  await selectDateModal(context, service.selectedImage.value);
                },
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            AmptiveRebuilderWidget(
              notifier: service.selectedImage,
              builder: (ctx, selectedImage, _) {
                return Positioned.fill(
                  child: _imageSelected()
                      ? Image.memory(
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
                color: ATColors.black.withOpacity(0.6),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: Platform.isIOS ? 15.0 : 150.0,
                      sigmaY: Platform.isIOS ? 15.0 : 150.0),
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
                                notifier: service.selectedImage,
                                builder: (ctx, selectedImage, _) {
                                  return Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: _imageSelected()
                                          ? Image.memory(
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
                                    ATColors.black.withOpacity(0.5),
                                    radius: 20.r,
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: ATColors.white,
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
                      controller: service.titleController,
                      hintText: "What is the title of your show?",
                      maxLength: Constants.kMaxTitleCharacters,
                      onChanged: (val) {
                        service.titleCharLength.value =
                            service.titleController.text.length;
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
                        color: ATColors.white.withOpacity(0.4),
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
                    ATContainer(
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
                              color: ATColors.white
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
                          fontWeight: ATFontWeights.w500,
                          color: ATColors.white.withOpacity(0.4),
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
                              color: ATColors.white
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
                                      backgroundColor: ATColors
                                          .white
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
                                            color: ATColors
                                                .white
                                                .withOpacity(0.7),
                                            fontWeight:
                                            ATFontWeights
                                                .w500)),
                                  )
                                ],
                              ),
                              Text(
                                "ABBYWAMBACH will be notified",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                    fontSize: ATFontSizes.size13,
                                    color: ATColors.white
                                        .withOpacity(0.6),
                                    fontWeight:
                                    ATFontWeights.w500),
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
                            ATColors.white.withOpacity(0.4),
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
                          fontWeight: ATFontWeights.w500,
                          color: ATColors.white.withOpacity(0.4),
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
                        // service.hashtags.value =
                        await showAddHashtagDialog(context);
                        service.hashTagSelected.value =
                            service.selectedHashtagLength.value > 0;
                      },
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: ATColors.white.withOpacity(0.4),
                      ),
                    ),
                    AmptiveRebuilderWidget(
                        notifier: service.selectedHashtagLength,
                        builder: (ctx, value, _) {
                          return SizedBox(height: value > 0 ? 8.h : 0);
                        }),
                    AmptiveRebuilderWidget(
                      notifier: service.selectedHashtagLength,
                      builder: (ctx, selected, _) {
                        return selected > 0
                            ? AmptiveRebuilderWidget(
                          notifier: service.selectedHashtags,
                          builder: (ctx, hashtags, _) {
                            return SelectedHashTags(
                              hashtags: hashtags,
                              onRemove: (hashtag) {
                                service.removeSelectedHashtags(hashtag);
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
                          fontWeight: ATFontWeights.w500,
                          color: ATColors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    const CreateShowTextFieldTitle(
                      title: "Audience Access",
                    ),
                    SizedBox(height: 11.5.h),
                    CreateShowTextFormField(
                      readOnly: true,
                      controller: service.audienceAccessController,
                      hintText: "Select who can access this show",
                      suffixIcon: Icon(
                        Icons.arrow_forward_ios,
                        size: 20.w,
                        color: ATColors.white.withOpacity(0.4),
                      ),
                      onTap: () async {
                        if (widget.showType == ShowType.show) {
                          await showSelectAudienceAccessForShowsDialog(context);
                        } else {
                          await showSelectAudienceAccessForEventsDialog(
                              context);
                        }
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8.h),
                      width: 360.w,
                      child: Text(
                        "You will be prompted to setup your subscription plan, if you haven't set it up yet.  ",
                        overflow: TextOverflow.visible,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: ATFontWeights.w500,
                          color: ATColors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Divider(
                      height: 2.h,
                      thickness: 2.w,
                      color: ATColors.brandBlack.withOpacity(0.10),
                    ),
                    SizedBox(height: 24.h),

                    CreateShowTextFieldTitle(
                      title: "Moderation Tools",
                      titleStyle: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: ATFontWeights.w500),
                    ),
                    SizedBox(height: 16.h),

                    // Hand Raising
                    ShowTypeVisibilityWidget(
                      showType: ShowType.all,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: const CreateShowTextFieldTitle(
                          prefixIcon: Icons.front_hand_outlined,
                          title: "Hand Raising",
                        ),
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: ShowType.all,
                      child: CreateShowTextFormField(
                        readOnly: true,
                        controller: service.handRaisingController,
                        hintText: "Select audience interaction",
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.w,
                          color: ATColors.white.withOpacity(0.4),
                        ),
                        onTap: () async {
                          await showHandRaisingDialog(context);
                        },
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: ShowType.all,
                      child: Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 30.h),
                        width: 360.w,
                        child: Text(
                          "While you're live, you’ll have full access to your moderation tools, allowing you to manage interactions and maintain control throughout the session. Learn more",
                          overflow: TextOverflow.visible,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: ATFontWeights.w500,
                            color:
                            ATColors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),

                    // Capacity
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [ShowType.event],
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: const CreateShowTextFieldTitle(
                          prefixIcon: Icons.people_outline,
                          title: "Capacity",
                        ),
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [ShowType.event],
                      child: CreateShowTextFormField(
                        readOnly: true,
                        controller: service.capacityController,
                        hintText: "Unlimited",
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.w,
                          color: ATColors.white.withOpacity(0.4),
                        ),
                        onTap: () async {
                          await showEventCapacitySelectionDialog(
                              context: context);
                        },
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [ShowType.event],
                      child: Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 30.h),
                        width: 360.w,
                        child: Text(
                          "Set the maximum number of listeners for your event. Once the limit is reached, no additional participants can join or pay.",
                          overflow: TextOverflow.visible,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: ATFontWeights.w500,
                            color:
                            ATColors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),

                    // Whispers
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [
                        ShowType.event,
                        ShowType.episode
                      ],
                      child: Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        child: const CreateShowTextFieldTitle(
                          prefixIcon: Iconsax.message,
                          title: "Whispers",
                        ),
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [
                        ShowType.event,
                        ShowType.episode
                      ],
                      child: CreateShowTextFormField(
                        readOnly: true,
                        controller: service.whisperController,
                        hintText: "Turn whispers on or off for this event",
                        suffixIcon: Icon(
                          Icons.arrow_forward_ios,
                          size: 20.w,
                          color: ATColors.white.withOpacity(0.4),
                        ),
                        onTap: () async {
                          await showWhispersDialog(context);
                        },
                      ),
                    ),
                    ShowTypeVisibilityWidget(
                      showType: widget.showType,
                      allowedShowTypes: const [
                        ShowType.event,
                        ShowType.episode
                      ],
                      child: Container(
                        margin: EdgeInsets.only(top: 8.h, bottom: 30.h),
                        width: 360.w,
                        child: Text(
                          "Whispers are randomly selected comments from your live audience that appear on your event page while you are live. \n \nNon-attending users can see these comments, encouraging them to join your live event.",
                          overflow: TextOverflow.visible,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                            fontWeight: ATFontWeights.w500,
                            color:
                            ATColors.white.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    height: 80.h,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: AmptiveRebuilderWidget(
                  notifier: service.selectedImage,
                  builder: (_, val, __) {
                    return AmptiveElevatedButtonWidget(
                      height: 50.w,
                      buttonTitle: getSubmitButtonTileText(),
                      onPressed: service.formIsValid()
                          ? () {
                        service.onSubmit();
                        navigateToSuccessPage();
                      }
                          : null,
                      buttonStyle: ButtonStyle(
                        backgroundColor:
                        WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return ATColors.hex2D2D2D;
                          }
                          return ATColors.hexD9D9D9;
                        }),
                        foregroundColor:
                        WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.disabled)) {
                            return ATColors.strokeGreyColor;
                          }
                          return ATColors.brandBlack;
                        }),
                      ),
                    );
                  }),
            )
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

    if (temp != null) {
      service.coHostSelected.value = false;
      selectedHosts = processSelectedHost(temp.toList());
      service.coHostSelected.value = hostSelected();
    }
  }

  _imageSelected() {
    return service.selectedImage.value != null;
  }

  processSelectedHost(List<ObjectWithNotifier<Host>> ls) {
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

  getSubmitButtonTileText() {
    if (widget.showType == ShowType.show) {
      return "Go LIVE";
    } else if (widget.showType == ShowType.event) {
      return "Go LIVE";
    } else if (widget.showType == ShowType.episode) {
      return "Go LIVE";
    }
  }

  void navigateToSuccessPage() {
    if (widget.showType == ShowType.show) {
      context.pushReplacementNamed(ATRoutes.CREATE_SHOW_SUCCESS,
          extra: service.selectedShowImage!);
    } else if (widget.showType == ShowType.event) {
      context.pushReplacementNamed(ATRoutes.EVENT_SCHEDULED_SCREEN,
          extra: service.selectedShowImage!);
    } else if (widget.showType == ShowType.episode) {
      context.pushReplacementNamed(ATRoutes.EPISODE_SCHEDULED_SCREEN,
          extra: service.selectedShowImage!);
    }
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
                    color: ATColors.white.withOpacity(0.4), width: 1),
              ),
              child: ClipOval(
                child: item is ObjectWithNotifier<Host>
                    ? Image.asset(
                  item.obj.profilePicture!,
                  // Replace with actual image URL
                  fit: BoxFit.cover,
                )
                    : Stack(
                  children: [
                    BackdropFilter(
                      filter:
                      ImageFilter.blur(sigmaX: 53.4, sigmaY: 53.4),
                      child: Container(
                        color: ATColors.brandBlack
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
                          fontSize: ATFontSizes.size10,
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
