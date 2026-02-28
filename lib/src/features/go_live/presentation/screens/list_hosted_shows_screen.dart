import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/existing_go_live_program_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


enum GoLiveProgramType {event, show}

class ListHostedShowsScreen extends StatelessWidget {
  const ListHostedShowsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc(),),
        BlocProvider<_PrivateBloc>(create: (_) => _PrivateBloc()),
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
  @override 
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<HostedShowsCubit>().fetchHostedShows(),
    );
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
                  child: BlocBuilder<_PrivateBloc, String?>(
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

                        },
                        builder: (_, ATAppState<HostedShowsResponseModel> state) {
                          return switch(state){
                            InitialState<HostedShowsResponseModel>() ||
                            LoadingState<HostedShowsResponseModel>() ||
                            SuccessState<HostedShowsResponseModel>() ||
                            FailureState<HostedShowsResponseModel>() => Builder(
                              builder: (_){
                                final HostedShowsResponseModel? hostedShowsData = 
                                  context.read<HostedShowsCubit>().hostedShowsData;
                                final List<HostedShow> hostedShows = 
                                  hostedShowsData?.items ?? <HostedShow>[];

                                
                              }
                            )
                          };
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
                              final String imagePath = _SubWidget.listOfImageStrings.elementAt(gridIndex);
                              if(gridIndex == 0){
                                return LayoutBuilder(
                                  builder: (_, BoxConstraints kst) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ATContainer(
                                          onTap: (){
                                            context.pushNamed(ATRoutes.CREATE_SHOW_FORM);
                                          },
                                          radius: 5, color: ATColors.hex2D2D2D,
                                          width: context.screenWidth,
                                          height: kst.maxHeight * 0.65,
                                          child: const Icon(Icons.add, size: 100),
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(
                                          ATStrings.createNewShow,
                                          style: context.textTheme.bodyMedium,
                                        ),
                                      ],
                                    );
                                  }
                                );
                              }
                              return BlocBuilder<_PrivateBloc, String?>(
                                builder: (BuildContext blocContext, String? state) {
                                  final bool isSelected = imagePath == state;
                                  return ExistingGoLiveProgramWidget(
                                    isSelected: isSelected,
                                    onTap: (bool isSelected) => blocContext.read<_PrivateBloc>().setBgImage(
                                      isSelected ? null : imagePath
                                    ),
                                    imagePic: imagePath
                                  );
                                }
                              );
                            }
                          );
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
    
        bottomSheet: BlocBuilder<_PrivateBloc, String?>(
          builder: (_, String? selectedImgPath) {
            return ATBlurredBgBtn(
              btnTitle: ATStrings.next,
              onPressed: selectedImgPath == null ? null : (){
                context.pushNamed(ATRoutes.SHOW_PREVIEW_SCREEN, extra: selectedImgPath);
              },
            );
          }
        )
      ),
    );
  }
}


class _RenderAShow extends StatelessWidget {
  const _RenderAShow({required this.hostedShow});
  final HostedShow hostedShow;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
        return BlocBuilder<_PrivateBloc, String?>(
          builder: (BuildContext blocContext, String? selectedImg) {
            final bool isSelected = hostedShow.coverUrl == selectedImg;
            return ATContainer(
              duration: 200,
              onTap: () => blocContext.read<_PrivateBloc>().setBgImage(
                isSelected ? null : hostedShow.coverUrl
              ),
              radius: 5,
              border: Border.all(
                color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
                width: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ATContainer(
                    radius: 5,
                    height: kst.maxHeight * 0.65,
                    width: context.screenWidth,
                    clipBehavior: Clip.hardEdge,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: ATImgLoader(
                        boxFit: BoxFit.fill,
                        imgPath: hostedShow.coverUrl ?? '',
                      ),
                    ),
                  ),
                  ATContainer(
                    padding: const EdgeInsets.only(top: 5),
                    color: isSelected ? ATColors.hex1F1F23 : ATColors.transparent,
                    child: Column(
                      children: <Widget>[
                        Text(
                          maxLines: 2,
                          hostedShow.title ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Created',
                              style: context.textTheme.titleSmall?.copyWith(
                                fontSize: ATSizes.size13,
                                color: ATColors.hexA8A8A8,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CircleAvatar(
                                radius: 2.5,
                                backgroundColor: ATColors.hexA8A8A8,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                ATHelperFuncs.formatDate(hostedShow.createdAt ?? ''),
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: ATColors.hexA8A8A8,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }
}

class _PrivateBloc extends Cubit<String?>{
  _PrivateBloc():super(null);

  void setBgImage(String? image) => emit(image);

}
