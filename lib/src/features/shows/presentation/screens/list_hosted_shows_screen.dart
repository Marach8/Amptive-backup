import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/config/utils/dialogs/app_notification_dialog.dart';
import 'package:amptive/src/features/shows/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/shows/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/render_hosted_show.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/back_button.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/shared/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


enum GoLiveProgramType {event, show}

class ListHostedShowsScreen extends StatelessWidget {
  const ListHostedShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc(),),
        BlocProvider<HostedShowSelectionCubit>(create: (_) => HostedShowSelectionCubit()),
        BlocProvider<HostedShowsCubit>(create: (_) => HostedShowsCubit())
      ],
      child: const _SubWidget(),
    );
  }
}

class _SubWidget extends StatefulWidget {
  const _SubWidget();

  static const List<String> listOfImageStrings = <String>[
    '',
    ATImgStrings.CRIMINAL,
    ATImgStrings.weCanDoHardThingsBgImage,
    // ATImgStrings.CRIMINAL,
    // ATImgStrings.weCanDoHardThingsBgImage,
    // ATImgStrings.CRIMINAL,
    // ATImgStrings.weCanDoHardThingsBgImage,
    ATImgStrings.OFFICE_LADIES,
    ATImgStrings.JOE_POMP_SHOW,
  ];

  @override
  State<_SubWidget> createState() => __SubWidgetState();
}

class __SubWidgetState extends State<_SubWidget> {
  final ScrollController _scrollCntrl = ScrollController();

  @override 
  void initState(){
    super.initState();
    _scrollCntrl.addListener(_onScrollToEnd);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<HostedShowsCubit>().fetchHostedShows(),
    );
  }

  void _onScrollToEnd() {
    const double dragThreshold = 80;
    if (_scrollCntrl.position.pixels >= 
      _scrollCntrl.position.maxScrollExtent + dragThreshold) {
      context.read<HostedShowsCubit>().fetchHostedShows();
    }
  }

  @override 
  void dispose(){
    _scrollCntrl.dispose();
    super.dispose();  
  }

  @override
  Widget build(BuildContext context) {
    final double blurredHeaderHeight = kToolbarHeight 
      + MediaQuery.paddingOf(context).top;

    return ATAnnotatedRegion(
      statusBarColor: ATColors.transparent,
      child: Scaffold(
        body: Builder(
          builder: (BuildContext blocContext) {
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: BlocBuilder<HostedShowSelectionCubit, String?>(
                    builder: (_, String? selectedImgString) {
                      if(selectedImgString == null){
                        return ATContainer(color: ATColors.black,);
                      }
                      return ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                        child: ATImgLoader(
                          boxFit: BoxFit.fill,
                          imgPath: selectedImgString
                        ),
                      );
                    }
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
                                      padding: const EdgeInsets.only(left: 5),
                                      child: ATRoundedBackBtn(bgColor: ATColors.transparent,),
                                    ),
                                    Text(
                                      ATStrings.chooseShow,
                                      style: context.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(width: 30,)
                                  ],
                                ),
                              )
                            )
                          ),
                        ),
        
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                            child: Text(
                              maxLines: 3,
                              ATStrings.chooseOrCreateShowDesc,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: ATColors.hexC2C2C2
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      body: BlocConsumer<HostedShowsCubit, ATAppState<HostedShowsResponseModel>>(
                        listener: (_, ATAppState<HostedShowsResponseModel> state){
                          if(state is FailureState<HostedShowsResponseModel>){
                            showAppNotification2(
                              context: context,
                              text: state.message,
                              type: NotificationType.failure,
                            );
                          }
                        },
                        builder: (_, ATAppState<HostedShowsResponseModel> state) {                          
                          return switch(state){
                            InitialState<HostedShowsResponseModel>() ||
                            LoadingState<HostedShowsResponseModel>() ||
                            SuccessState<HostedShowsResponseModel>() ||
                            FailureState<HostedShowsResponseModel>() => Builder(
                              builder: (_){
                                final HostedShowsResponseModel? hostedShowsData = 
                                  context.read<HostedShowsCubit>().currentHostedShowsData;
                                final List<HostedShow> hostedShows = 
                                  hostedShowsData?.hostedShows ?? <HostedShow>[];
                                
                                if(hostedShows.isEmpty){
                                  if(state is LoadingState<HostedShowsResponseModel>){
                                    return const _RenderShowInitialLoadingShimmer();
                                  }
                                  if(state is FailureState<HostedShowsResponseModel>){
                                    return const _RenderInitialLoadFailureWidget();
                                  }
                                }

                                final bool hasMoreItems = hostedShowsData?.hasMore ?? true;
                                final int count = hostedShows.length;

                                return GridView.builder(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
                                  controller: _scrollCntrl,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20
                                  ),
                                  itemCount: hasMoreItems ? count + 2 : count + 1,
                                  itemBuilder: (_, int gridIndex){
                                    if(gridIndex == 0){
                                      return const CreateNewShowWidget();
                                    }
                                    final int adjustedIndex = gridIndex - 1;
                                    if(adjustedIndex < count){
                                      final HostedShow hostedShow = hostedShows[adjustedIndex];
                                      return RenderHostedShow(hostedShow: hostedShow);
                                    }
                                    if(state is LoadingState<HostedShowsResponseModel>){
                                      return const RenderAHostedShowShimmer();
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
          }
        ),
        
        resizeToAvoidBottomInset: false,
    
        bottomSheet: BlocBuilder<HostedShowSelectionCubit, String?>(
          builder: (_, String? selectedImgPath) {
            return ATBlurredBgBtn(
              btnTitle: ATStrings.next,
              onPressed: selectedImgPath == null ? null : (){
                context.pushNamed(
                  ATRoutes.showPreviewScreen,
                  extra: selectedImgPath
                );
              },
            );
          }
        )
      ),
    );
  }
}


class _RenderShowInitialLoadingShimmer extends StatelessWidget {
  const _RenderShowInitialLoadingShimmer();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20
      ),
      itemCount: 9,
      itemBuilder: (_, int gridIndex){
        if(gridIndex == 0){
          return const CreateNewShowWidget();
        }
        return const RenderAHostedShowShimmer();
      }
    );
  }
}


class _RenderInitialLoadFailureWidget extends StatelessWidget {
  const _RenderInitialLoadFailureWidget();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20
      ),
      itemCount: _SubWidget.listOfImageStrings.length,
      itemBuilder: (_, int gridIndex){
        if(gridIndex == 0){
          return const CreateNewShowWidget();
        }
        return Center(
          child: IconButton(
            onPressed: (){
              context.read<HostedShowsCubit>().fetchHostedShows();
            },
            icon: Icon(Icons.refresh, color: ATColors.white),
          ),
        );
      }
    );
  }
}


class HostedShowSelectionCubit extends Cubit<String?>{
  HostedShowSelectionCubit():super(null);

  void setBgImage(String? image) => emit(image);

}
