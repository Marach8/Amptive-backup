import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dialogs/communities_modal.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/episodes/cubits/create_episode_cubit.dart';
import 'package:amptive/src/features/episodes/cubits/episodes_of_a_show_cubit.dart';
import 'package:amptive/src/features/episodes/cubits/start_episode_cubit.dart';
import 'package:amptive/src/features/episodes/data/models/request/create_episode_request_model.dart';
import 'package:amptive/src/features/episodes/data/models/response/episode_model.dart';
import 'package:amptive/src/features/episodes/presentation/widgets/whispers_permision_modal.dart';
import 'package:amptive/src/features/events/presentation/screens/select_schedule_date_screen.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/go_live/presentation/screens/live_program_screen.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/after_route_transition.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/smooth_text_field.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/prepared_cover_art.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/program_form_mesh_background.dart';
import '../../../../shared/rich_text.dart';

enum ScheduleBtnOnTap { goLive, scheduleEvent }

class CreateEpisodeFormScreen extends StatelessWidget {
  const CreateEpisodeFormScreen({
    super.key,
    required this.showData,
  });
  
  final HostedShow showData;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<CreateEpisodeCubit>(create: (_) => CreateEpisodeCubit()),
        BlocProvider<BlurredHeaderCubit>(create: (_) => BlurredHeaderCubit(),),
        BlocProvider<BgImageCubit>(
            create: (_) => BgImageCubit(initialImage: showData.coverUrl ?? PreparedCoverArt.path)),
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SelectedHashTagsCubit>(create: (_) => SelectedHashTagsCubit(initialHashtags: showData.tags)),
        BlocProvider<StartLiveProgramCubit>(create: (_) => StartLiveProgramCubit()),
      ],
      child: _SubWidget(showData: showData),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.showData});
  final HostedShow showData;

  @override
  State<_SubWidget> createState() => _CreateShowFormScreenState();
}

class _CreateShowFormScreenState extends State<_SubWidget> {
  final ValueNotifier<(bool?, ScheduleBtnOnTap)> _activateBtn =
      ValueNotifier<(bool?, ScheduleBtnOnTap)>((true, ScheduleBtnOnTap.goLive));

  String whispersDesc = ATStrings.toggleWhispers;

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
  DateTime? _scheduleDate;

