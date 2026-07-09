import 'dart:async';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:amptive/src/features/episodes/presentation/widgets/whispers_permision_modal.dart';
import 'package:amptive/src/features/events/cubits/edit_event_cubit.dart';
import 'package:amptive/src/features/events/cubits/start_event_cubit.dart';
import 'package:amptive/src/features/events/data/models/request/create_event_model.dart';
import 'package:amptive/src/features/events/presentation/screens/select_schedule_date_screen.dart';
import 'package:amptive/src/features/events/presentation/widgets/events_audience_access_modal.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/presentation/widgets/set_event_capacity_modal.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/shared/annotated_region_widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import '../../../../shared/rich_text.dart';
import 'dart:developer' show log;
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import '../../../../config/utils/dialogs/communities_modal.dart';

class EditEventFormScreen extends StatelessWidget {
  const EditEventFormScreen({
    super.key,
    required this.editableEvent,
  });

  final HostedEvent editableEvent;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<UploadImageCubit>(create: (_) => UploadImageCubit()),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),),
        BlocProvider<BgImageCubit>(create: (_) => BgImageCubit(
          initialImage: editableEvent.coverUrl
        )),
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SelectedHashTagsCubit>(
          create: (_) => SelectedHashTagsCubit(
            initialHashtags: editableEvent.tags,
          )),
        BlocProvider<EditEventCubit>(create: (_) => EditEventCubit()),
      ],
      child: _SubWidget(editableEvent: editableEvent),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget({required this.editableEvent});
  final HostedEvent editableEvent;

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();

  //Null for loading, false for disabled, true for enabled.
  final ValueNotifier<bool?> _activateBtn =
      ValueNotifier<bool?>(false);

  String selectedDescription = ATStrings.tellListenersAboutYourEvent;
  int? _selectedCapacity;
  HandRaisingPermission? selectedPermission;
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
    _titleCntrl = TextEditingController(text: widget.editableEvent.title)
      ..addListener(() => _titleStreamCntrl.add(_titleCntrl.text.trim()));
      
    _titleStreamCntrl.add(_titleCntrl.text.trim());
    _descStreamCntrl.add(widget.editableEvent.description ?? '');
    _activateBtn.value = widget.editableEvent.coverUrl != null;

    selectedDescription = widget.editableEvent.description 
      ?? ATStrings.tellListenersAboutYourEvent;
    _selectedCapacity = widget.editableEvent.capacity;
    selectedCommunity = widget.editableEvent.community;
    selectedCohosts = widget.editableEvent.coHosts;
    selectedHashtags = widget.editableEvent.tags;
    _scheduleDate = DateTime.tryParse(widget.editableEvent.scheduledFor ?? '');

    selectedPermission = (widget.editableEvent.handRaising ?? false) 
      ? HandRaisingPermission.allow : HandRaisingPermission.dontAllow;
      
    selectedWhispersPermission = (widget.editableEvent.whispers ?? false)
      ? WhispersPermission.allow : WhispersPermission.dontAllow;

    accessTypeData = ProgramAccessTypeSelectionData(
      accessType: widget.editableEvent.eventType == 'free'
        ? ProgramAccessType.free : ProgramAccessType.paid,
      subscriptionAmount: widget.editableEvent.price ?? 0.01,
    );
    
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
    _activateBtn.dispose();
    _descStreamCntrl.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight =
        kToolbarHeight + MediaQuery.paddingOf(context).top;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Builder(builder: (BuildContext blocContext) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: BlocBuilder<BgImageCubit, (String, Uint8List?)>(
                      builder: (_, (String, Uint8List?) state) {
                    return state.$2 == null
                        ? ATImgLoader(
                            boxFit: BoxFit.fill,
                            imgPath: state.$1,
                          )
                        : Image.memory(state.$2!, fit: BoxFit.fill);
                  }),
                ),
              ),

              Container(
                color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
                child: NotificationListener<ScrollNotification>(
                  onNotification: blocContext
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
                                    '${ATStrings.edit} ${ATStrings.event}',
                                    style: context.textTheme.bodyMedium,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(right: 15),
                                    child: InkWell(
                                        onTap: ()async{
                                          final DateTime? newDate = await context.pushNamed(
                                            ATRoutes.selectScheduleDateScreen,
                                            extra: SelectScheduleDataScreenEntryParams(
                                              selectedBgImage: context.read<BgImageCubit>().state.$2,
                                              programName: 'Event',
                                              incomingBgImageUrl: widget.editableEvent.coverUrl,
                                              incomingDate: _scheduleDate
                                            )
                                          ) as DateTime?;
                                          _scheduleDate = newDate;
                                        },
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
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 120),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                            child: SelectProgramCoverArt(
                              onImageSelected:
                                  blocContext.read<BgImageCubit>().setBgImage,
                              initialImage: widget.editableEvent.coverUrl,
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
                              hintText:'What is the title of your event?',
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
                                (_, StateSetter setter) {
                              return CreateProgramSelectionItem(
                                description: selectedDescription,
                                descStyle: selectedDescription == 
                                  ATStrings.tellListenersAboutYourEvent ? null :
                                    context.textTheme.bodySmall,
                                onTap: () async {
                                  final String? enteredDescription =
                                      await enterDescriptionModal(
                                    context: context,
                                    initialDesc: selectedDescription ==
                                            ATStrings.tellListenersAboutYourEvent
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
                                              .selectCommunity4YourEvent,
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
                                        selectedCohosts: selectedCohosts!
                                    )
                                    : CreateProgramSelectionItem(
                                        leading: const ATImgLoader(
                                          height: 20,
                                          width: 20,
                                          imgPath: ATImgStrings.outlinedSearch,
                                        ),
                                        trailing: Flexible(
                                          child: Text(
                                            ATStrings.searchAndAddCohost4YourEvent,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                  getEventAccessTypeDescText(
                                    accessTypeData: accessTypeData,
                                  );
                              return ATScalingSwitcher(
                                  duration: 300,
                                  child: CreateProgramSelectionItem(
                                    description: accessTypeDescText,
                                    descStyle: accessTypeDescText ==
                                            ATStrings.selectWhoCanAccessYourEvent
                                        ? null
                                        : context.textTheme.bodySmall,
                                    onTap: () async {
                                      final ProgramAccessTypeSelectionData?
                                          newAccessTypeData =
                                          await showEventsAudienceAccessTypeModal(
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
                                  color: ATColors.hexC2C2C2
                                      .withValues(alpha: 0.76)),
                            ),
                          ),

                          const Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
                            child: ATDivider(height: 1.1),
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
                                  const SizedBox(width: 5),
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
                                if (selectedPermission == HandRaisingPermission.allow) {
                                  descriptionText = ATStrings.allow;
                                } else if (selectedPermission == HandRaisingPermission.dontAllow) {
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
                                        initialPermission: selectedPermission
                                      );
                                    setter(() => selectedPermission = newPermission);
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
                            padding:
                                const EdgeInsets.fromLTRB(15, 0, 15, 10),
                            child: Row(
                              children: <Widget>[
                                const ATImgLoader(
                                  imgPath: ATImgStrings.usersIcon,
                                  height: 18, width: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  ATStrings.capacity,
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
                                return CreateProgramSelectionItem(
                                  description: _selectedCapacity == null ? 'Unlimited'
                                    : _selectedCapacity.toString(),
                                  descStyle: context.textTheme.bodySmall,
                                  onTap: () async {
                                    final int? newCapacity = await showEventCapacitySelectionDialog(
                                      context: context,
                                      currentCapacity: _selectedCapacity,
                                    );
                                    setter(() => _selectedCapacity = newCapacity ?? 0);
                                  },
                                );
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                            child: Text(
                              ATStrings.setCapacityDesc,
                              maxLines: 5,
                              style: context.textTheme.labelSmall!.copyWith(
                                  color: ATColors.hexC2C2C2
                                      .withValues(alpha: 0.76)),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
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
          );
        }),

        resizeToAvoidBottomInset: false,
        bottomSheet: MultiBlocListener(
          listeners: <SingleChildWidget>[
            //Listen to uploading bacground cover art
            BlocListener<UploadImageCubit, ATAppState<String>>(
              listener: (_, ATAppState<String> state) {
                if (state is SuccessState<String>) {
                  //If we upload image successfully, create the episode.
                  context.read<EditEventCubit>().editEvent(
                    eventId: widget.editableEvent.eventId ?? '',
                    createEventModel: CreateEventPayload(
                      tagIds: (selectedHashtags ?? <HashTag>[])
                        .map((HashTag tag) => tag.id ?? '')
                        .toList(),
                      coHostIds: (selectedCohosts ?? <User>[])
                        .map((User cohost) => cohost.userId)
                        .toList(),
                      title: _titleCntrl.text.trim(),
                      description: selectedDescription,
                      thumbnailUrl: state.newData!,
                      communityId: selectedCommunity?.communityId ?? '',
                      category: 'Category',
                      allowWhispers: selectedWhispersPermission == WhispersPermission.allow,
                      eventType: accessTypeData.accessType 
                        == ProgramAccessType.free ? 'free' : 'paid',
                      handRaising: selectedPermission == HandRaisingPermission.allow,
                      price: accessTypeData.subscriptionAmount ?? 0.01,
                      capacity: _selectedCapacity,
                      scheduledFor: _scheduleDate?.toUtc().toIso8601String(),
                    ),
                  );
                } else if (state is FailureState<String>) {
                  //if uploading cover art fails, stop loading and show notif
                  showAppNotification2(
                    context: context,
                    text: state.message,
                    type: NotificationType.failure,
                  );
                  _activateBtn.value = true;
                }
              },
            ),
            //Listen to creating the event draft.
            BlocListener<EditEventCubit, ATAppState<HostedEvent>>(
              listener: (_, ATAppState<HostedEvent> state) async{
                if (state is SuccessState<HostedEvent>) {
                  _activateBtn.value = true;
                  context.pop(state.newData);
                } 
                else if (state is FailureState<HostedEvent>) {
                  _activateBtn.value = true;
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
              valueListenable: _activateBtn,
              builder: (_, bool? value, __) {
                //null for loading, false for disabled, true for enabled for the bool.
                return ATBlurredBgBtn(
                  isLoading: value == null,
                  onPressed: value == false ? null : () {
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
                    } else if(selectedPermission == null) {
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
                    _activateBtn.value = null;
                    //Try to upload the cover image.
                    context.read<UploadImageCubit>().uploadBytesImage(
                      bytes: context.read<BgImageCubit>().state.$2,
                      purpose: 'cover-art',
                      existingImageUrl: widget.editableEvent.coverUrl,
                    );
                  },
                  btnTitle: 'Accept changes'
                );
              }
            )
        ),
      ),
    );
  }
}

