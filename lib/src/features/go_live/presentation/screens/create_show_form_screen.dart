import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/auth/cubits/communities_cubit.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/auth/data/models/response/communities_response_model.dart';
import 'package:amptive/src/features/go_live/cubits/create_show_cubit.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/host.dart';
import '../../../../shared/rich_text.dart';
import '../../../../config/utils/dialogs/add_communities_dialog.dart';


class CreateShowFormScreen extends StatelessWidget {
  const CreateShowFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<CreateShowCubit>(create: (_) => CreateShowCubit()),
        BlocProvider<UploadImageCubit>(create: (_) => UploadImageCubit()),
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc(),),
        BlocProvider<BgImageCubit>(create: (_) => BgImageCubit())
      ],
      child: const _SubWidget(),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();

  //Null for loading, false for disabled, true for enabled. All for the launch show button.
  final ValueNotifier<bool?> _launchShowNotifier = ValueNotifier<bool?>(false);

  String selectedDescription = ATStrings.tellListenersAboutYourShow;
  String chooseAudienceAccess = ATStrings.selectWhoCanAccessYourShow;
  String shouldAllowHandRasing = ATStrings.choose2AllowHandRasing;

  Community? selectedCommunity;

  @override 
  void initState(){
    super.initState();
    _titleCntrl = TextEditingController()..addListener(
      () => _titleStreamCntrl.add(_titleCntrl.text.trim())
    );
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        context.read<CommunitiesCubit>().fetchCommunities();
      }
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        context.read<CohostServiceBloc>().resetBloc();
        context.read<HashtagServiceBloc>().resetBloc();
      }
    );
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext blocContext) {
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: BlocBuilder<BgImageCubit, (String, Uint8List?)>(
                      builder: (_, (String, Uint8List?) state) {
                        return state.$2 == null ? ATImgLoader(
                          boxFit: BoxFit.fill,
                          imgPath: state.$1,
                        ) : Image.memory(state.$2!, fit: BoxFit.fill);
                      }
                    ),
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
                            maxExt: blurredHeaderHeight,
                            minExt: blurredHeaderHeight,
                            child: SizedBox(
                              height: blurredHeaderHeight,
                              child: ATBlurredHeaderWidget(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: ATRoundedBackBtn(bgColor: ATColors.transparent,),
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
                                onImageSelected: blocContext.read<BgImageCubit>().setBgImage,
                              ),
                            ),
    
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: StreamBuilder<String>(
                                stream: _titleStreamCntrl.stream,
                                builder: (_, AsyncSnapshot<String> snapshot) {
                                  final int remaining = 140 - (snapshot.data?.length ?? 0);
                                  return RowWith2Texts(
                                    text1: ATStrings.title,
                                    text2: '$remaining remaining',
                                  );
                                }
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                              child: ATTextFormField(
                                controller: _titleCntrl,
                                maxLines: 1, cursorHeight: 20,
                                hintText: ATStrings.TITLE_OF_UR_SHOW,
                                prefixIcon: const SizedBox(width: 12,),
                                hintStyle: context.textTheme.bodySmall?.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.4),
                                ),
                                disableBlueBorder: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(color: ATColors.transparent)
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
                                    text1: ATStrings.description,
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
                                    description: selectedDescription,
                                    onTap: ()async{
                                      final String? enteredDescription = await enterDescriptionModal(
                                        context: context, 
                                        initialDesc: selectedDescription == ATStrings.tellListenersAboutYourShow 
                                          ? null : selectedDescription,
                                      );
                                      if((enteredDescription ?? '').isNotEmpty){
                                        setter(
                                          (){
                                            selectedDescription = enteredDescription!;
                                            _descStreamCntrl.add(enteredDescription);
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
                                      description: ATStrings.selectCommunity4YourShow,
                                      onTap: ()async{
                                        final Community? selectedCom = await showCommunitiesModal(
                                          context: context,
                                          communitiesCubit: context.read<CommunitiesCubit>(),
                                        );
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
                                  ATStrings.addCommunityDesc: context.textTheme.labelSmall!.copyWith(
                                    color: ATColors.hexC2C2C2.withValues(alpha: 0.76)
                                  ),
                                  ATStrings.learnMore: context.textTheme.labelSmall!
                                },
                                textOnTap: (String text){
                                  if(text == ATStrings.learnMore){}
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
                                        onEdit: () => showAvailableCoHostsModal(context: context),
                                        selectedCohosts: selectedCoHosts,
                                      ) : CreateProgramSelectionItem(
                                        leading: const ATImgLoader(
                                          height: 20, width: 20,
                                          imgPath: ATImgStrings.outlinedSearch,
                                        ),
                                        trailing: Flexible(
                                          child: Text(
                                            ATStrings.SEARCH_ND_ADD_COHOSTS_4_SHOW,
                                            style: context.textTheme.bodySmall?.copyWith(
                                              color: ATColors.white.withValues(alpha: 0.4),
                                            ),
                                          ),
                                        ),
                                        onTap: () => showAvailableCoHostsModal(context: context),
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
                                      descStyle: chooseAudienceAccess == ATStrings.selectWhoCanAccessYourShow ? null
                                        : context.textTheme.bodySmall,
                                      onTap: ()async{
                                        // context.read<SubPlanSetupBloc>().selectAFee(1000);
                                        // context.read<SubPlanSetupBloc>().setSelectedFee(1000);
    
                                        final String? selectedAccessType = await chooseAudienceAccess4ShowModal(
                                          context: context, initialAccessType: chooseAudienceAccess
                                        );
                                        setter(
                                          (){
                                            if(selectedAccessType == null){
                                              chooseAudienceAccess = ATStrings.selectWhoCanAccessYourShow;
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
                                    fontSize: ATSizes.size13,
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
                                    ATStrings.handRaising,
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
                                      descStyle: shouldAllowHandRasing == ATStrings.choose2AllowHandRasing ? null
                                        : context.textTheme.bodySmall,
                                      onTap: ()async{
                                        final String? selectedHandRaising = await choose2AllowHandRaisingModal(
                                          context: context, initialHandRaising: shouldAllowHandRasing
                                        );
                                        setter(
                                          (){
                                            if(selectedHandRaising == null){
                                              shouldAllowHandRasing = ATStrings.selectWhoCanAccessYourShow;
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
                                  ' ${ATStrings.learnMore}': context.textTheme.labelSmall!
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
    
        bottomSheet: MultiBlocListener(
          listeners: <SingleChildWidget>[
            BlocListener<BgImageCubit, (String, Uint8List?)>(
              listener: (_, (String, Uint8List?) state) {
                if(state.$2 != null){
                  _launchShowNotifier.value = true;
                }
                else{
                  _launchShowNotifier.value = false;
                }
              },
            ),
            BlocListener<UploadImageCubit, ATAppState<String>>(
              listener: (_, ATAppState<String> state) {
                if(state is SuccessState<String>){
                  context.read<CreateShowCubit>().createShow(
                    tagIds: <String>[const Uuid().v4(), const Uuid().v4()],
                    coHostIds: <String>[const Uuid().v4(), const Uuid().v4()],
                    title: _titleCntrl.text.trim(),
                    description: selectedDescription,
                    coverUrl: state.newData!,
                    category: 'Category',
                    showType: 'free',
                    price: 20,
                  );
                }
                else if(state is FailureState<String>){
                  //if uploading coverart fails, stop loading and show notif
                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                  _launchShowNotifier.value = true;
                }
              },
            ),
            BlocListener<CreateShowCubit, ATAppState<dynamic>>(
              listener: (_, ATAppState<dynamic> state) {
                if(state is SuccessState<dynamic>){
                  _launchShowNotifier.value = true;
                  showAppNotification2(
                    context: context,
                    text: 'Show created successfully',
                    type: NotificationType.success,
                  );
                }
                else if(state is FailureState<dynamic>){
                  _launchShowNotifier.value = true;
                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                }
              },
            )
          ],
          child: ValueListenableBuilder<bool?>(
            valueListenable: _launchShowNotifier,
            builder: (_, bool? value, __) {
              return ATBlurredBgBtn(
                isLoading: value == null,
                onPressed: value == false ? null : (){
                  //Start loading on button press.
                  _launchShowNotifier.value = null;
                  //Try to upload the cover image.
                  context.read<UploadImageCubit>().uploadBytesImage(
                    bytes: context.read<BgImageCubit>().state.$2!,
                    purpose: 'cover-art',
                  );
                  // final dynamic params = (
                  //   coverArtBytes: state.$2,
                  //   title: ATStrings.SHOW_IS_SETUP,
                  //   subtitle: ATStrings.BEGIN_JOURNEY,
                  //   btnTitle: ATStrings.CREATE_1ST_EPISODE,
                  //   txtBtnTitle: ATStrings.VIEW_SHOW_PAGE,
                  //   btnOnPressed: () => context.pushReplacementNamed(ATRoutes.CREATE_EPISODE_FORM),
                  //   txtBtnOnPressed: () {
                  //     // handle text button press
                  //   },
                  //   topLogo: const Icon(Icons.check_circle_sharp, size: 45),
                  // );
                  
                  // context.pushNamed(
                  //   ATRoutes.GO_LIVE_PROGRAM_CREATION_SUCCESS,
                  //   extra: params
                  // );
                },
                btnTitle: ATStrings.LAUNCH_SHOW,
              );
            }
          )
        ),
      ),
    );
  }
}