  @override
  void initState() {
    super.initState();
    final HostedShow show = widget.showData;

    selectedCommunity = show.community;
    selectedHashtags = show.tags;

    if (show.coHosts != null && show.coHosts!.isNotEmpty) {
      selectedCohosts = show.coHosts!.map((CoHost c) => User(
        userId: c.userId,
        username: c.username,
        profilePicture: c.profilePicture,
        firstName: c.firstName,
        lastName: c.lastName,
        name: c.name,
      )).toList();
    }

    if (show.showType != null) {
      if (show.showType!.toLowerCase() == 'free') {
        accessTypeData = const ProgramAccessTypeSelectionData(
          accessType: ProgramAccessType.free,
        );
      } else {
        accessTypeData = ProgramAccessTypeSelectionData(
          accessType: ProgramAccessType.paid,
          subscriptionAmount: show.price,
        );
      }
    }

    _titleCntrl = TextEditingController()
      ..addListener(() => _titleStreamCntrl.add(_titleCntrl.text.trim()));
    // These lists feed the community/cohost/hashtag pickers, which the user
    // can't reach for at least a second — fetching them during the page
    // transition janks the slide, so wait until it settles.
    runAfterRouteTransition(context, () {
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

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: ProgramFormMeshBackground(
          child: NotificationListener<ScrollNotification>(
                onNotification: context
                    .read<BlurredHeaderCubit>()
                    .onScrollNotification,
                child: NestedScrollView(
                  key: const PageStorageKey<String>('create_episode_form'),
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
                                    padding: const EdgeInsets.only(right: 3),
                                    child: InkWell(
                                      onTap: ()async{
                                        // The calendar always opens the picker
                                        // (pre-filled with any current pick).
                                        final ScheduleDateResult? result = await context.pushNamed(
                                            ATRoutes.selectScheduleDateScreen,
                                            extra: SelectScheduleDataScreenEntryParams(
                                              selectedBgImage: context.read<BgImageCubit>().state.$2,
                                              incomingBgImageUrl: context.read<BgImageCubit>().state.$1,
                                              programName: 'Episode',
                                              incomingDate: _scheduleDate
                                            )
                                          ) as ScheduleDateResult?;
                                        if(result == null) return; // cancelled
                                        if(result.removed){
                                          _scheduleDate = null;
                                          _activateBtn.value = (_activateBtn.value.$1, ScheduleBtnOnTap.goLive);
                                        } else {
                                          _scheduleDate = result.date;
                                          _activateBtn.value = (_activateBtn.value.$1, ScheduleBtnOnTap.scheduleEvent);
                                        }
                                      },
                                      borderRadius:
                                          BorderRadius.circular(30),
                                      child: SizedBox(
                                        width: 44,
                                        height: 44,
                                        child: Center(
                                          child: SvgPicture.string(ATImgStrings.createEpisodeScheduleIconSvg),
                                        ),
                                      )
                                    ),
                                  )
                              ],
                            ),
                          )
                        )
                      ),
                    ),
                  ],
                  body: SingleChildScrollView(
                    key: const PageStorageKey<String>('create_episode_form_body'),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Center(
                            child: ClipSmoothRect(
                              radius: const SmoothBorderRadius.all(
                                SmoothRadius(
                                  cornerRadius: 10,
                                  cornerSmoothing: 0.8,
                                ),
                              ),
                              child: ATImgLoader(
                                imgPath: widget.showData.coverUrl ?? ATImgStrings.createShowPlaceholder,
                                boxFit: BoxFit.cover,
                                height: 160,
                                width: 160,
                              ),
                            ),
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
                                  text2: remaining == 140
                                      ? ''
                                      : '${140 - remaining}/140',
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: ATSmoothTextField(
                            controller: _titleCntrl,
                            hintText: ATStrings.titleOfYourShow,
                            hintSuggestions: const <String>[
                              'Episode 1: The Beginning',
                              'Behind the Scenes 🎬',
                              'Listener Questions Answered',
                              'Special Guest Takeover',
                              'The One About Growth 📈',
                            ],
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
                                  text2: remaining == 4000
                                      ? ''
                                      : '${4000 - remaining}/4000',
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
                              isMarkdown: selectedDescription != ATStrings.tellListenersAboutYourShow,
                              onTap: () async {
                                final String? enteredDescription =
                                    await enterDescriptionModal(
                                  context: context,
                                  coverImage: widget.showData.coverUrl,
                                  coverBytes: null,
                                  title: 'Episode Description',
                                  hintText: 'Give listeners a preview of this episode',
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
                          child: RowWith2Texts(text1: ATStrings.community),
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
                                        onTap: () {}, // Community cannot be changed on episodes
                                      )
                                    : SelectedCommunityWidget(
                                        selectedCommunity: selectedCommunity!,
                                        onClose: null, // Community cannot be changed on episodes
                                        onView: () => context.pushNamed(
                                            ATRoutes.SOCIETY_SCREEN,
                                            extra: <String, String>{
                                              'communityId':
                                                  selectedCommunity?.communityId ?? '',
                                              'communityName':
                                                  selectedCommunity?.name ?? '',
                                            },
                                          )));
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
                                      leading: ATImgLoader(
                                        height: 20,
                                        width: 20,
                                        imgPath: ATImgStrings.outlinedSearch,
                                        color: ATColors.white.withValues(alpha: 0.6),
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
                                  accessTypeData: accessTypeData,
                                  initialAccessTypeTextDesc: ATStrings.selectWhoCanAccessYourShow
                                );
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
                                  const ATImgLoader(
                                    imgPath: ATImgStrings.handRaising,
                                    height: 18, width: 18,
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
                              } else if (selectedHandRaisePermission
                                == HandRaisingPermission.dontAllow) {
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

        resizeToAvoidBottomInset: false,

        bottomSheet: MultiBlocListener(
          listeners: <SingleChildWidget>[
            BlocListener<StartLiveProgramCubit,
              ATAppState<LiveProgramEntryToken>>(
              listener: (_, ATAppState<LiveProgramEntryToken> state){
                if(state is SuccessState<LiveProgramEntryToken>){
                  _activateBtn.value = (true, _activateBtn.value.$2);

                  final Episode? episode = context
                    .read<CreateEpisodeCubit>().currentEpisodeDetail;
                  context.pushReplacementNamed(
                    ATRoutes.goLiveOnboarding,
                    extra: LiveProgramData(
                      roomEntryToken: state.newData?.roomEntryToken ?? '',
                      roomUrl: state.newData?.roomUrl ?? '',
                      streamId: state.newData?.streamId ?? '',
                      roomParticipantId: state.newData?.roomParticipantId ?? '',
                      programId: episode?.episodeId ?? '',
                      coverUrl: episode?.thumbnailUrl ?? '',
                      role: ParticipantRole.host,
                      programTitle: episode?.title ?? '',
                      programDesc: episode?.description ?? '',
                    ),
                  );
                }
                else if(state is FailureState<LiveProgramEntryToken>){
                  _activateBtn.value = (true, _activateBtn.value.$2);

                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                }
              },
            ),
            BlocListener<CreateEpisodeCubit, ATAppState<Episode>>(
              listener: (_, ATAppState<Episode> state) async{
                if (state is SuccessState<Episode>) {

                  // A new episode was created — drop the cached list so the
                  // scheduled-episodes screen shows it on next open.
                  EpisodesOfAShowCubit.invalidate(widget.showData.showId ?? '');

                  // Never start a livestream for an episode the backend created
                  // as scheduled — base this on the created episode, not the
                  // (possibly stale) button state.
                  final Episode? episode = state.newData;
                  final bool wasScheduled =
                      (episode?.scheduledFor?.trim().isNotEmpty ?? false) ||
                          (episode?.status?.toLowerCase() == 'scheduled');
                  final bool shouldStartLive = _activateBtn.value.$2 ==
                          ScheduleBtnOnTap.goLive &&
                      !wasScheduled;
                  if(shouldStartLive){
                    context.read<StartLiveProgramCubit>().startLiveProgram(
                      contentId: episode?.episodeId ?? '',
                    );
                    return;
                  }

                  _activateBtn.value = (true, _activateBtn.value.$2);

                  final dynamic params = ProgramCreationSuccessScreenParams(
                    coverArtBytes: context.read<BgImageCubit>().state.$2,
                    coverArtUrl: context.read<BgImageCubit>().state.$1,
                    title: 'Your Episode is scheduled!',
                    subtitle: 'Share your episode link to build excitement and\n'
                        'attract more attendees.',
                    btnTitle: ATStrings.shareEpisode,
                    txtBtnTitle: ATStrings.viewEpisode,
                    topLogo: const ProgramSuccessCalenderIcon(),
                    // The X closes to the show page this episode belongs to.
                    onClose: () => context.goNamed(
                      ATRoutes.showPreviewScreen,
                      extra: widget.showData,
                    ),
                  );
    
                  final ButtonPressed? onPressedResult = await context.pushNamed(
                    ATRoutes.programCreationSuccessScreen,
                    extra: params
                  ) as ButtonPressed?;
    
                  if(context.mounted){
                    if(onPressedResult == ButtonPressed.elevatedBtn){
                      // context.pushReplacementNamed(
                      //   ATRoutes.createEpisodeForm);
                    } else if(onPressedResult == ButtonPressed.textBtn){
                      context.pushReplacementNamed(
                        ATRoutes.previewEpisodeScreen,
                        extra: state.newData
                      );
                    }
                  }
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
                final bool shouldGoToGoLive = 
                  _activateBtn.value.$2 == ScheduleBtnOnTap.goLive;
      
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
                    } else if(context.read<SelectedHashTagsCubit>().state.isEmpty) {
                      errorMessage = 'Please select at least 1 hashtag';
                    } else if(selectedHandRaisePermission == null) {
                      errorMessage = 'Please choose whether to allow hand-raising for this episode';
                    } else if(accessTypeData.accessType == null) {
                      errorMessage = 'Please choose whether this episode is free or paid';
                    }
                    else if(selectedWhispersPermission == null) {
                      errorMessage = 'Please choose whether to allow whispers for this episode';
                    }
                    final ScheduleBtnOnTap currentOnTap = _activateBtn.value.$2;
                    if(currentOnTap == ScheduleBtnOnTap.scheduleEvent 
                      && _scheduleDate == null){
                      errorMessage = 'Please choose a schedule date/time for this episode';
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
                    
                    context.read<CreateEpisodeCubit>().createEpisode(
                      showId: widget.showData.showId ?? '',
                      episodeData: CreateEpisodePayload(
                        tagIds: context.read<SelectedHashTagsCubit>().state
                          .map((HashTag tag) => tag.id ?? '')
                          .toList(),
                        coHostIds: (selectedCohosts ?? <User>[])
                          .map((User cohost) => cohost.userId ?? '')
                          .toList(),
                        title: _titleCntrl.text.trim(),
                        description: selectedDescription,
                        thumbnailUrl: widget.showData.coverUrl ?? ATImgStrings.createShowPlaceholder,
                        communityId: selectedCommunity?.communityId ?? '',
                        category: selectedCommunity?.name ?? '',
                        showTypeOverride: accessTypeData.accessType
                          == ProgramAccessType.free ? 'free' : 'paid',
                        priceOverride: accessTypeData.accessType == ProgramAccessType.free
                          ? 0.01
                          : (accessTypeData.subscriptionAmount
                            ?? accessTypeData.oneTimePaymentAmount ?? 0.01),
                        allowHandRaising: selectedHandRaisePermission
                          == HandRaisingPermission.allow,
                        allowWhispers: selectedWhispersPermission == WhispersPermission.allow,
                        scheduledFor: _scheduleDate?.toUtc().toIso8601String(),
                      ),
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
