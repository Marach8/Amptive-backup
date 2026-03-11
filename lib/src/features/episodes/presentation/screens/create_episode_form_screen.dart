import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:amptive/src/features/go_live/go_live_export.dart';
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

enum BtnOnTap { goLive, scheduleEvent }

class CreateEpisodeFormScreen extends StatefulWidget {
  const CreateEpisodeFormScreen({super.key});

  @override
  State<CreateEpisodeFormScreen> createState() => _CreateShowFormScreenState();
}

class _CreateShowFormScreenState extends State<CreateEpisodeFormScreen> {
  late final TextEditingController _titleCntrl;
  final StreamController<String> _titleStreamCntrl = StreamController<String>();
  final StreamController<String> _descStreamCntrl = StreamController<String>();

  final ValueNotifier<(bool, BtnOnTap)> _activateBtn =
      ValueNotifier<(bool, BtnOnTap)>((false, BtnOnTap.goLive));

  String programDesc = ATStrings.tellListenersAboutYourShow;
  String whispersDesc = ATStrings.toggleWhispers;
  String handRaisingDesc = ATStrings.choose2AllowHandRasing;

  UnusedCommunity? selectedCommunity;

  @override
  void initState() {
    super.initState();
    _titleCntrl = TextEditingController()
      ..addListener(() => _titleStreamCntrl.add(_titleCntrl.text.trim()));
  }

  void _check4BtnActivation(BuildContext ctx) {
    final bool cohostIsSelected = ctx
        .read<CohostServiceBloc>()
        .state
        .$2
        .any((ATCohost<bool> cohost) => cohost.profilePicture != null);

    _activateBtn.value = (
      ctx.read<BgImageCubit>().state.$2 != null,
      // &&
      // ctx.read<HashtagServiceBloc>().state.$2.isNotEmpty &&
      // cohostIsSelected &&
      // programDesc != ATStrings.TELL_LISTENERS_ABOUT_SHOW &&
      // whispersDesc != ATStrings.TOGGLE_WHISPERS &&
      // handRaisingDesc != ATStrings.CHOOSE_2_ALLOW_HAND_RASING &&
      // _titleCntrl.text.trim().isNotEmpty,
      _activateBtn.value.$2
    );
  }

