import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/models/hashtag.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/constants.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/dialogs/select_audience_access_for_events_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/select_audience_access_for_shows_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/select_capacity_for_events_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/select_hand_raising_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/select_whispers_dialog.dart';
import 'package:amptive/src/config/utils/modals/select_date_modal.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/enter_show_description_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_slide.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nested/nested.dart';

import 'dart:ui';

import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/existing_go_live_program_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import '../../../../config/utils/colors.dart';
import 'package:amptive/src/features/home/presentation/widgets/home_widgets_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import '../../../../models/host.dart';
import '../../../../config/utils/font_weights.dart';
import '../../../../views/widgets/common_widgets/rich_text.dart';
import '../../../home/presentation/widgets/home_widgets_export.dart';
import '../widgets/add_co_host_dialog.dart';
import '../../../../config/utils/dialogs/add_communities_dialog.dart';
import '../../../../config/utils/dialogs/add_hastags_dialog.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';
import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_create_show_event/create_show_text_form_field.dart';
import '../widgets/selected_community.dart';

//     ShowTypeVisibilityWidget(
          //       showType: widget.showType,
          //       allowedShowTypes: const <ShowType>[ShowType.event],
          //       child: IconButton(
          //         icon: const Icon(Iconsax.calendar_2),
          //         onPressed: () async {
          //           await selectDateModal(context, service.selectedImage.value);
          //         },
          //       ),
          //     ),





class CreateShowFormScreen extends StatefulWidget {
  const CreateShowFormScreen({super.key});

  @override
  State<CreateShowFormScreen> createState() => _CreateShowFormScreenState();
}

class _CreateShowFormScreenState extends State<CreateShowFormScreen> {
  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();
  String programDesc = ATStrings.TELL_LISTENERS_ABOUT_SHOW;
  Community? selectedCommunity;
  CreateShowService service = GetIt.I<CreateShowService>();

  @override 
  void initState(){
    super.initState();
    service.initFormControl();
    _titleCntrl = TextEditingController()..addListener(
      () => _titleStreamCntrl.add(_titleCntrl.text.trim())
    );
  }

