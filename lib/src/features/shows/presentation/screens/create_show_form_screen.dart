import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/discover/data/repository/discover_repo_impl.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/shows/cubits/create_show_cubit.dart';
import 'package:amptive/src/features/shows/cubits/edit_show_cubit.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/after_route_transition.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/smooth_text_field.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/prepared_cover_art.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/program_form_mesh_background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/rich_text.dart';
import '../../../../config/utils/dialogs/communities_modal.dart';

class CreateShowFormScreen extends StatelessWidget {
  const CreateShowFormScreen({
    super.key,
    required this.hostedShowsCubit,
    this.editableShow,
  });
  final HostedShowsCubit hostedShowsCubit;

  /// When provided, the screen runs in edit mode (pre-filled + PATCH) instead
  /// of create mode.
  final HostedShow? editableShow;

  @override
  Widget build(BuildContext context) {
    final bool isEditing = editableShow != null;
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<CreateShowCubit>(create: (_) => CreateShowCubit()),
        BlocProvider<EditShowCubit>(create: (_) => EditShowCubit()),
        BlocProvider<UploadImageCubit>(create: (_) => UploadImageCubit()),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
        ),
        BlocProvider<BgImageCubit>(
            create: (_) => BgImageCubit(
                initialImage: isEditing
                    ? (editableShow!.coverUrl ?? PreparedCoverArt.path)
                    : PreparedCoverArt.path)),
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SelectedHashTagsCubit>(
            create: (_) =>
                SelectedHashTagsCubit(initialHashtags: editableShow?.tags)),
        BlocProvider<HostedShowsCubit>.value(
          value: hostedShowsCubit,
        ),
      ],
      child: _SubWidget(editableShow: editableShow),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({this.editableShow});

  final HostedShow? editableShow;

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();

  //Null for loading, false for disabled, true for enabled.
  final ValueNotifier<bool?> _launchShowBtnNotifier =
      ValueNotifier<bool?>(false);

  String selectedDescription = ATStrings.tellListenersAboutYourShow;
  HandRaisingPermission? selectedPermission;

  Community? selectedCommunity;
  List<User>? selectedCohosts;
  List<HashTag>? selectedHashtags;
  ProgramAccessTypeSelectionData accessTypeData =
      const ProgramAccessTypeSelectionData();

  bool get _isEditing => widget.editableShow != null;

  @override
  void initState() {
    super.initState();
    final HostedShow? show = widget.editableShow;
    _titleCntrl = TextEditingController(text: show?.title ?? '')
      ..addListener(() => _titleStreamCntrl.add(_titleCntrl.text.trim()));

    // Pre-fill everything when editing an existing show.
    if (show != null) {
      _titleStreamCntrl.add(_titleCntrl.text.trim());
      selectedDescription = (show.description?.isNotEmpty ?? false)
          ? show.description!
          : ATStrings.tellListenersAboutYourShow;
      _descStreamCntrl.add(show.description ?? '');
      selectedCommunity = show.community;
      selectedCohosts = show.coHosts;
      selectedHashtags = show.tags;
      // Pre-fill the hand-raising choice from the show so the host doesn't
      // have to re-confirm it on every edit.
      if (show.handRaising != null) {
        selectedPermission = show.handRaising!
            ? HandRaisingPermission.allow
            : HandRaisingPermission.dontAllow;
      }
      accessTypeData = ProgramAccessTypeSelectionData(
        accessType: show.showType == 'free'
            ? ProgramAccessType.free
            : ProgramAccessType.paid,
        subscriptionAmount: show.price ?? 0.01,
      );
      // The existing cover is already set, so the Save button is enabled.
      _launchShowBtnNotifier.value = true;
    }

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
    _launchShowBtnNotifier.dispose();
    _descStreamCntrl.close();
    super.dispose();
  }

  /// Creates any freshly-typed ("new_…") hashtags on the server and swaps in
  /// their real ids, so the show is never submitted with a placeholder tag id
  /// (which crashes the API with a 500).
  Future<void> _resolvePendingHashtags() async {
    final SelectedHashTagsCubit cubit = context.read<SelectedHashTagsCubit>();
    final List<HashTag> pending = cubit.state
        .where((HashTag t) => (t.id ?? '').startsWith('new_'))
        .toList();
    for (final HashTag tag in pending) {
      final ApiResponse<HashTag> res = await DiscoverRepoImpl().createHashtag(
        name: tag.name ?? '',
        displayName: tag.displayName ?? tag.name ?? '',
      );
      res.when(
        successful: (Successful<HashTag> data) {
          final HashTag? created = data.data;
          if (created != null &&
              (created.id?.isNotEmpty ?? false) &&
              !created.id!.startsWith('new_')) {
            cubit.replaceHashtag(tag, created);
          } else {
            cubit.removeHashtag(tag);
          }
        },
        unSuccessful: (Unsuccessful<HashTag> _) => cubit.removeHashtag(tag),
      );
    }
    // Mirror the resolved list back to the form.
    selectedHashtags = List<HashTag>.from(cubit.state);
  }

  /// Create or edit the show with the resolved [coverUrl].
  void _submitShow(String coverUrl) {
    // Read from the cubit (the source of truth) and drop any tag whose id is
    // still a placeholder, so only valid ids ever reach the API.
    final List<String> tagIds = context
        .read<SelectedHashTagsCubit>()
        .state
        .map((HashTag tag) => tag.id ?? '')
        .where((String id) => id.isNotEmpty && !id.startsWith('new_'))
        .toList();
    final List<String> coHostIds = (selectedCohosts ?? <User>[])
        .map((User cohost) => cohost.userId ?? '')
        .toList();
    final String showType =
        accessTypeData.accessType == ProgramAccessType.free ? 'free' : 'paid';
    final double price = accessTypeData.accessType == ProgramAccessType.free
        ? 0.01
        : (accessTypeData.subscriptionAmount ??
            accessTypeData.oneTimePaymentAmount ??
            0.01);
    final bool allowHandRaising =
        selectedPermission == HandRaisingPermission.allow;

    if (_isEditing) {
      context.read<EditShowCubit>().editShow(
            showId: widget.editableShow?.showId ?? '',
            tagIds: tagIds,
            coHostIds: coHostIds,
            title: _titleCntrl.text.trim(),
            description: selectedDescription,
            coverUrl: coverUrl,
            communityId: selectedCommunity?.communityId ?? '',
            category: selectedCommunity?.name ?? '',
            showType: showType,
            price: price,
            allowHandRaising: allowHandRaising,
          );
    } else {
      context.read<CreateShowCubit>().createShow(
            tagIds: tagIds,
            coHostIds: coHostIds,
            title: _titleCntrl.text.trim(),
            description: selectedDescription,
            coverUrl: coverUrl,
            communityId: selectedCommunity?.communityId ?? '',
            category: selectedCommunity?.name ?? '',
            showType: showType,
            price: price,
            allowHandRaising: allowHandRaising,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext blocContext) {
            return ProgramFormMeshBackground(
              child: NotificationListener<ScrollNotification>(
                onNotification:
                    blocContext.read<BlurredHeaderCubit>().onScrollNotification,
                child: NestedScrollView(
                  key: const PageStorageKey<String>('create_show_form'),
                  headerSliverBuilder: (_, __) => <Widget>[
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: ATSliverHDelegate(
                          maxExt: blurredHeaderHeight,
                          minExt: blurredHeaderHeight,
                          child: SizedBox(
                              height: blurredHeaderHeight,
                              child: ATBlurredHeaderWidget(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: ATBackBtn(),
                                      ),
                                    ),
                                    Text(
                                      _isEditing
                                          ? 'Edit your Show'
                                          : 'Create your Show',
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ))),
                    ),
                  ],
                  body: SingleChildScrollView(
                    key: const PageStorageKey<String>('create_show_form_body'),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 100),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: SelectProgramCoverArt(
                            initialImage: widget.editableShow?.coverUrl,
                            onImageSelected:
                                blocContext.read<BgImageCubit>().setBgImage,
                            onImageUrlSelected:
                                blocContext.read<BgImageCubit>().setBgImageUrl,
                            onImageAndUrlSelected: blocContext
                                .read<BgImageCubit>()
                                .setBgImageAndUrl,
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
                              'The Morning Grind ☕',
                              'Real Talk, No Filter',
                              'Late Night Vibes 🎙️',
                              'Founders on the Record',
                              'Sunday Slow Jams',
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
                                      ATStrings.tellListenersAboutYourShow
                                  ? null
                                  : context.textTheme.bodySmall,
                              isMarkdown: selectedDescription !=
                                  ATStrings.tellListenersAboutYourShow,
                              onTap: () async {
                                final String? enteredDescription =
                                    await enterDescriptionModal(
                                  context: context,
                                  coverImage:
                                      context.read<BgImageCubit>().state.$1,
                                  coverBytes:
                                      context.read<BgImageCubit>().state.$2,
                                  title: 'Show Description',
                                  hintText:
                                      'Tell your listeners what your show is about',
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
                            return ATSmoothSwitcher(
                                duration: 260,
                                child: selectedCommunity == null
                                    ? CreateProgramSelectionItem(
                                        description:
                                            ATStrings.selectCommunity4YourShow,
                                        onTap: () async {
                                          final Community? selectedCom =
                                              await showCommunitiesModal(
                                            context: context,
                                            communitiesCubit: context
                                                .read<CommunitiesCubit>(),
                                          );
                                          log('selectedCom id: ${selectedCom?.communityId}');
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
                                        onView: () => context.pushNamed(
                                              ATRoutes.SOCIETY_SCREEN,
                                              extra: <String, String>{
                                                'communityId': selectedCommunity
                                                        ?.communityId ??
                                                    '',
                                                'communityName':
                                                    selectedCommunity?.name ??
                                                        '',
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
                              ATStrings.learnMore: context.textTheme.labelSmall!
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
                          child:
                              StatefulBuilder(builder: (_, StateSetter setter) {
                            final bool hasCohosts =
                                (selectedCohosts ?? <User>[]).isNotEmpty;
                            return ATSmoothSwitcher(
                              duration: 260,
                              child: hasCohosts
                                  ? SelectedCoHostsWidget(
                                      onEdit: () async {
                                        final List<User>? newCohosts =
                                            await showAvailableCoHostsModal(
                                          context: context,
                                          selectedCoHosts: selectedCohosts,
                                          allUsersCubit:
                                              context.read<AllUsersCubit>(),
                                        );
                                        if (newCohosts != null) {
                                          setter(() =>
                                              selectedCohosts = newCohosts);
                                        }
                                      },
                                      selectedCohosts: selectedCohosts!)
                                  : CreateProgramSelectionItem(
                                      leading: ATImgLoader(
                                        height: 20,
                                        width: 20,
                                        imgPath: ATImgStrings.outlinedSearch,
                                        color: ATColors.white
                                            .withValues(alpha: 0.6),
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
                                          allUsersCubit:
                                              context.read<AllUsersCubit>(),
                                        );
                                        if (newCohosts != null) {
                                          setter(() =>
                                              selectedCohosts = newCohosts);
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
                                color:
                                    ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(text1: ATStrings.hashtags),
                        ),
                        StatefulBuilder(builder: (_, StateSetter setter) {
                          return Column(
                            spacing: 10,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: CreateProgramSelectionItem(
                                  description: '${ATStrings.addHashtags}s',
                                  onTap: () async {
                                    final List<HashTag>? newHashTags =
                                        await showNewHashTagsModal(
                                      context: context,
                                      allHashTagsCubit:
                                          context.read<AllHashtagsCubit>(),
                                      selectedHashTagsCubit:
                                          context.read<SelectedHashTagsCubit>(),
                                    );
                                    if (newHashTags != null) {
                                      setter(
                                          () => selectedHashtags = newHashTags);
                                    }
                                  },
                                ),
                              ),
                              const SelectedHashtagsRow(),
                            ],
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.addHashtagsDesc,
                            maxLines: 5,
                            style: context.textTheme.labelSmall?.copyWith(
                                color:
                                    ATColors.hexC2C2C2.withValues(alpha: 0.76)),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child: RowWith2Texts(text1: ATStrings.audienceAccess),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child:
                              StatefulBuilder(builder: (_, StateSetter setter) {
                            final String accessTypeDescText =
                                getAccessTypeDescText(
                              accessTypeData: accessTypeData,
                              initialAccessTypeTextDesc:
                                  ATStrings.selectWhoCanAccessYourShow,
                            );
                            return ATScalingSwitcher(
                                duration: 300,
                                child: CreateProgramSelectionItem(
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
                                ));
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                          child: Text(
                            ATStrings.promptToSetupSubPlan,
                            maxLines: 5,
                            style: context.textTheme.labelSmall!.copyWith(
                                color:
                                    ATColors.hexC2C2C2.withValues(alpha: 0.76)),
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
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Text(
                              ATStrings.moderationTools,
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
                                const ATImgLoader(
                                  imgPath: ATImgStrings.handRaising,
                                  height: 18,
                                  width: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ATStrings.handRaising,
                                  style: context.textTheme.titleLarge?.copyWith(
                                      fontWeight: ATFontWeights.w500),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                          child:
                              StatefulBuilder(builder: (_, StateSetter setter) {
                            String descriptionText =
                                ATStrings.choose2AllowHandRasing;

                            if (selectedPermission ==
                                HandRaisingPermission.allow) {
                              descriptionText = ATStrings.allow;
                            } else if (selectedPermission ==
                                HandRaisingPermission.dontAllow) {
                              descriptionText = ATStrings.dontAllow;
                            }

                            return ATScalingSwitcher(
                                duration: 300,
                                child: CreateProgramSelectionItem(
                                  description: descriptionText,
                                  descStyle: descriptionText ==
                                          ATStrings.choose2AllowHandRasing
                                      ? null
                                      : context.textTheme.bodySmall,
                                  onTap: () async {
                                    final HandRaisingPermission? newPermission =
                                        await showHandRaisingPermissionModal(
                                            context: context,
                                            initialPermission:
                                                selectedPermission);
                                    setter(() =>
                                        selectedPermission = newPermission);
                                  },
                                ));
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
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: MultiBlocListener(
            listeners: <SingleChildWidget>[
              BlocListener<BgImageCubit, (String, Uint8List?)>(
                listener: (_, (String, Uint8List?) state) {
                  if (state.$2 != null) {
                    _launchShowBtnNotifier.value = true;
                  } else {
                    _launchShowBtnNotifier.value = false;
                  }
                },
              ),
              BlocListener<UploadImageCubit, ATAppState<String>>(
                listener: (_, ATAppState<String> state) {
                  if (state is SuccessState<String>) {
                    // Cover uploaded — create or edit with the new URL.
                    _submitShow(state.newData!);
                  } else if (state is FailureState<String>) {
                    //if uploading cover art fails, stop loading and show notif
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                    _launchShowBtnNotifier.value = true;
                  }
                },
              ),
              BlocListener<CreateShowCubit, ATAppState<HostedShow>>(
                listener: (_, ATAppState<HostedShow> state) async {
                  if (state is SuccessState<HostedShow>) {
                    context
                        .read<HostedShowsCubit>()
                        .addNewHostedShow(state.newData);
                    _launchShowBtnNotifier.value = true;

                    final dynamic params = ProgramCreationSuccessScreenParams(
                      coverArtBytes: context.read<BgImageCubit>().state.$2,
                      coverArtUrl: context.read<BgImageCubit>().state.$1,
                      title: ATStrings.showIsSetup,
                      subtitle: ATStrings.beginYourJourney,
                      btnTitle: ATStrings.createFirstEpisode,
                      txtBtnTitle: ATStrings.viewShowPage,
                      topLogo: SvgPicture.string(
                        '''<svg width="45" height="45" viewBox="0 0 45 45" fill="none" xmlns="http://www.w3.org/2000/svg">
<path fill-rule="evenodd" clip-rule="evenodd" d="M22.5 41.25C32.8553 41.25 41.25 32.8553 41.25 22.5C41.25 12.1447 32.8553 3.75 22.5 3.75C12.1447 3.75 3.75 12.1447 3.75 22.5C3.75 32.8553 12.1447 41.25 22.5 41.25ZM18.7525 28.9084C19.1925 29.3791 19.8862 29.4706 20.4241 29.169C20.6801 29.1251 20.9264 29.0081 21.1299 28.8171L33.3175 17.3708C33.8695 16.8523 33.8967 15.9845 33.3783 15.4325C32.8598 14.8805 31.9921 14.8533 31.44 15.3717L19.9448 26.1677L13.623 19.4037C13.1059 18.8504 12.2382 18.8211 11.6849 19.3382C11.1317 19.8553 11.1023 20.723 11.6194 21.2763L18.7525 28.9084Z" fill="white"/>
</svg>''',
                        width: 45,
                        height: 45,
                      ),
                    );

                    final ButtonPressed? onPressedResult = await context
                        .pushNamed(ATRoutes.programCreationSuccessScreen,
                            extra: params) as ButtonPressed?;

                    if (context.mounted) {
                      if (onPressedResult == ButtonPressed.elevatedBtn) {
                        context
                            .pushReplacementNamed(ATRoutes.createEpisodeForm, extra: state.newData);
                      } else if (onPressedResult == ButtonPressed.textBtn) {
                        context.pushReplacementNamed(ATRoutes.showPreviewScreen,
                            extra: state.newData);
                      }
                    }
                  } else if (state is FailureState<HostedShow>) {
                    _launchShowBtnNotifier.value = true;
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  }
                },
              ),
              BlocListener<EditShowCubit, ATAppState<HostedShow>>(
                listener: (_, ATAppState<HostedShow> state) {
                  if (state is SuccessState<HostedShow>) {
                    if (state.newData != null) {
                      context
                          .read<HostedShowsCubit>()
                          .updateAShow(state.newData!);
                    }
                    _launchShowBtnNotifier.value = true;
                    if (context.canPop()) context.pop(state.newData);
                    showDrawerNotification(
                      context: context,
                      text: 'Show updated',
                    );
                  } else if (state is FailureState<HostedShow>) {
                    _launchShowBtnNotifier.value = true;
                    showAppNotification2(
                      context: context,
                      text: state.message,
                      type: NotificationType.failure,
                    );
                  }
                },
              ),
            ],
            child: ValueListenableBuilder<bool?>(
                valueListenable: _launchShowBtnNotifier,
                builder: (_, bool? value, __) {
                  return ATBlurredBgBtn(
                    isLoading: value == null,
                    onPressed: value == false
                        ? null
                        : () async {
                            String errorMessage = '';
                            if (_titleCntrl.text.trim().isEmpty) {
                              errorMessage = 'Please enter a title';
                            } else if (selectedDescription ==
                                ATStrings.tellListenersAboutYourShow) {
                              errorMessage = 'Please enter a description';
                            } else if (selectedCommunity == null) {
                              errorMessage = 'Please select a community';
                            } else if ((selectedHashtags ?? <HashTag>[])
                                .isEmpty) {
                              errorMessage = 'Please select at least 1 hashtag';
                            } else if (!_isEditing && selectedPermission == null) {
                              errorMessage =
                                  'Please choose whether to allow hand-raising for this show';
                            } else if (accessTypeData.accessType == null) {
                              errorMessage =
                                  'Please choose whether this show is free or paid';
                            }
                            if (errorMessage.isNotEmpty) {
                              showAppNotification2(
                                context: context,
                                text: errorMessage,
                                type: NotificationType.failure,
                              );
                              return;
                            }

                            //Start loading on button press.
                            _launchShowBtnNotifier.value = null;
                            // Turn any freshly-typed hashtags into real ids
                            // before submitting.
                            await _resolvePendingHashtags();
                            if (!context.mounted) return;
                            final Uint8List? coverBytes =
                                context.read<BgImageCubit>().state.$2;
                            if (coverBytes != null) {
                              // New/changed cover — upload it first.
                              context
                                  .read<UploadImageCubit>()
                                  .uploadBytesImage(
                                    bytes: coverBytes,
                                    purpose: 'cover-art',
                                  );
                            } else if (_isEditing) {
                              // Editing with the cover unchanged — reuse the
                              // existing cover URL, no upload needed.
                              _submitShow(widget.editableShow?.coverUrl ?? '');
                            }
                          },
                    btnTitle:
                        _isEditing ? 'Save changes' : ATStrings.launchShow,
                  );
                })),
      ),
    );
  }
}

String getAccessTypeDescText({
  required ProgramAccessTypeSelectionData? accessTypeData,
  required String initialAccessTypeTextDesc,
}) {
  String accessTypeTextDesc = initialAccessTypeTextDesc;

  if (accessTypeData?.accessType == null) {
    accessTypeTextDesc = initialAccessTypeTextDesc;
  } else {
    final ProgramAccessType? accessType = accessTypeData?.accessType;
    if (accessType == ProgramAccessType.free) {
      accessTypeTextDesc = ATStrings.free;
    } else {
      final double? subAmount = accessTypeData?.subscriptionAmount;
      final double? oneTimePaymentAmt = accessTypeData?.oneTimePaymentAmount;

      if (subAmount != null) {
        accessTypeTextDesc =
            '${ATStrings.subscribersOnly}(${ATStrings.nairaText}$subAmount/month)';
      } else if (oneTimePaymentAmt != null) {
        accessTypeTextDesc =
            '${ATStrings.subscribersOnly}(${ATStrings.nairaText}$oneTimePaymentAmt/one-time)';
      }
    }
  }

  return accessTypeTextDesc;
}