  void _toggleBtnOnTap() {
    final BtnOnTap initialOnTap = _activateBtn.value.$2;
    if (initialOnTap == BtnOnTap.goLive) {
      _activateBtn.value = (_activateBtn.value.$1, BtnOnTap.scheduleEvent);
    } else {
      _activateBtn.value = (_activateBtn.value.$1, BtnOnTap.goLive);
    }
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
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
        ),
        BlocProvider<BgImageCubit>(create: (_) => BgImageCubit())
      ],
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.transparent,
        child: Scaffold(
          body: Builder(builder: (BuildContext blocContext) {
            return Stack(
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
                ATContainer(
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
                                  ))),
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
                                  onImageSelected: (Uint8List imgBytes) {
                                blocContext
                                    .read<BgImageCubit>()
                                    .setBgImage(imgBytes);
                                _check4BtnActivation(blocContext);
                              }),
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
                                onChanged: (_) =>
                                    _check4BtnActivation(blocContext),
                                hintStyle:
                                    context.textTheme.bodySmall?.copyWith(
                                  color: ATColors.white.withValues(alpha: 0.4),
                                ),
                                disableBlueBorder: true,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                        color: ATColors.transparent)),
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
                                  description: programDesc,
                                  onTap: () async {
                                    final String? description =
                                        await enterDescriptionModal(
                                      context: context,
                                      initialDesc: programDesc ==
                                              ATStrings
                                                  .tellListenersAboutYourShow
                                          ? null
                                          : programDesc,
                                    );
                                    if ((description ?? '').isNotEmpty) {
                                      setter(() {
                                        programDesc = description!;
                                        _descStreamCntrl.add(description);
                                        _check4BtnActivation(blocContext);
                                      });
                                    }
                                  },
                                );
                              }),
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
                              child: BlocSelector<
                                      CohostServiceBloc,
                                      (
                                        List<ATCohost<bool>>,
                                        List<ATCohost<bool>>
                                      ),
                                      List<ATCohost<bool>>>(
                                  selector: ((
                                            List<ATCohost<bool>>,
                                            List<ATCohost<bool>>
                                          ) state) =>
                                      state.$2,
                                  builder: (_,
                                      List<ATCohost<bool>> selectedCoHosts) {
                                    final bool coHostExists = selectedCoHosts
                                        .any((ATCohost<bool> cohost) =>
                                            cohost.profilePicture != null);

                                    return ATScalingSwitcher(
                                      duration: 300,
                                      child: coHostExists
                                          ? SelectedCoHostsWidget(
                                              onEdit: () {
                                                //showAvailableCoHostsModal(context: context),
                                              },
                                              selectedCohosts: const <User>[])
                                          : CreateProgramSelectionItem(
                                              leading: const ATImgLoader(
                                                height: 20,
                                                width: 20,
                                                imgPath:
                                                    ATImgStrings.outlinedSearch,
                                              ),
                                              trailing: Flexible(
                                                child: Text(
                                                  ATStrings
                                                      .searchAndAddCohost4YourShow,
                                                  style: context
                                                      .textTheme.bodySmall
                                                      ?.copyWith(
                                                    color: ATColors.white
                                                        .withValues(alpha: 0.4),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                //showAvailableCoHostsModal
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: CreateProgramSelectionItem(
                                description: '${ATStrings.addHashtags}s',
                                onTap: (){},
                              ),
                            ),
                            const SelectedHashtagsRow(),
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
                                          ?.copyWith(
                                              fontWeight: ATFontWeights.w500),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: StatefulBuilder(builder:
                                  (_, void Function(void Function()) setter) {
                                return ATScalingSwitcher(
                                    duration: 300,
                                    child: CreateProgramSelectionItem(
                                      description: handRaisingDesc,
                                      descStyle: handRaisingDesc ==
                                              ATStrings.choose2AllowHandRasing
                                          ? null
                                          : context.textTheme.bodySmall,
                                      onTap: () async {
                                        // final String? selectedHandRaising =
                                        //     await showHandRaisingPermissionModal(
                                        //         context: context,
                                        //         initialHandRaising:
                                        //             handRaisingDesc);
                                        // setter(() {
                                        //   if (selectedHandRaising == null) {
                                        //     handRaisingDesc = ATStrings
                                        //         .selectWhoCanAccessYourShow;
                                        //   } else {
                                        //     handRaisingDesc =
                                        //         selectedHandRaising;
                                        //   }
                                        //   _check4BtnActivation(blocContext);
                                        // });
                                      },
                                    ));
                              }),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: ATRichText(
                                  items: <String, TextStyle>{
                                    ATStrings
                                            .youWillHaveAccessToModerationTools:
                                        context.textTheme.labelSmall!.copyWith(
                                            color: ATColors.hexC2C2C2
                                                .withValues(alpha: 0.76)),
                                    ' ${ATStrings.learnMore}':
                                        context.textTheme.labelSmall!
                                  },
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 10),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Iconsax.message,
                                      size: 18,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ATStrings.whispers,
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                              fontWeight: ATFontWeights.w500),
                                    ),
                                  ],
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                              child: StatefulBuilder(builder:
                                  (_, void Function(void Function()) setter) {
                                return ATScalingSwitcher(
                                    duration: 300,
                                    child: CreateProgramSelectionItem(
                                      description: whispersDesc,
                                      descStyle: whispersDesc ==
                                              ATStrings.toggleWhispers
                                          ? null
                                          : context.textTheme.bodySmall,
                                      onTap: () async {
                                        final WhispersState? whispersResult =
                                            await controlWhispersModal(
                                          context: context,
                                          initialWhisper: whispersDesc,
                                        );
                                        setter(() {
                                          if (whispersResult == null) {
                                            whispersDesc =
                                                ATStrings.toggleWhispers;
                                          } else {
                                            whispersDesc = whispersResult ==
                                                    WhispersState.turnedOn
                                                ? ATStrings.TURNED_ON
                                                : ATStrings.TURNED_OFF;
                                          }
                                          _check4BtnActivation(blocContext);
                                        });
                                      },
                                    ));
                              }),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 15),
                                child: Text(
                                  ATStrings.WHISPERS_DESC,
                                  maxLines: 3,
                                  style: context.textTheme.labelSmall?.copyWith(
                                      color: ATColors.hexC2C2C2
                                          .withValues(alpha: 0.76)),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 0, 15, 30),
                                child: Text(
                                  ATStrings.NON_ATTENDING_ENCOURAGED_2_JOIN,
                                  maxLines: 3,
                                  style: context.textTheme.labelSmall?.copyWith(
                                      color: ATColors.hexC2C2C2
                                          .withValues(alpha: 0.76)),
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
          bottomSheet: ValueListenableBuilder<(bool, BtnOnTap)>(
              valueListenable: _activateBtn,
              builder: (BuildContext ctx, (bool, BtnOnTap) value, __) {
                final bool btnOnTapIsGoLive = value.$2 == BtnOnTap.goLive;

                return ATBlurredBgBtn(
                    onPressed: value.$1
                        ? () {
                            if (btnOnTapIsGoLive) {
                              context.pushReplacementNamed(
                                  ATRoutes.GO_LIVE_ONBOARDING);
                            } else {
                              final dynamic params = (
                                coverArtBytes:
                                    ctx.read<BgImageCubit>().state.$2,
                                title: ATStrings.EPISODE_CREATED,
                                subtitle: ATStrings.SHARE_EPISODE_LINK_DESC,
                                btnTitle: ATStrings.SHARE_EPISODE,
                                txtBtnTitle: ATStrings.VIEW_EPISODE_DETAILS,
                                btnOnPressed: () {},
                                txtBtnOnPressed: () {
                                  context.pushReplacementNamed(
                                    ATRoutes.EPISODE_PREVIEW_SCREEN,
                                    extra: ctx.read<BgImageCubit>().state.$2,
                                  );
                                },
                                topLogo: ATContainer(
                                  color: ATColors.white,
                                  radius: 22.5,
                                  height: 40,
                                  width: 40,
                                  padding: const EdgeInsets.all(8),
                                  child: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        ATColors.black, BlendMode.srcATop),
                                    child: const ATImgLoader(
                                      imgPath: ATImgStrings.CALENDER_ICON,
                                      boxFit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              );

                              context.pushNamed(
                                  ATRoutes.programCreationSuccessScreen,
                                  extra: params);
                            }
                          }
                        : null,
                    btnTitle: btnOnTapIsGoLive
                        ? ATStrings.GO_LIVE
                        : '${ATStrings.SCHEDULE} ${ATStrings.EVENT.toLowerCase()}');
              }),
        ),
      ),
    );
  }
}
