import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/animated_slide.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../views/widgets/common_widgets/custom_container_widget.dart';


class MainAppBottomNav extends StatelessWidget {
  const MainAppBottomNav({super.key});

  static final List<List<String>> listOfIcons = <List<String>>[
    <String>[ATImgStrings.filledHome, ATImgStrings.outlinedHome],
    <String>[ATImgStrings.filledSearch, ATImgStrings.OUTLINED_SEARCH],
    <String>[ATImgStrings.filledBroadCast, ATImgStrings.outlinedBroadCast],
    <String>[ATImgStrings.filledBell, ATImgStrings.outlinedBell],
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ATNavBarBloc, (int, bool)>(
      builder: (_, (int, bool) state) {
        return ATAnimatedSlide(
          condition: state.$2,
          startOffset: const Offset(0, 1.5),
          endOffset: const Offset(0, 0),
          child: ATContainer(
            color: ATColors.black,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: listOfIcons.map(
                (List<String> list){
                  final int index = listOfIcons.indexOf(list);
                  if(index == 3){
                    return Stack(
                      children: <Widget>[
                        _BottomNavItem(
                          selectedImagePath: list.first,
                          unselectedImagePath: list.last,
                          itemIdentityIndex: index,
                        ),
                        Positioned(
                          top: 0, right: 0,
                          child: ATContainer(
                            padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                            constraints: const BoxConstraints(minWidth: 15),
                            height: 15, radius: 100,
                            color: ATColors.hexECO404,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '3', textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size10
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  }
          
                  return _BottomNavItem(
                    selectedImagePath: list.first,
                    unselectedImagePath: list.last,
                    itemIdentityIndex: index,
                  );
                }
              ).toList()
            ),
          ),
        );
      }
    );
  }
}




class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.selectedImagePath,
    required this.unselectedImagePath,
    required this.itemIdentityIndex,
  });

  final String selectedImagePath, unselectedImagePath;
  final int itemIdentityIndex;


  @override
  Widget build(BuildContext context) {
    return BlocSelector<ATNavBarBloc, (int, bool), int>(
      selector: ((int, bool) state) => state.$1,
      builder: (_, int currentNavIndex) {
        final bool isSelected = itemIdentityIndex == currentNavIndex;
        return GestureDetector(
          onTap: (){
            context.read<ATNavBarBloc>().goToPage(itemIdentityIndex, context);
          },
          child: ATAnimatedXFade(
            condition: isSelected,
            firstChild: ATImgLoader(imgPath: selectedImagePath),
            secondChild: ATImgLoader(imgPath: unselectedImagePath)
          ),
        );
      }
    );
  }
}




class ATNavBarBloc extends Cubit<(int, bool)>{
  ATNavBarBloc(): super((0, true));

  bool ctrlNavVisibility(ScrollNotification notif){
    if (notif is ScrollUpdateNotification) {
      if (notif.dragDetails != null) {

        if (notif.dragDetails!.delta.dy > 0) {
          emit((state.$1, true));
        } 
        else if (notif.dragDetails!.delta.dy < 0) {
          emit((state.$1, false));
        }
      } 
    }

    return true;
  }
  
  void goToPage(int index, BuildContext context){
    final int prevIndex = state.$1;
    emit((index, state.$2));
    if(index == 2){
      context.pushNamed(ATRoutes.GO_LIVE_TYPE_SELECTION);
      emit((prevIndex, false));
    }
    else{
      emit((index, state.$2));
    }
  }
}