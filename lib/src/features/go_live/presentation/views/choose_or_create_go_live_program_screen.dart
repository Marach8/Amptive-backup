import 'dart:ui';

import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/existing_go_live_program_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import '../../../../config/utils/colors.dart';
import 'package:amptive/src/features/home/presentation/widgets/home_widgets_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


enum GoLiveProgramType {event, show}

class ChooseOrCreateGoLiveProgramScreen extends StatelessWidget {
  const ChooseOrCreateGoLiveProgramScreen({
    super.key,
    required this.programType
  });

  final GoLiveProgramType programType;

  static const List<String> listOfImageStrings = <String>[
    '',
    ATImgStrings.CRIMINAL,
    ATImgStrings.weCanDoHardThingsBgImage,
    ATImgStrings.CRIMINAL,
    ATImgStrings.weCanDoHardThingsBgImage,
    ATImgStrings.CRIMINAL,
    ATImgStrings.weCanDoHardThingsBgImage,
    ATImgStrings.OFFICE_LADIES,
    ATImgStrings.JOE_POMP_SHOW,
  ];

  @override
  Widget build(BuildContext context) {
    final bool isShow = programType == GoLiveProgramType.show;
    final double blurredHeaderHeight = kToolbarHeight + MediaQuery.paddingOf(context).top;

    return MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<BlurredHeaderBloc>(create: (_) => BlurredHeaderBloc(),),
        BlocProvider<_PrivateBloc>(create: (_) => _PrivateBloc())
      ],
      child: ATAnnotatedRegion(
        statusBarColor: ATColors.trsprnt,
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
                          imageFilter: ImageFilter.blur(sigmaX: 250, sigmaY: 250),
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
                              maxExt: blurredHeaderHeight, minExt: blurredHeaderHeight,
                              child: SizedBox(
                                height: blurredHeaderHeight,
                                child: ATBlurredHeaderWidget(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: ATRoundedBackBtn(bgColor: ATColors.trsprnt,),
                                      ),
                                      Text(
                                        isShow ? ATStrings.CHOOSE_SHOW : ATStrings.CHOOSE_EVENT,
                                        style: Theme.of(context).textTheme.bodyMedium,
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
                                isShow ? ATStrings.CHOOSE_OR_CREATE_SHOW_DESC : ATStrings.CHOOSE_OR_CREATE_EVENT_DESC,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: ATColors.hexC2C2C2
                                ),
                              ),
                            ),
                          ),
                        ],
                        
                        body: GridView.builder(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 100),
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.7,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20
                          ),
                          itemCount: listOfImageStrings.length,
                          itemBuilder: (_, int gridIndex){
                            final String imagePath = listOfImageStrings.elementAt(gridIndex);
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
                                        isShow ? ATStrings.CREATE_NEW_SHOW : ATStrings.CREATE_NEW_EVENT,
                                        style: Theme.of(context).textTheme.bodyMedium,
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
                        )
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
          
          resizeToAvoidBottomInset: false,

          bottomSheet: ATContainer(
            height: 70,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                ATColors.hex0D0D0D.withValues(alpha: 0.1),
                ATColors.hex0D0D0D
              ]
            ),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: BlocBuilder<_PrivateBloc, String?>(
              builder: (_, String? selectedImgPath) {
                return ATPlainElevatedBtn(
                  bgColor: ATColors.white,
                  fgColor: ATColors.hex0D0D0D,
                  btnTitle: ATStrings.NEXT,
                  onPressed: selectedImgPath == null ? null : () async{
                    //await showAddCoHostDialog(context);
                    //await showAddHashtagDialog(context);
                    //await showHandRaisingDialog(context);
                    //showAddCommunitiesDialog(context);
                    //showSelectAudienceAccessForShowsDialog(context);
                    //context.pushNamed(AmptiveRoutes.CREATE_SHOW_SUCCESS);
                  },
                  
                  //onPressed: activate ? () async{
                    //await showAddCoHostDialog(context);
                    //await showAddHashtagDialog(context);
                    //showAddCommunitiesDialog(context);
                    //showSelectAudienceAccessForEventsDialog(context);
                    //showWhispersDialog(context);
                    //await showEventCapacitySelectionDialog(context: context);
                    //context.pushNamed(ATRoutes.EVENT_SCHEDULED_SCREEN);
                  //} : null,
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}


class _PrivateBloc extends Cubit<String?>{
  _PrivateBloc():super(null);

  void setBgImage(String? image) => emit(image);

}