import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/data/repository/shows_repo_impl.dart';
import 'package:amptive/src/features/shows/presentation/widgets/render_hosted_show.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum GoLiveProgramType { event, show }

class ListHostedShowsScreen extends StatelessWidget {
  const ListHostedShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
        ),
        BlocProvider<HostedShowSelectionCubit>(
            create: (_) => HostedShowSelectionCubit()),
        BlocProvider<DominantColorCubit>(create: (_) => DominantColorCubit()),
        BlocProvider<HostedShowsCubit>(create: (_) => HostedShowsCubit())
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
  final GlobalKey<NestedScrollViewState> _nestedKey =
      GlobalKey<NestedScrollViewState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ScrollController? sController =
          _nestedKey.currentState?.innerController;
      if (sController != null) {
        sController.addListener(() => _onShowsScrollToEnd(sController));
      }
      context.read<HostedShowsCubit>().fetchHostedShows();
    });
  }

  void _onShowsScrollToEnd(ScrollController sController) {
    const double threshHold = 100;
    if (sController.position.pixels >=
        sController.position.maxScrollExtent + threshHold) {
      context.read<HostedShowsCubit>().fetchHostedShows();
    }
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
                  child: BlocBuilder<DominantColorCubit, DominantColorState>(
                    builder: (_, DominantColorState state) =>
                        ATMeshGradientBackground(
                      state: state,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
                ATContainer(
                  color: ATColors.black.withValues(alpha: 0.12),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: blocContext
                        .read<BlurredHeaderCubit>()
                        .onScrollNotification,
                    child: NestedScrollView(
                        key: _nestedKey,
                        physics: const NeverScrollableScrollPhysics(),
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
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4),
                                                child: ATBackBtn(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  leadingText:
                                                      ATStrings.chooseShow,
                                                  leadingStyle: context
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                    fontSize: ATSizes.size23,
                                                    letterSpacing: -0.39,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 12, 12, 20),
                                  child: Text(
                                    maxLines: 3,
                                    ATStrings.chooseOrCreateShowDesc,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(color: ATColors.hexC2C2C2),
                                  ),
                                ),
                              ),
                            ],
                        body: BlocConsumer<HostedShowsCubit,
                                ATAppState<HostedShowsResponseModel>>(
                            listener: (_,
                                ATAppState<HostedShowsResponseModel> state) {
                          if (state is FailureState<HostedShowsResponseModel>) {
                            showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure,
                            );
                          }
                        }, builder: (_,
                                ATAppState<HostedShowsResponseModel> state) {
                          return switch (state) {
                            InitialState<HostedShowsResponseModel>() ||
                            LoadingState<HostedShowsResponseModel>() ||
                            SuccessState<HostedShowsResponseModel>() ||
                            FailureState<HostedShowsResponseModel>() =>
                              Builder(builder: (_) {
                                final HostedShowsResponseModel?
                                    hostedShowsData = context
                                        .read<HostedShowsCubit>()
                                        .currentHostedShowsData;
                                final List<HostedShow> hostedShows =
                                    hostedShowsData?.hostedShows ??
                                        <HostedShow>[];

                                if (hostedShows.isEmpty) {
                                  if (state is LoadingState<
                                      HostedShowsResponseModel>) {
                                    return RenderEventOrShowInitialLoadingShimmer(
                                      createNewLabel: ATStrings.createNewShow,
                                      onCreateNewTapped: () {
                                        context.pushNamed(
                                          ATRoutes.createShowFormScreen,
                                          extra:
                                              context.read<HostedShowsCubit>(),
                                        );
                                      },
                                    );
                                  }
                                  if (state is FailureState<
                                      HostedShowsResponseModel>) {
                                    return RenderInitialEventOrShowLoadFailureWidget(
                                      createNewLabel: ATStrings.createNewShow,
                                      onCreateNewTapped: () {
                                        context.pushNamed(
                                          ATRoutes.createShowFormScreen,
                                          extra:
                                              context.read<HostedShowsCubit>(),
                                        );
                                      },
                                      onRefresh: () {
                                        context
                                            .read<HostedShowsCubit>()
                                            .fetchHostedShows();
                                      },
                                    );
                                  }
                                }

                                final bool hasMoreItems =
                                    hostedShowsData?.hasMore ?? true;
                                final int count = hostedShows.length;
                                final bool showPaginationLoader =
                                    hasMoreItems &&
                                        state is LoadingState<
                                            HostedShowsResponseModel>;

                                return HostedProgramsGrid(
                                    itemCount: count +
                                        1 +
                                        (showPaginationLoader ? 1 : 0),
                                    itemBuilder: (_, int gridIndex) {
                                      if (gridIndex < count) {
                                        final HostedShow hostedShow =
                                            hostedShows[gridIndex];
                                        return RenderHostedShow(
                                            hostedShow: hostedShow);
                                      }
                                      if (gridIndex == count) {
                                        return CreateNewEventOrShowWidget(
                                          label: ATStrings.createNewShow,
                                          onTap: () {
                                            context.pushNamed(
                                              ATRoutes.createShowFormScreen,
                                              extra: context
                                                  .read<HostedShowsCubit>(),
                                            );
                                          },
                                        );
                                      }
                                      if (showPaginationLoader) {
                                        return const RenderAHostedEventOrShowShimmer();
                                      }
                                      return const SizedBox.shrink();
                                    });
                              })
                          };
                        })),
                  ),
                ),
              ],
            );
          }),
          resizeToAvoidBottomInset: false,
          bottomSheet: BlocBuilder<HostedShowSelectionCubit, HostedShow?>(
              builder: (_, HostedShow? selectedShow) {
            final bool shouldActivate = selectedShow != null;
            return ATBlurredBgBtn(
              btnTitle: ATStrings.next,
              onPressed: shouldActivate
                  ? () async {
                      final HostedShow? editedShow = await context.pushNamed(
                        ATRoutes.showPreviewScreen,
                        extra: selectedShow,
                      ) as HostedShow?;

                      if (context.mounted) {
                        final String showId = selectedShow.showId ?? '';
                        final HostedShow? cachedShow =
                            ShowsRepoImpl.getCachedShow(showId);
                        if (cachedShow != null && cachedShow != selectedShow) {
                          context
                              .read<HostedShowsCubit>()
                              .updateAShow(cachedShow);
                        } else if (editedShow != null &&
                            editedShow != selectedShow) {
                          context
                              .read<HostedShowsCubit>()
                              .updateAShow(editedShow);
                        }
                      }
                    }
                  : null,
            );
          })),
    );
  }
}

