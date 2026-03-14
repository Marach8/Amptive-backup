import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/communities_modal.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/episodes/cubits/create_episode_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/presentation/widgets/whispers_permision_modal.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/cubits/create_show_cubit.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import '../../../../models/host.dart';
import '../../../../shared/rich_text.dart';

enum ScheduleBtnOnTap { goLive, scheduleEvent }

class CreateEpisodeFormScreen extends StatelessWidget {
  const CreateEpisodeFormScreen({
    super.key,
    required this.showId,
  });
  
  final String showId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<CreateEpisodeCubit>(create: (_) => CreateEpisodeCubit()),
        BlocProvider<UploadImageCubit>(create: (_) => UploadImageCubit()),
        BlocProvider<BlurredHeaderCubit>(create: (_) => BlurredHeaderCubit(),),
        BlocProvider<BgImageCubit>(create: (_) => BgImageCubit()),
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SelectedHashTagsCubit>(
          create: (_) => SelectedHashTagsCubit()),
        //BlocProvider<HostedShowsCubit>.value(value: hostedShowsCubit,),
      ],
      child: _SubWidget(showId: showId),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.showId});
  final String showId;

  @override
  State<_SubWidget> createState() => _CreateShowFormScreenState();
}

class _CreateShowFormScreenState extends State<_SubWidget> {
  final ValueNotifier<(bool?, ScheduleBtnOnTap)> _activateBtn =
      ValueNotifier<(bool?, ScheduleBtnOnTap)>((false, ScheduleBtnOnTap.goLive));

  String whispersDesc = ATStrings.toggleWhispers;

  void _toggleBtnOnTap() {
    final ScheduleBtnOnTap initialOnTap = _activateBtn.value.$2;
    if (initialOnTap == ScheduleBtnOnTap.goLive) {
      _activateBtn.value = (_activateBtn.value.$1, ScheduleBtnOnTap.scheduleEvent);
    } else {
      _activateBtn.value = (_activateBtn.value.$1, ScheduleBtnOnTap.goLive);
    }
  }

  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();

  String selectedDescription = ATStrings.tellListenersAboutYourShow;
  HandRaisingPermission? selectedHandRaisePermission;
  WhispersPermission? selectedWhispersPermission;

  Community? selectedCommunity;
  List<User>? selectedCohosts;
  List<HashTag>? selectedHashtags;
  ProgramAccessTypeSelectionData accessTypeData =
      const ProgramAccessTypeSelectionData();

