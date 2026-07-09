import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/config/utils/dominant_color_extractor.dart';
import 'package:amptive/src/features/events/cubits/hosted_events_cubit.dart';
import 'package:amptive/src/features/events/data/models/response/event_response_model.dart';
import 'package:amptive/src/features/events/presentation/widgets/render_a_hosted_event.dart';
import 'package:amptive/src/features/go_live/data/models/live_program_data.dart';
import 'package:amptive/src/features/shows/presentation/screens/list_hosted_shows_screen.dart';
import 'package:amptive/src/features/shows/presentation/widgets/render_hosted_show.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/mesh_gradient_background.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListHostedEventsScreen extends StatelessWidget {
  const ListHostedEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderCubit>(
          create: (_) => BlurredHeaderCubit(),
        ),
        BlocProvider<HostedEventSelectionCubit>(
            create: (_) => HostedEventSelectionCubit()),
        BlocProvider<DominantColorCubit>(create: (_) => DominantColorCubit()),
        BlocProvider<HostedEventsCubit>(create: (_) => HostedEventsCubit())
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
        sController.addListener(() => _onEventsScrollToEnd(sController));
      }
      context.read<HostedEventsCubit>().fetchHostedEvents();
    });
  }

  void _onEventsScrollToEnd(ScrollController sController) {
    const double threshHold = 100;
    if (sController.position.pixels >=
        sController.position.maxScrollExtent + threshHold) {
      context.read<HostedEventsCubit>().fetchHostedEvents();
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
                Container(
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
                                                      ATStrings.chooseEvent,
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
                                    ATStrings.chooseOrCreateEventDesc,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(color: ATColors.hexC2C2C2),
                                  ),
                                ),
                              ),
                            ],
                        body: BlocConsumer<HostedEventsCubit,
                                ATAppState<HostedEventsResponseModel>>(
                            listener: (_,
                                ATAppState<HostedEventsResponseModel> state) {
                          if (state
                              is FailureState<HostedEventsResponseModel>) {
                            showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure,
                            );
                          }
                        }, builder: (_,
                                ATAppState<HostedEventsResponseModel> state) {
                          return switch (state) {
                            InitialState<HostedEventsResponseModel>() ||
                            LoadingState<HostedEventsResponseModel>() ||
                            SuccessState<HostedEventsResponseModel>() ||
                            FailureState<HostedEventsResponseModel>() =>
                              Builder(builder: (_) {
                                final HostedEventsResponseModel?
                                    hostedEventsData = context
                                        .read<HostedEventsCubit>()
                                        .currentHostedEventsData;
                                final List<HostedEvent> hostedEvents =
                                    hostedEventsData?.hostedEvents ??
                                        <HostedEvent>[];

                                if (hostedEvents.isEmpty) {
                                  if (state is LoadingState<
                                      HostedEventsResponseModel>) {
                                    return RenderEventOrShowInitialLoadingShimmer(
                                      createNewLabel: ATStrings.createNewEvent,
                                      onCreateNewTapped: () {
                                        context.pushNamed(
                                          ATRoutes.createEventFormScreen,
                                          extra:
                                              context.read<HostedEventsCubit>(),
                                        );
                                      },
                                    );
                                  }
                                  if (state is FailureState<
                                      HostedEventsResponseModel>) {
                                    return RenderInitialEventOrShowLoadFailureWidget(
                                      createNewLabel: ATStrings.createNewEvent,
                                      onCreateNewTapped: () {
                                        context.pushNamed(
                                          ATRoutes.createEventFormScreen,
                                          extra:
                                              context.read<HostedEventsCubit>(),
                                        );
                                      },
                                      onRefresh: () {
                                        context
                                            .read<HostedEventsCubit>()
                                            .fetchHostedEvents();
                                      },
                                    );
                                  }
                                }

                                final bool hasMoreItems =
                                    hostedEventsData?.hasMore ?? true;
                                final int count = hostedEvents.length;
                                final bool showPaginationLoader =
                                    hasMoreItems &&
                                        state is LoadingState<
                                            HostedEventsResponseModel>;

                                return HostedProgramsGrid(
                                    itemCount: count +
                                        1 +
                                        (showPaginationLoader ? 1 : 0),
                                    itemBuilder: (_, int gridIndex) {
                                      if (gridIndex < count) {
                                        final HostedEvent hostedEvent =
                                            hostedEvents[gridIndex];
                                        return RenderHostedEvent(
                                            hostedEvent: hostedEvent);
                                      }
                                      if (gridIndex == count) {
                                        return CreateNewEventOrShowWidget(
                                          label: ATStrings.createNewEvent,
                                          onTap: () async {
                                            final LiveProgramData?
                                                liveProgramData =
                                                await context.pushNamed(
                                              ATRoutes.createEventFormScreen,
                                              extra: context
                                                  .read<HostedEventsCubit>(),
                                            ) as LiveProgramData?;

                                            if (liveProgramData != null) {
                                              dashboardKey.currentState
                                                  ?.showLiveStreamOverlay(
                                                      liveProgramData:
                                                          liveProgramData);
                                            }
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
          bottomSheet: BlocBuilder<HostedEventSelectionCubit, HostedEvent?>(
              builder: (_, HostedEvent? selectedEvent) {
            final bool shouldActivate = selectedEvent != null;
            return ATBlurredBgBtn(
              btnTitle: ATStrings.next,
              onPressed: shouldActivate
                  ? () async {
                      final HostedEvent? editedEvent = await context.pushNamed(
                        ATRoutes.eventPreviewScreen,
                        extra: selectedEvent,
                      ) as HostedEvent?;

                      if (context.mounted &&
                          editedEvent != null &&
                          editedEvent != selectedEvent) {
                        context
                            .read<HostedEventsCubit>()
                            .updateAnEvent(editedEvent);
                      }
                    }
                  : null,
            );
          })),
    );
  }
}

class HostedEventSelectionCubit extends Cubit<HostedEvent?> {
  HostedEventSelectionCubit() : super(null);

  void setSelection({HostedEvent? event}) {
    emit(event);
  }
}
