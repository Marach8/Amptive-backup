import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/services/create_show/create_show_service.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/divider_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nested/nested.dart';


import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/features/home/presentation/widgets/home_widgets_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import '../../../../models/host.dart';
import '../../../../views/widgets/common_widgets/rich_text.dart';
import '../../../../config/utils/dialogs/add_communities_dialog.dart';

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
  String chooseAudienceAccess = ATStrings.SELECT_WHO_CAN_ACCESS_SHOW;
  String shouldAllowHandRasing = ATStrings.CHOOSE_2_ALLOW_HAND_RASING;

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
        BlocProvider<BgImageBloc>(create: (_) => BgImageBloc())
      ],
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.trsprnt,
        child: Scaffold(
          body: Builder(
            builder: (BuildContext blocContext) {
              return Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: BlocBuilder<BgImageBloc, (String, Uint8List?)>(
                      builder: (_, (String, Uint8List?) state) {
                        return ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                          child: state.$2 == null ? ATImgLoader(
                            boxFit: BoxFit.fill,
                            imgPath: state.$1,
                          ) : Image.memory(state.$2!, fit: BoxFit.fill)
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
                                        style: context.textTheme.bodyMedium,
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
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: SelectProgramCoverArt(
                                  onImageSelected: blocContext.read<BgImageBloc>().setBgImage,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: StreamBuilder<String>(
                                  stream: _titleStreamCntrl.stream,
                                  builder: (_, AsyncSnapshot<String> snapshot) {
                                    final int remaining = 140 - (snapshot.data?.length ?? 0);
                                    return RowWith2Texts(
                                      text1: ATStrings.TITLE,
                                      text2: '$remaining remaining',
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: ATTextFormField(
                                  controller: _titleCntrl, maxLines: 1, cursorHeight: 20,
                                  hintText: ATStrings.TITLE_OF_UR_SHOW,
                                  prefixIcon: const SizedBox(width: 12,),
                                  hintStyle: context.textTheme.bodySmall?.copyWith(
                                    color: ATColors.white.withValues(alpha: 0.4),
                                  ),
                                  disableBlueBorder: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(color: ATColors.trsprnt)
                                  ),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: StreamBuilder<String>(
                                  stream: _descStreamCntrl.stream,
                                  builder: (_, AsyncSnapshot<String> snapshot) {
                                    final int remaining = 4000 - (snapshot.data?.length ?? 0);
                                    return RowWith2Texts(
                                      text1: ATStrings.DESCRIPTION,
                                      text2: '$remaining remaining',
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: StatefulBuilder(
                                  builder: (_, void Function(void Function()) setter) {
                                    return CreateProgramSelectionItem(
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
                              ),


                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: RowWith2Texts(text1: ATStrings.COMMUNITY),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: StatefulBuilder(
                                  builder: (_, void Function(void Function()) setter) {
                                    return ATScalingSwitcher(
                                      duration: 300,
                                      child: selectedCommunity == null ? CreateProgramSelectionItem(
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
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: ATRichText(
                                  maxLines: 4,
                                  items: <String, TextStyle>{
                                    ATStrings.ADD_COMMUNITY_DESC: context.textTheme.labelSmall!.copyWith(
                                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                    ),
                                    ATStrings.LEARN_MORE: context.textTheme.labelSmall!
                                  },
                                  textOnTap: (String text){
                                    if(text == ATStrings.LEARN_MORE){}
                                  },
                                ),
                              ),


                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: RowWith2Texts(text1: ATStrings.ADD_CO_HOST, text2: '5 max',),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: BlocSelector<CohostServiceBloc, (List<ATCohost<bool>>, List<ATCohost<bool>>), List<ATCohost<bool>>>(
                                  selector: ((List<ATCohost<bool>>, List<ATCohost<bool>>) state) => state.$2,
                                  builder: (_, List<ATCohost<bool>> selectedCoHosts) { 
                                    final bool coHostExists = selectedCoHosts.any(
                                      (ATCohost<bool> cohost) => cohost.profilePicture != null
                                    );
                                
                                    return ATScalingSwitcher(
                                      duration: 300,
                                      child: coHostExists ? SelectedCoHostsWidget(
                                          onEdit: () => showAvailableCoHostsModal(context),
                                          selectedCohosts: selectedCoHosts,
                                        ) : CreateProgramSelectionItem(
                                          leading: const ATImgLoader(
                                            height: 20, width: 20,
                                            imgPath: ATImgStrings.OUTLINED_SEARCH,
                                          ),
                                          trailing: Flexible(
                                            child: Text(
                                              ATStrings.SEARCH_ND_ADD_COHOSTS_4_SHOW,
                                              style: context.textTheme.bodySmall?.copyWith(
                                                color: ATColors.white.withValues(alpha: 0.4),
                                              ),
                                            ),
                                          ),
                                          onTap: () => showAvailableCoHostsModal(context),
                                        ),
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: Text(
                                  ATStrings.ADD_COHOST_DESC, maxLines: 5,
                                  style: context.textTheme.labelSmall!.copyWith(
                                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                  ),
                                ),
                              ),
                              
                                                    
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: RowWith2Texts(text1: ATStrings.HASHTAGS),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: CreateProgramSelectionItem(
                                  description: '${ATStrings.ADD_HASHTAG}s',
                                  onTap: () => showTrendingHashtagsModal(context),
                                ),
                              ),

                              const SelectedHashtagsRow(margin: EdgeInsets.zero),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: Text(
                                  ATStrings.ADD_HASHTAG_DESC, maxLines: 5,
                                  style: context.textTheme.labelSmall?.copyWith(
                                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                  ),
                                ),
                              ),
                              
                              
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: RowWith2Texts(text1: ATStrings.AUDIENCE_ACCESS),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: StatefulBuilder(
                                  builder: (_, void Function(void Function()) setter) {
                                    return ATScalingSwitcher(
                                      duration: 300,
                                      child: CreateProgramSelectionItem(
                                        description: chooseAudienceAccess,
                                        descStyle: chooseAudienceAccess == ATStrings.SELECT_WHO_CAN_ACCESS_SHOW ? null
                                          : context.textTheme.bodySmall,
                                        onTap: ()async{
                                          //showSelectAudienceAccessForEventsDialog(context);
                                          final String? selectedAccessType = await chooseAudienceAccess4ShowModal(
                                            context: context, initialAccessType: chooseAudienceAccess
                                          );
                                          setter(
                                            (){
                                              if(selectedAccessType == null){
                                                chooseAudienceAccess = ATStrings.SELECT_WHO_CAN_ACCESS_SHOW;
                                              }
                                              else{
                                                chooseAudienceAccess = selectedAccessType;
                                              }
                                            }
                                          );
                                        },
                                      )
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: Text(
                                  ATStrings.PROMPTED_2_SETUP_SUB_PLAN, maxLines: 5,
                                  style: context.textTheme.labelSmall!.copyWith(
                                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                  ),
                                ),
                              ),
                                                    
                              const Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: ATDivider(height: 1.1,),
                              ),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: Text(
                                    ATStrings.MODERATION_TOOLS,
                                    style: context.textTheme.labelSmall?.copyWith(
                                      fontSize: ATFontSizes.size13,
                                    ),
                                  ),
                                ),
                              ),


                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.front_hand_outlined, size: 18,),
                                    const SizedBox(width: 5,),
                                    Text(
                                      ATStrings.HAND_RAISING,
                                      style: context.textTheme.titleLarge?.copyWith(
                                        fontWeight: ATFontWeights.w500
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                                child: StatefulBuilder(
                                  builder: (_, void Function(void Function()) setter) {
                                    return ATScalingSwitcher(
                                      duration: 300,
                                      child: CreateProgramSelectionItem(
                                        description: shouldAllowHandRasing,
                                        descStyle: shouldAllowHandRasing == ATStrings.CHOOSE_2_ALLOW_HAND_RASING ? null
                                          : context.textTheme.bodySmall,
                                        onTap: ()async{
                                          final String? selectedHandRaising = await choose2AllowHandRaisingModal(
                                            context: context, initialHandRaising: shouldAllowHandRasing
                                          );
                                          setter(
                                            (){
                                              if(selectedHandRaising == null){
                                                shouldAllowHandRasing = ATStrings.SELECT_WHO_CAN_ACCESS_SHOW;
                                              }
                                              else{
                                                shouldAllowHandRasing = selectedHandRaising;
                                              }
                                            }
                                          );
                                        },
                                      )
                                    );
                                  }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: ATRichText(
                                  items: <String, TextStyle>{
                                    ATStrings.U_WILL_HAVE_ACCESS_2_MODERATION_TOOLS: context.textTheme.labelSmall!.copyWith(
                                      color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                    ),
                                    ' ${ATStrings.LEARN_MORE}': context.textTheme.labelSmall!
                                  },
                                )
                              ),
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
            child: BlocBuilder<BgImageBloc, (String, Uint8List?)>(
              builder: (_, (String, Uint8List?) selectedImgPath) {
                return ATPlainElevatedBtn(
                  bgColor: ATColors.white,
                  fgColor: ATColors.hex0D0D0D,
                  btnTitle: ATStrings.NEXT,
                  onPressed: selectedImgPath == null ? null : () async{
                    //await showAddCoHostDialog(context);
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