  @override 
  void dispose(){
    _titleCntrl.dispose();
    _titleStreamCntrl.close();
    _descStreamCntrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight = kToolbarHeight + MediaQuery.paddingOf(context).top;

    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc(),),
        BlocProvider<_PrivateBloc>(create: (_) => _PrivateBloc())
      ],
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.trsprnt,
        child: Scaffold(
          body: Builder(
            builder: (BuildContext blocContext) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: BlocBuilder<_PrivateBloc, String>(
                      builder: (_, String selectedImgString) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
                          child: ATImgLoader(
                            boxFit: BoxFit.fill,
                            imgPath: selectedImgString
                          ),
                        );
                      }
                    ),
                  ),
                  
                  ATContainer(
                    color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: blocContext.read<BlurredHeaderBloc>().onScrollNotification,
                      child: NestedScrollView(
                        headerSliverBuilder: (_, __) => <Widget>[
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: ATSliverHDelegate(
                              maxExt: blurredHeaderHeight, minExt: blurredHeaderHeight,
                              child: SizedBox(
                                height: blurredHeaderHeight,
                                child: ATBlurredHeaderWidget(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: ATRoundedBackBtn(bgColor: ATColors.trsprnt,),
                                      ),
                                      Text(
                                        ATStrings.CREATE_SHOW,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                      const SizedBox(width: 30,)
                                    ],
                                  ),
                                )
                              )
                            ),
                          ),
                        ],
                        
                        body: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(15, 10, 15, 100),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              SelectProgramCoverArt(
                                onImageSelected: (Uint8List imageBytes){}
                              ),
                              const SizedBox(height: 30,),

                              StreamBuilder<String>(
                                stream: _titleStreamCntrl.stream,
                                builder: (_, AsyncSnapshot<String> snapshot) {
                                  final int remaining = 140 - (snapshot.data?.length ?? 0);
                                  return RowWith2Texts(
                                    text1: ATStrings.TITLE,
                                    text2: '$remaining remaining',
                                  );
                                }
                              ),
                              const SizedBox(height: 10),
                              ATTextFormField(
                                controller: _titleCntrl,
                                hintText: ATStrings.TITLE_OF_UR_SHOW,
                                prefixIcon: const SizedBox(width: 12,),
                                hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.4),
                                ),
                                disableBlueBorder: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: ATColors.trsprnt)
                                ),
                              ),

                              const SizedBox(height: 30),                                                    
                              StreamBuilder<String>(
                                stream: _descStreamCntrl.stream,
                                builder: (_, AsyncSnapshot<String> snapshot) {
                                  final int remaining = 4000 - (snapshot.data?.length ?? 0);
                                  return RowWith2Texts(
                                    text1: ATStrings.DESCRIPTION,
                                    text2: '$remaining remaining',
                                  );
                                }
                              ),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (_, void Function(void Function()) setter) {
                                  return CreateShowItem(
                                    description: programDesc,
                                    onTap: ()async{
                                      final String? description = await showEnterDescriptionModal(context);
                                      if(description != null){
                                        setter(
                                          (){
                                            programDesc = description;
                                            _descStreamCntrl.add(description);
                                          }
                                        );
                                      }
                                    },
                                  );
                                }
                              ),
                              
                              const SizedBox(height: 30),

                              const RowWith2Texts(text1: ATStrings.COMMUNITY),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (_, void Function(void Function()) setter) {
                                  return ATScalingSwitcher(
                                    duration: 300,
                                    child: selectedCommunity == null ? CreateShowItem(
                                      description: ATStrings.SELECT_COMMUNITY_4_UR_SHOW,
                                      onTap: ()async{
                                        final Community? selectedCom = await showCommunitiesDialog(context);
                                        if(selectedCom != null){
                                          setter(() => selectedCommunity = selectedCom);
                                        }
                                      },
                                    ) : SelectedCommunityWidget(
                                      selectedCommunity: selectedCommunity!,
                                      onClose: () => setter(() => selectedCommunity = null),
                                      onView: (){}
                                    )
                                  );
                                }
                              ),
                              const SizedBox(height: 10,),
                              ATRichText(
                                maxLines: 4,
                                items: <String, TextStyle>{
                                  ATStrings.ADD_COMMUNITY_DESC: Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                  ),
                                  ATStrings.LEARN_MORE: Theme.of(context).textTheme.labelSmall!
                                },
                                textOnTap: (String text){
                                  if(text == ATStrings.LEARN_MORE){

                                  }
                                },
                              ),
                              const SizedBox(height: 30),
                                                    
                              // add widget here
                                                    
                              const CreateShowTextFieldTitle(
                                title: "Add Co-hosts",
                                otherInfo: "5 max",
                              ),
                              const SizedBox(height: 12),
                              AmptiveRebuilderWidget(
                                notifier: service.coHostSelected,
                                builder: (BuildContext ctx, bool selected, _) {
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
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            // Expanded(
                                            //     child: OverlappingHosts(
                                            //       items: selectedHosts,
                                            //     )),
                                            ElevatedButton(
                                              onPressed: () async {
                                                //await _editCoHosts(context);
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
                                      //await _editCoHosts(context);
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
                                  builder: (BuildContext ctx, int value, _) {
                                    return SizedBox(height: value > 0 ? 8.h : 0);
                                  }),
                              AmptiveRebuilderWidget(
                                notifier: service.selectedHashtagLength,
                                builder: (BuildContext ctx, int selected, _) {
                                  return selected > 0
                                      ? AmptiveRebuilderWidget(
                                    notifier: service.selectedHashtags,
                                    builder: (BuildContext ctx, Set<ObjectWithNotifier<Hashtag>> hashtags, _) {
                                      return SelectedHashTags(
                                        hashtags: hashtags,
                                        onRemove: (ObjectWithNotifier<Hashtag> hashtag) {
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
                                  // if (widget.showType == ShowType.show) {
                                  //   await showSelectAudienceAccessForShowsDialog(context);
                                  // } else {
                                  //   await showSelectAudienceAccessForEventsDialog(
                                  //       context);
                                  // }
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
                                color: ATColors.hex0D0D0D.withOpacity(0.10),
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
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[ShowType.event],
                              //   child: Container(
                              //     margin: EdgeInsets.only(bottom: 12.h),
                              //     child: const CreateShowTextFieldTitle(
                              //       prefixIcon: Icons.people_outline,
                              //       title: "Capacity",
                              //     ),
                              //   ),
                              // ),
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[ShowType.event],
                              //   child: CreateShowTextFormField(
                              //     readOnly: true,
                              //     controller: service.capacityController,
                              //     hintText: "Unlimited",
                              //     suffixIcon: Icon(
                              //       Icons.arrow_forward_ios,
                              //       size: 20.w,
                              //       color: ATColors.white.withOpacity(0.4),
                              //     ),
                              //     onTap: () async {
                              //       await showEventCapacitySelectionDialog(
                              //           context: context);
                              //     },
                              //   ),
                              // ),
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[ShowType.event],
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 8.h, bottom: 30.h),
                              //     width: 360.w,
                              //     child: Text(
                              //       "Set the maximum number of listeners for your event. Once the limit is reached, no additional participants can join or pay.",
                              //       overflow: TextOverflow.visible,
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .titleSmall
                              //           ?.copyWith(
                              //         fontWeight: ATFontWeights.w500,
                              //         color:
                              //         ATColors.white.withOpacity(0.4),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                                                    
                              // Whispers
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[
                              //     ShowType.event,
                              //     ShowType.episode
                              //   ],
                              //   child: Container(
                              //     margin: EdgeInsets.only(bottom: 12.h),
                              //     child: const CreateShowTextFieldTitle(
                              //       prefixIcon: Iconsax.message,
                              //       title: "Whispers",
                              //     ),
                              //   ),
                              // ),
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[
                              //     ShowType.event,
                              //     ShowType.episode
                              //   ],
                              //   child: CreateShowTextFormField(
                              //     readOnly: true,
                              //     controller: service.whisperController,
                              //     hintText: "Turn whispers on or off for this event",
                              //     suffixIcon: Icon(
                              //       Icons.arrow_forward_ios,
                              //       size: 20.w,
                              //       color: ATColors.white.withOpacity(0.4),
                              //     ),
                              //     onTap: () async {
                              //       await showWhispersDialog(context);
                              //     },
                              //   ),
                              // ),
                              // ShowTypeVisibilityWidget(
                              //   showType: widget.showType,
                              //   allowedShowTypes: const <ShowType>[
                              //     ShowType.event,
                              //     ShowType.episode
                              //   ],
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 8.h, bottom: 30.h),
                              //     width: 360.w,
                              //     child: Text(
                              //       "Whispers are randomly selected comments from your live audience that appear on your event page while you are live. \n \nNon-attending users can see these comments, encouraging them to join your live event.",
                              //       overflow: TextOverflow.visible,
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .titleSmall
                              //           ?.copyWith(
                              //         fontWeight: ATFontWeights.w500,
                              //         color:
                              //         ATColors.white.withOpacity(0.4),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
          
          resizeToAvoidBottomInset: false,

          bottomSheet: ATContainer(
            height: 70,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                ATColors.hex0D0D0D.withValues(alpha: 0.1),
                ATColors.hex0D0D0D
              ]
            ),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: BlocBuilder<_PrivateBloc, String?>(
              builder: (_, String? selectedImgPath) {
                return ATPlainElevatedBtn(
                  bgColor: ATColors.white,
                  fgColor: ATColors.hex0D0D0D,
                  btnTitle: ATStrings.NEXT,
                  onPressed: selectedImgPath == null ? null : () async{
                    await showAddCoHostDialog(context);
                    //await showAddHashtagDialog(context);
                    //await showHandRaisingDialog(context);
                    //showAddCommunitiesDialog(context);
                    //showSelectAudienceAccessForShowsDialog(context);
                    //context.pushNamed(AmptiveRoutes.CREATE_SHOW_SUCCESS);
                  },
                  
                  //onPressed: activate ? () async{
                    //await showAddCoHostDialog(context);
                    //await showAddHashtagDialog(context);
                    //showAddCommunitiesDialog(context);
                    //showSelectAudienceAccessForEventsDialog(context);
                    //showWhispersDialog(context);
                    //await showEventCapacitySelectionDialog(context: context);
                    //context.pushNamed(ATRoutes.EVENT_SCHEDULED_SCREEN);
                  //} : null,
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}

class CreateShowItem extends StatelessWidget {
  const CreateShowItem({
    super.key,
    required this.description,
    required this.onTap,
    this.trailing,
  });

  final VoidCallback onTap;
  final Widget? trailing;
  final String description;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      radius: 14,
      color: ATColors.white.withValues(alpha: 0.1),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(width: 20,),
    
          trailing ?? Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: ATColors.white.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}


class _PrivateBloc extends Cubit<String>{
  _PrivateBloc(): super(ATImgStrings.CREATE_SHOW_PLACEHOLDER);

  void setBgImage(String image) => emit(image);

}