  @override
  void initState() {
    super.initState();
    _titleCntrl = TextEditingController()
      ..addListener(() => _titleStreamCntrl.add(_titleCntrl.text.trim()));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunitiesCubit>().fetchCommunities();
      context.read<AllUsersCubit>().fetchAllUsers();
      context.read<AllHashtagsCubit>().fetchHashTags();
    });
  }

  @override
  void dispose() {
    _titleCntrl.dispose();
    _titleStreamCntrl.close();
    _descStreamCntrl.close();
    _activateBtn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CohostServiceBloc>().resetBloc();
      context.read<HashtagServiceBloc>().resetBloc();
    });
    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: BlocBuilder<BgImageCubit, (String, Uint8List?)>(
                  builder: (_, (String, Uint8List?) state) {
                return ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 200, sigmaY: 200),
                    child: state.$2 == null
                        ? ATImgLoader(
                            boxFit: BoxFit.fill,
                            imgPath: state.$1,
                          )
                        : Image.memory(state.$2!, fit: BoxFit.fill));
              }),
            ),
            Container(
              color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
              child: NotificationListener<ScrollNotification>(
                onNotification: context
                    .read<BlurredHeaderCubit>()
                    .onScrollNotification,
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
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Padding(
                                    padding: EdgeInsets.only(left: 7),
                                    child: ATXBackBtn()),
                                Text(
                                  ATStrings.createAnEpisode,
                                  style: context.textTheme.bodyMedium,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 15),
                                  child: InkWell(
                                      onTap: _toggleBtnOnTap,
                                      borderRadius:
                                          BorderRadius.circular(30),
                                      child: const ScheduleIcon()),
                                )
                              ],
                            ),
                          )
                        )
                      ),
                    ),
                  ],
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: SelectProgramCoverArt(
                            onImageSelected:
                                context.read<BgImageCubit>().setBgImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StreamBuilder<String>(
                              stream: _titleStreamCntrl.stream,
                              builder: (_, AsyncSnapshot<String> snapshot) {
                                final int remaining =
                                    140 - (snapshot.data?.length ?? 0);
                                return RowWith2Texts(
                                  text1: ATStrings.title,
                                  text2: '$remaining remaining',
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: ATTextFormField(
                            controller: _titleCntrl,
                            maxLines: 1,
                            cursorHeight: 20,
                            hintText: ATStrings.titleOfYourShow,
                            prefixIcon: const SizedBox(
                              width: 12,
                            ),
                            hintStyle: context.textTheme.bodySmall?.copyWith(
                              color: ATColors.white.withValues(alpha: 0.4),
                            ),
                            disableBlueBorder: true,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide:
                                    BorderSide(color: ATColors.transparent)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StreamBuilder<String>(
                              stream: _descStreamCntrl.stream,
                              builder: (_, AsyncSnapshot<String> snapshot) {
                                final int remaining =
                                    4000 - (snapshot.data?.length ?? 0);
                                return RowWith2Texts(
                                  text1: ATStrings.description,
                                  text2: '$remaining remaining',
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: StatefulBuilder(builder:
                              (_, void Function(void Function()) setter) {
                            return CreateProgramSelectionItem(
                              description: selectedDescription,
                              descStyle: selectedDescription == 
                                ATStrings.tellListenersAboutYourShow ? null :
                                  context.textTheme.bodySmall,
                              onTap: () async {
                                final String? enteredDescription =
                                    await enterDescriptionModal(
                                  context: context,
                                  initialDesc: selectedDescription ==
                                          ATStrings.tellListenersAboutYourShow
                                      ? null
                                      : selectedDescription,
                                );
                                if ((enteredDescription ?? '').isNotEmpty) {
                                  setter(() {
                                    selectedDescription = enteredDescription!;
                                    _descStreamCntrl.add(enteredDescription);
                                  });
                                }
                              },
                            );
                          }),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(text1: ATStrings.COMMUNITY),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StatefulBuilder(builder:
                              (_, void Function(void Function()) setter) {
                            return ATScalingSwitcher(
                                duration: 300,
                                child: selectedCommunity == null
                                    ? CreateProgramSelectionItem(
                                        description: ATStrings
                                            .selectCommunity4YourShow,
                                        onTap: () async {
                                          final Community? selectedCom =
                                              await showCommunitiesModal(
                                            context: context,
                                            communitiesCubit: context
                                                .read<CommunitiesCubit>(),
                                          );
                                          if (selectedCom != null) {
                                            setter(() => selectedCommunity =
                                                selectedCom);
                                          }
                                        },
                                      )
                                    : SelectedCommunityWidget(
                                        selectedCommunity: selectedCommunity!,
                                        onClose: () => setter(
                                            () => selectedCommunity = null),
                                        onView: () {}));
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: ATRichText(
                            maxLines: 4,
                            items: <String, TextStyle>{
                              ATStrings.addCommunityDesc:
                                  context.textTheme.labelSmall!.copyWith(
                                      color: ATColors.hexC2C2C2
                                          .withValues(alpha: 0.76)),
                              ATStrings.learnMore:
                                  context.textTheme.labelSmall!
                            },
                            textOnTap: (String text) {
                              if (text == ATStrings.learnMore) {}
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(
                            text1: ATStrings.addCohost,
                            text2: '5 max',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StatefulBuilder(
                              builder: (_, StateSetter setter) {
                            final bool hasCohosts =
                                (selectedCohosts ?? <User>[]).isNotEmpty;
                            return ATScalingSwitcher(
                              duration: 300,
                              child: hasCohosts
                                  ? SelectedCoHostsWidget(
                                      onEdit: () async {
                                        final List<User>? newCohosts =
                                            await showAvailableCoHostsModal(
                                          context: context,
                                          selectedCoHosts: selectedCohosts,
                                          allUsersCubit: context.read<AllUsersCubit>(),
                                        );
                                        if (newCohosts != null) {
                                          setter(() => selectedCohosts = newCohosts);
                                        }
                                      },
                                      selectedCohosts: selectedCohosts!)
                                  : CreateProgramSelectionItem(
                                      leading: const ATImgLoader(
                                        height: 20,
                                        width: 20,
                                        imgPath: ATImgStrings.outlinedSearch,
                                      ),
                                      trailing: Flexible(
                                        child: Text(
                                          ATStrings.searchAndAddCohost4YourShow,
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                            color: ATColors.white
                                                .withValues(alpha: 0.4),
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        final List<User>? newCohosts =
                                            await showAvailableCoHostsModal(
                                          context: context,
                                          allUsersCubit: context.read<AllUsersCubit>(),
                                        );
                                        if (newCohosts != null) {
                                          setter(() => selectedCohosts = newCohosts);
                                        }
                                      }),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.addCohostDesc,
                            maxLines: 5,
                            style: context.textTheme.labelSmall!.copyWith(
                                color: ATColors.hexC2C2C2
                                    .withValues(alpha: 0.76)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(text1: ATStrings.hashtags),
                        ),
                        StatefulBuilder(
                          builder: (_, StateSetter setter) {
                            return Column(
                              spacing: 10,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: CreateProgramSelectionItem(
                                    description: '${ATStrings.addHashtags}s',
                                    onTap: () async {
                                      final List<HashTag>? newHashTags =
                                          await showNewHashTagsModal(
                                        context: context,
                                        allHashTagsCubit: context.read<AllHashtagsCubit>(),
                                        selectedHashTagsCubit: context.read<SelectedHashTagsCubit>(),
                                      );
                                      if (newHashTags != null) {
                                        setter(() => selectedHashtags = newHashTags);
                                      }
                                    },
                                  ),
                                ),
                                const SelectedHashtagsRow(),
                              ],
                            );
                          }
                        ),
  
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.addHashtagsDesc,
                            maxLines: 5,
                            style: context.textTheme.labelSmall?.copyWith(
                                color: ATColors.hexC2C2C2
                                    .withValues(alpha: 0.76)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(text1: ATStrings.audienceAccess),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StatefulBuilder(
                              builder: (_, StateSetter setter) {
                            final String accessTypeDescText =
                                getAccessTypeDescText(
                                    accessTypeData: accessTypeData);
                            return CreateProgramSelectionItem(
                              description: accessTypeDescText,
                              descStyle: accessTypeDescText ==
                                      ATStrings.selectWhoCanAccessYourShow
                                  ? null
                                  : context.textTheme.bodySmall,
                              onTap: () async {
                                final ProgramAccessTypeSelectionData?
                                    newAccessTypeData =
                                    await showAudienceAccessTypeModal(
                                        context: context,
                                        initialAccessTypeData:
                                            accessTypeData);
                                setter(() {
                                  if (newAccessTypeData != null) {
                                    accessTypeData = newAccessTypeData;
                                  }
                                });
                              },
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.promptToSetupSubPlan,
                            maxLines: 5,
                            style: context.textTheme.labelSmall!.copyWith(
                                color: ATColors.hexC2C2C2
                                    .withValues(alpha: 0.76)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: ATDivider(
                            height: 1.1,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              ATStrings.moderationTools,
                              style: context.textTheme.labelSmall?.copyWith(
                                fontSize: ATSizes.size13,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15, 15, 15, 10),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.front_hand_outlined,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ATStrings.handRaising,
                                  style: context.textTheme.titleLarge
                                      ?.copyWith(fontWeight: ATFontWeights.w500),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StatefulBuilder(
                            builder:(_, StateSetter setter) {
                              String descriptionText = ATStrings.choose2AllowHandRasing;
  
                              if (selectedHandRaisePermission == HandRaisingPermission.allow) {
                                descriptionText = ATStrings.allow;
                              } else if (selectedHandRaisePermission == HandRaisingPermission.dontAllow) {
                                descriptionText = ATStrings.dontAllow;
                              }
  
                              return CreateProgramSelectionItem(
                                description: descriptionText,
                                descStyle: descriptionText ==
                                  ATStrings.choose2AllowHandRasing ? null
                                    : context.textTheme.bodySmall,
                                onTap: () async {
                                  final HandRaisingPermission? newPermission =
                                    await showHandRaisingPermissionModal(
                                      context: context,
                                      initialPermission: selectedHandRaisePermission
                                    );
                                  setter(() => selectedHandRaisePermission = newPermission);
                                },
                              );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: ATRichText(
                            items: <String, TextStyle>{
                              ATStrings.youWillHaveAccessToModerationTools:
                                context.textTheme.labelSmall!.copyWith(
                                  color: ATColors.hexC2C2C2
                                      .withValues(alpha: 0.76)),
                              ' ${ATStrings.learnMore}':
                                  context.textTheme.labelSmall!
                            },
                          )
                        ),
  
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                          child: Row(
                            spacing: 5,
                            children: <Widget>[
                              const Icon(
                                Iconsax.message,
                                size: 18,
                              ),
                              Text(
                                ATStrings.whispers,
                                style: context.textTheme.titleLarge
                                    ?.copyWith(fontWeight: ATFontWeights.w500),
                              ),
                            ],
                          )
                        ),
  
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: StatefulBuilder(
                            builder:(_, StateSetter setter) {
                              String descriptionText = ATStrings.choose2AllowWhispers;
  
                              if (selectedWhispersPermission == WhispersPermission.allow) {
                                descriptionText = ATStrings.turnedOn;
                              } else if (selectedWhispersPermission == WhispersPermission.dontAllow) {
                                descriptionText = ATStrings.turnedOff;
                              }
  
                              return CreateProgramSelectionItem(
                                description: descriptionText,
                                descStyle: descriptionText ==
                                  ATStrings.choose2AllowWhispers ? null
                                    : context.textTheme.bodySmall,
                                onTap: () async {
                                  final WhispersPermission? newPermission =
                                    await showWhispersPermissionModal(
                                      context: context,
                                      initialPermission: selectedWhispersPermission
                                    );
                                  setter(() => selectedWhispersPermission = newPermission);
                                },
                              );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                          child: Text(
                            ATStrings.whispersDesc,
                            maxLines: 3,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: ATColors.hexC2C2C2
                                  .withValues(alpha: 0.76)
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.nonAttendeesEncouragedToJoin,
                            maxLines: 3,
                            style: context.textTheme.labelSmall?.copyWith(
                              color: ATColors.hexC2C2C2
                                  .withValues(alpha: 0.76)
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: MultiBlocListener(
        listeners: <SingleChildWidget>[
          BlocListener<BgImageCubit, (String, Uint8List?)>(
            listener: (_, (String, Uint8List?) state) {
              if (state.$2 != null) {
                _activateBtn.value = (true, _activateBtn.value.$2);
              } else {
                _activateBtn.value = (false, _activateBtn.value.$2);
              }
            },
          ),
          BlocListener<UploadImageCubit, ATAppState<String>>(
            listener: (_, ATAppState<String> state) {
              if (state is SuccessState<String>) {
                //If we upload image successfully, create the episode.
                context.read<CreateEpisodeCubit>().createEpisode(
                  showId: widget.showId,
                  episodeData: CreateEpisodePayload(
                    tagIds: (selectedHashtags ?? <HashTag>[])
                      .map((HashTag tag) => tag.id ?? '')
                      .toList(),
                    coHostIds: (selectedCohosts ?? <User>[])
                      .map((User cohost) => cohost.id ?? '')
                      .toList(),
                    title: _titleCntrl.text.trim(),
                    description: selectedDescription,
                    thumbnailUrl: state.newData!,
                    communityId: selectedCommunity?.communityId ?? '',
                    category: 'Category',
                    showTypeOverride: accessTypeData.accessType 
                      == ProgramAccessType.free ? 'free' : 'paid',
                    priceOverride: accessTypeData.subscriptionAmount 
                      ?? accessTypeData.oneTimePaymentAmount ?? 0.01,
                    allowHandRaising: selectedHandRaisePermission == HandRaisingPermission.allow,
                    allowWhispers: whispersDesc == ATStrings.turnedOn,
                    // scheduledFor: '',
                  ),
                );
              } else if (state is FailureState<String>) {
                //if uploading cover art fails, stop loading and show notif
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
                _activateBtn.value = (true, _activateBtn.value.$2);
              }
            },
          ),
          BlocListener<CreateEpisodeCubit, ATAppState<Episode>>(
            listener: (_, ATAppState<Episode> state) async{
              if (state is SuccessState<Episode>) {
                //context.read<HostedShowsCubit>().addNewHostedShow(state.newData);
                _activateBtn.value = (true, _activateBtn.value.$2);
                final dynamic params = ProgramCreationSuccessScreenParams(
                    coverArtBytes: context.read<BgImageCubit>().state.$2!,
                    title: ATStrings.episodeCreated,
                    subtitle: ATStrings.shareEpisodeLinkDescription,
                    btnTitle: ATStrings.shareEpisode,
                    txtBtnTitle: ATStrings.viewEpisode,
                    topLogo: Container(
                      height: 40, width: 40,
                      decoration: BoxDecoration(
                        color: ATColors.white,
                        borderRadius: BorderRadius.circular(22.5),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            ATColors.black, BlendMode.srcATop),
                        child: const ATImgLoader(
                          imgPath: ATImgStrings.calenderIcon,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    )
                  );
    
                  final ButtonPressed? onPressedResult = await context.pushNamed(
                    ATRoutes.programCreationSuccessScreen,
                    extra: params
                  ) as ButtonPressed?;
    
                  // if(context.mounted){
                  //   if(onPressedResult == ButtonPressed.elevatedBtn){
                  //     context.pushReplacementNamed(
                  //       ATRoutes.createEpisodeForm);
                  //   } else if(onPressedResult == ButtonPressed.textBtn){
                  //     context.pushReplacementNamed(
                  //       ATRoutes.showPreviewScreen,
                  //       extra: state.newData
                  //     );
                  //   }
                  // }
              } 
              else if (state is FailureState<Episode>) {
                _activateBtn.value = (true, _activateBtn.value.$2);
                showAppNotification2(
                  context: context,
                  text: state.message,
                  type: NotificationType.failure,
                );
              }
            },
          )
        ],
        child: ValueListenableBuilder<(bool?, ScheduleBtnOnTap)>(
            valueListenable: _activateBtn,
            builder: (_, (bool?, ScheduleBtnOnTap) value, __) {
              final bool shouldGoToGoLive = _activateBtn.value.$2 == ScheduleBtnOnTap.goLive;
    
              //null for loading, false for disabled, true for enabled for the bool.
              return ATBlurredBgBtn(
                isLoading: value.$1 == null,
                onPressed: value.$1 == false ? null : () {
                  String errorMessage = '';
                  if (_titleCntrl.text.trim().isEmpty) {
                    errorMessage = 'Please enter a title';
                  } else if (selectedDescription == 
                    ATStrings.tellListenersAboutYourShow) {
                    errorMessage = 'Please enter a description';
                  } else if(selectedCommunity == null) {
                    errorMessage = 'Please select a community';
                  } else if((selectedCohosts ?? <User>[]).isEmpty) {
                    errorMessage = 'Please select at least 1 cohost';
                  } else if((selectedHashtags ?? <HashTag>[]).isEmpty) {
                    errorMessage = 'Please select at least 1 hashtag';
                  } else if(selectedHandRaisePermission == null) {
                    errorMessage = 'Please choose whether to allow hand-raising for this episode';
                  } else if(accessTypeData.accessType == null) {
                    errorMessage = 'Please choose whether this episode is free or paid';
                  }
                  else if(selectedWhispersPermission == null) {
                    errorMessage = 'Please choose whether to allow whispers for this episode';
                  }
    
                  if(errorMessage.isNotEmpty){
                    showAppNotification2(
                      context: context,
                      text: errorMessage,
                      type: NotificationType.failure,
                    );
                    return;
                  }
    
                  //Start loading on button press.
                  _activateBtn.value = (null, _activateBtn.value.$2);
                  //Try to upload the cover image.
                  context.read<UploadImageCubit>().uploadBytesImage(
                    bytes: context.read<BgImageCubit>().state.$2!,
                    purpose: 'cover-art',
                  );
                },
                btnTitle: shouldGoToGoLive ? ATStrings.goLive 
                  : '${ATStrings.schedule} episode',
              );
            }
          )
        ),
      ),
    );
  }
}
