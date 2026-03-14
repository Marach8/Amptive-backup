import 'dart:async';
import 'dart:developer' show log;
import 'dart:typed_data';
import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/discover/cubits/communities_cubit.dart';
import 'package:amptive/src/features/auth/cubits/upload_image_cubit.dart';
import 'package:amptive/src/features/discover/cubits/hashtags_cubit.dart';
import 'package:amptive/src/features/discover/cubits/users_cubits.dart';
import 'package:amptive/src/features/shows/cubits/create_show_cubit.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/divider_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:amptive/src/shared/textformfield_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import '../../../../shared/rich_text.dart';
import '../../../../config/utils/dialogs/communities_modal.dart';

class CreateShowFormScreen extends StatelessWidget {
  const CreateShowFormScreen({
    super.key,
    required this.hostedShowsCubit,
  });
  final HostedShowsCubit hostedShowsCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CommunitiesCubit>(create: (_) => CommunitiesCubit()),
        BlocProvider<CreateShowCubit>(create: (_) => CreateShowCubit()),
        BlocProvider<UploadImageCubit>(create: (_) => UploadImageCubit()),
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),),
        BlocProvider<BgImageCubit>(create: (_) => BgImageCubit()),
        BlocProvider<AllUsersCubit>(create: (_) => AllUsersCubit()),
        BlocProvider<AllHashtagsCubit>(create: (_) => AllHashtagsCubit()),
        BlocProvider<SelectedHashTagsCubit>(
          create: (_) => SelectedHashTagsCubit()),
        BlocProvider<HostedShowsCubit>.value(value: hostedShowsCubit,),
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

  //Null for loading, false for disabled, true for enabled.
  final ValueNotifier<bool?> _launchShowBtnNotifier = ValueNotifier<bool?>(false);

  String selectedDescription = ATStrings.tellListenersAboutYourShow;
  HandRaisingPermission? selectedPermission;

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
    _launchShowBtnNotifier.dispose();
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
                  imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: ATRoundedBackBtn(
                                      bgColor: ATColors.transparent,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<CommunitiesCubit>().fetchCommunities();
                                    },
                                    child: Text(
                                      ATStrings.createShow,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
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
                                  blocContext.read<BgImageCubit>().setBgImage,
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

                                if (selectedPermission == HandRaisingPermission.allow) {
                                  descriptionText = ATStrings.allow;
                                } else if (selectedPermission == HandRaisingPermission.dontAllow) {
                                  descriptionText = ATStrings.dontAllow;
                                }

                                return ATScalingSwitcher(
                                  duration: 300,
                                  child: CreateProgramSelectionItem(
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
              ),
            ],
          );
        }),
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
                  //If we upload image successfully, create the show.
                  context.read<CreateShowCubit>().createShow(
                    tagIds: (selectedHashtags ?? <HashTag>[])
                      .map((HashTag tag) => tag.id ?? '')
                      .toList(),
                    coHostIds: (selectedCohosts ?? <User>[])
                      .map((User cohost) => cohost.id ?? '')
                      .toList(),
                    title: _titleCntrl.text.trim(),
                    description: selectedDescription,
                    coverUrl: state.newData!,
                    communityId: selectedCommunity?.communityId ?? '',
                    category: 'Category',
                    showType: accessTypeData.accessType 
                      == ProgramAccessType.free ? 'free' : 'paid',
                    price: accessTypeData.subscriptionAmount 
                      ?? accessTypeData.oneTimePaymentAmount ?? 0.01,
                    allowHandRaising: selectedPermission == HandRaisingPermission.allow,
                  );
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
              listener: (_, ATAppState<HostedShow> state) async{
                if (state is SuccessState<HostedShow>) {
                  context.read<HostedShowsCubit>().addNewHostedShow(state.newData);
                  _launchShowBtnNotifier.value = true;
                  final dynamic params = ProgramCreationSuccessScreenParams(
                      coverArtBytes: context.read<BgImageCubit>().state.$2!,
                      title: ATStrings.showIsSetup,
                      subtitle: ATStrings.beginYourJourney,
                      btnTitle: ATStrings.createFirstEpisode,
                      txtBtnTitle: ATStrings.viewShowPage,
                      topLogo: const Icon(Icons.check_circle_sharp, size: 45),
                    );

                    final ButtonPressed? onPressedResult = await context.pushNamed(
                      ATRoutes.programCreationSuccessScreen,
                      extra: params
                    ) as ButtonPressed?;

                    if(context.mounted){
                      if(onPressedResult == ButtonPressed.elevatedBtn){
                        context.pushReplacementNamed(
                          ATRoutes.createEpisodeForm);
                      } else if(onPressedResult == ButtonPressed.textBtn){
                        context.pushReplacementNamed(
                          ATRoutes.showPreviewScreen,
                          extra: state.newData
                        );
                      }
                    }
                } 
                else if (state is FailureState<HostedShow>) {
                  _launchShowBtnNotifier.value = true;
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
              valueListenable: _launchShowBtnNotifier,
              builder: (_, bool? value, __) {
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
                      errorMessage = 'Please choose whether to allow hand-raising for this show';
                    } else if(accessTypeData.accessType == null) {
                      errorMessage = 'Please choose whether this show is free or paid';
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
                    _launchShowBtnNotifier.value = null;
                    //Try to upload the cover image.
                    context.read<UploadImageCubit>().uploadBytesImage(
                      bytes: context.read<BgImageCubit>().state.$2!,
                      purpose: 'cover-art',
                    );
                  },
                  btnTitle: ATStrings.launchShow,
                );
              }
            )
          ),
      ),
    );
  }
}

String getAccessTypeDescText(
    {required ProgramAccessTypeSelectionData? accessTypeData}) {
  String accessTypeTextDesc = ATStrings.selectWhoCanAccessYourShow;

  if (accessTypeData?.accessType == null) {
    accessTypeTextDesc = ATStrings.selectWhoCanAccessYourShow;
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
