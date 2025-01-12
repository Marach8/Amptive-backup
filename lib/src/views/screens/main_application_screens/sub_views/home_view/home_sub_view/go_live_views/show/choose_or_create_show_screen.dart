import 'dart:ui';

import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/existing_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../../../utils/constants/colors.dart';

import '../../../../../../../../utils/dialogs/add_hastags_dialog.dart';
import '../../../../../../../../utils/dialogs/select_hand_raising_dialog.dart';

class AmptiveChooseOrCreateShowScreen extends StatefulWidget {
  const AmptiveChooseOrCreateShowScreen({super.key});

  @override
  State<AmptiveChooseOrCreateShowScreen> createState() => _AmptiveChooseOrCreateShowScreenState();
}

class _AmptiveChooseOrCreateShowScreenState extends State<AmptiveChooseOrCreateShowScreen> {
  ValueNotifier<bool> activateButton = ValueNotifier(false);
  ValueNotifier<String> selectedImage = ValueNotifier('');
  int? selectedIndex;

  late List<ValueNotifier<bool>> listOfValueNotifiers;
  final listOfImageStrings = [
    AmptiveImageStrings.CRIMINAL,
    AmptiveImageStrings.weCanDoHardThingsBgImage,
    AmptiveImageStrings.CRIMINAL,
    AmptiveImageStrings.weCanDoHardThingsBgImage,
    AmptiveImageStrings.CRIMINAL,
    AmptiveImageStrings.weCanDoHardThingsBgImage,
    AmptiveImageStrings.OFFICE_LADIES,
    AmptiveImageStrings.JOE_POMP_SHOW,
    ''
  ];

  @override 
  void initState(){
    super.initState();
    listOfValueNotifiers = List.generate(
      listOfImageStrings.length,
      (index) => ValueNotifier(false)
    );

    activateButton.addListener(
      () => !activateButton.value ? selectedImage.value = '' : {}
    );
  }
  
  @override 
  void dispose(){
    activateButton.dispose();
    selectedImage.dispose();
    for (var notifier in listOfValueNotifiers) {
      notifier.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: AmptiveRebuilderWidget(
                notifier: selectedImage,
                builder: (_, value, __) {
                  return AmptiveImageLoaderWidget(
                    imagePath: value,
                    boxFit: BoxFit.cover,
                  );
                }
              ),
            ),
            Positioned.fill(
              child: AmptiveCustomContainer(
                color: AmptiveColors.black.withOpacity(0.5),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 150.0, sigmaY: 150.0),
                  child: Container(
                    color: AmptiveColors.black.withOpacity(0.5),
                  )
                ),
              ),
            ),

            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  backgroundColor: AmptiveColors.brandBlack.withOpacity(0.8),
                  floating: true, //pinned: true,
                  leading: GestureDetector(
                    onTap: (){context.pop();},
                    child: const Icon(Icons.arrow_back_ios_new_outlined, size: 17,)
                  ),
                  centerTitle: true, leadingWidth: 40,
                  title: Text(
                    AmptiveOtherStrings.CHOOSE_SHOW,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 20),
                    child: Text(
                      maxLines: 3,
                      AmptiveOtherStrings.CHOOSE_OR_CREATE_SHOW,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AmptiveColors.subtitleColor
                      ),
                    ),
                  ),
                ),
            
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, gridIndex){
                        return LayoutBuilder(
                          builder: (_, constraints) {
                            if(gridIndex == listOfImageStrings.length - 1){
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AmptiveCustomContainer(
                                    onTap: (){
                                      activateButton.value = false;
                                      if(selectedIndex != null){
                                        listOfValueNotifiers.elementAt(selectedIndex!).value = false;                                    
                                      }
                                      context.pushNamed(AmptiveRoutes.CREATE_SHOW_FORM);
                                    },
                                    radius: 5.r,
                                    color: AmptiveColors.grey1Color,
                                    width: constraints.maxWidth,
                                    height: constraints.maxHeight * 0.7,
                                    child: Icon(Icons.add, size: 100.w),
                                  ),
                                  const Gap(5),
                                  Text(
                                    AmptiveOtherStrings.CREATE_NEW_SHOW,
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              );
                            }
            
                            final eachNotifier = listOfValueNotifiers.elementAt(gridIndex);
                            return AmptiveExistingShowWidget(
                              eachButtonNotifier: eachNotifier,
                              onTap: (isSelected){
                                //Toggle the border of the tapped item
                                eachNotifier.value = !isSelected;                           
                                //Set this variable to get hold of a property of the selected show
                                selectedImage.value = listOfImageStrings.elementAt(gridIndex);
                                //Unselect the previous selected show
                                if(selectedIndex != null && selectedIndex != gridIndex){
                                  listOfValueNotifiers.elementAt(selectedIndex!).value = false;
                                }
                                //Set the index to the index of the currently tapped show prior to next tap
                                selectedIndex = gridIndex;
                                //Toggle the activeness of the "Next" button
                                activateButton.value = !isSelected;
                              },
                              imageWidth: constraints.maxWidth,
                              imageHeight: constraints.maxHeight * 0.7,
                              trendingPicture: listOfImageStrings.elementAt(gridIndex)
                            );
                          }
                        );                    
                      },
                      childCount: listOfImageStrings.length
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        
        bottomNavigationBar: AmptiveRebuilderWidget(
          notifier: activateButton,
          builder: (_, activate, __) => AmptiveElevatedButtonWidget(
            onPressed: activate ? () async{
              //await showAddCoHostDialog(context);
              //await showAddHashtagDialog(context);
              //await showHandRaisingDialog(context);
              //showAddCommunitiesDialog(context);
              //showSelectAudienceAccessForShowsDialog(context);
              //context.pushNamed(AmptiveRoutes.CREATE_SHOW_SUCCESS);
            } : null,
            buttonTitle: AmptiveOtherStrings.NEXT,
            bgColor: AmptiveColors.whiteColor,
            fgColor: AmptiveColors.black,
          ),
        ),
      ),
    );
  }
}