class RenderEventOrShowInitialLoadingShimmer extends StatelessWidget {
  const RenderEventOrShowInitialLoadingShimmer({
    super.key,
    required this.onCreateNewTapped,
    required this.createNewLabel,
  });
  final VoidCallback onCreateNewTapped;
  final String createNewLabel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 4,
        itemBuilder: (_, int gridIndex) {
          if (gridIndex == 3) {
            return CreateNewEventOrShowWidget(
                label: createNewLabel, onTap: onCreateNewTapped);
          }
          return const RenderAHostedEventOrShowShimmer();
        });
  }
}

class RenderInitialEventOrShowLoadFailureWidget extends StatelessWidget {
  const RenderInitialEventOrShowLoadFailureWidget({
    super.key,
    required this.onCreateNewTapped,
    required this.onRefresh,
    required this.createNewLabel,
  });

  final VoidCallback onCreateNewTapped, onRefresh;
  final String createNewLabel;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 2,
        itemBuilder: (_, int gridIndex) {
          if (gridIndex == 0) {
            return CreateNewEventOrShowWidget(
              onTap: onCreateNewTapped,
              label: createNewLabel,
            );
          }
          return Center(
            child: IconButton(
              onPressed: onRefresh,
              icon: Icon(Icons.refresh, color: ATColors.white),
            ),
          );
        });
  }
}

class HostedShowSelectionCubit extends Cubit<HostedShow?> {
  HostedShowSelectionCubit() : super(null);

  void setSelection({HostedShow? show}) {
    emit(show);
  }
}
