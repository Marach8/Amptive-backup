import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/shows/presentation/widgets/render_hosted_show.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
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
    WidgetsBinding.instance.addPostFrameCallback(
      (_){
        final ScrollController? sController =
          _nestedKey.currentState?.innerController;
        if (sController != null) {
          sController.addListener(() => _onShowsScrollToEnd(sController));
        }
        context.read<HostedShowsCubit>().fetchHostedShows();
      }
    );
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
                  child: BlocBuilder<HostedShowSelectionCubit, HostedShow?>(
                      builder: (_, HostedShow? selected) {
                    final String? selectedImgString = selected?.coverUrl;
                    if (selectedImgString == null) {
                      return ATContainer(
                        color: ATColors.black,
                      );
                    }
                    return ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                      child: ATImgLoader(
                          boxFit: BoxFit.fill, imgPath: selectedImgString),
                    );
                  }),
                ),
                ATContainer(
                  color: ATColors.hex0D0D0D.withValues(alpha: 0.75),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: blocContext
                        .read<BlurredHeaderCubit>()
                        .onScrollNotification,
                    child: NestedScrollView(
                      key: _nestedKey,
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
                                          padding: const EdgeInsets.only(
                                              left: 5),
                                          child: ATRoundedBackBtn(
                                            bgColor: ATColors.transparent,
                                          ),
                                        ),
                                        Text(
                                          ATStrings.chooseShow,
                                          style: context
                                              .textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 30)
                                      ],
                                    ),
                                  )
                                )
                              ),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 20),
                                  child: Text(
                                    maxLines: 3,
                                    ATStrings.chooseOrCreateShowDesc,
                                    style: context.textTheme.bodySmall
                                        ?.copyWith(color: ATColors.hexC2C2C2),
                                  ),
                                ),
                              ),
                            ],
                        body: BlocConsumer<HostedShowsCubit, ATAppState<HostedShowsResponseModel>>(
                            listener: (_, ATAppState<HostedShowsResponseModel> state) {
                          if (state is FailureState<HostedShowsResponseModel>) {
                            showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure,
                            );
                          }
                        }, builder: (_, ATAppState<HostedShowsResponseModel> state) {
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
                                  if (state is LoadingState<HostedShowsResponseModel>) {
                                    return RenderEventOrShowInitialLoadingShimmer(
                                      createNewLabel: ATStrings.createNewShow,
                                      onCreateNewTapped: (){
                                        context.pushNamed(
                                          ATRoutes.createShowFormScreen,
                                          extra: context.read<HostedShowsCubit>(),
                                        );
                                      },
                                    );
                                  }
                                  if (state is FailureState<HostedShowsResponseModel>) {
                                    return RenderInitialEventOrShowLoadFailureWidget(
                                      createNewLabel: ATStrings.createNewShow,
                                      onCreateNewTapped: (){
                                        context.pushNamed(
                                          ATRoutes.createShowFormScreen,
                                          extra: context.read<HostedShowsCubit>(),
                                        );
                                      },
                                      onRefresh: (){
                                        context.read<HostedShowsCubit>().fetchHostedShows();
                                      },
                                    );
                                  }
                                }

                                final bool hasMoreItems =
                                    hostedShowsData?.hasMore ?? true;
                                final int count = hostedShows.length;

                                return GridView.builder(
                                    padding: const EdgeInsets.fromLTRB(
                                        15, 0, 15, 100),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.7,
                                            crossAxisSpacing: 20,
                                            mainAxisSpacing: 20),
                                    itemCount:
                                        hasMoreItems ? count + 2 : count + 1,
                                    itemBuilder: (_, int gridIndex) {
                                      if (gridIndex == 0) {
                                        return CreateNewEventOrShowWidget(
                                          label: ATStrings.createNewShow,
                                          onTap: (){
                                            context.pushNamed(
                                              ATRoutes.createShowFormScreen,
                                              extra: context.read<HostedShowsCubit>(),
                                            );
                                          },
                                        );
                                      }

                                      final int adjustedIndex = gridIndex - 1;
                                      if (adjustedIndex < count) {
                                        final HostedShow hostedShow = hostedShows[adjustedIndex];
                                        return RenderHostedShow(hostedShow: hostedShow);
                                      }
                                      if (state is LoadingState<HostedShowsResponseModel>) {
                                        return const RenderAHostedEventOrShowShimmer();
                                      }
                                      return const SizedBox.shrink();
                                    }
                                  );
                              }
                            )
                          };
                        }
                      )
                    ),
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
                  ? () async{
                    final HostedShow? editedShow = await context.pushNamed(
                      ATRoutes.showPreviewScreen,
                      extra: selectedShow,
                    ) as HostedShow?;

                    if(context.mounted && editedShow != null
                      && editedShow != selectedShow){
                      context.read<HostedShowsCubit>().updateAShow(editedShow);
                    }
                      // context.pushNamed(
                      //   ATRoutes.showPreviewScreen,
                      //   extra: selectedShow,
                      // );
                    }
                  : null,
            );
          }
        )
      ),
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
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: 9,
        itemBuilder: (_, int gridIndex) {
          if (gridIndex == 0) {
            return CreateNewEventOrShowWidget(
              label: createNewLabel,
              onTap: onCreateNewTapped
            );
          }
          return const RenderAHostedEventOrShowShimmer();
        }
      );
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
        physics: const BouncingScrollPhysics(),
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
