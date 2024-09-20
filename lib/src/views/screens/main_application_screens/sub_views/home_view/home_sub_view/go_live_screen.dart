import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/font_sizes.dart';
import '../../../../../widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';

class AmptiveGoLiveScreen extends StatelessWidget {
  const AmptiveGoLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> activateButton = ValueNotifier(false);
    
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          leading: GestureDetector(
            onTap: (){context.pop();},
            child: const Icon(Icons.close, size: 20,)
          ),
          leadingWidth: 20,
          title: Text(
            AmptiveOtherStrings.CREATE_SHOW_OR_EVENT,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),

        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 3,
                AmptiveOtherStrings.CHOOSE_2_CREATE_SHOW_OR_EVENT,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AmptiveColors.subtitleColor
                ),
              ),
              Gap(20.h),
              const Row(
                children: [
                  Expanded(
                    child: AmptiveShowOrEventSelectionModel(
                      //isSelected: isSelected,
                      defaultImagePath: AmptiveImageStrings.event4,
                      onSelectedImagePath: AmptiveImageStrings.event3,
                      title: AmptiveOtherStrings.CREATE_SHOW,
                      subtitle: AmptiveOtherStrings.CREATE_SHOW_DESC,
                      alphabet: 'S',
                    ),
                  ),
                  Gap(15),
                  Expanded(
                    child: AmptiveShowOrEventSelectionModel(
                      //isSelected: isSelected,
                      defaultImagePath: AmptiveImageStrings.event2,
                      onSelectedImagePath: AmptiveImageStrings.event1,
                      title: AmptiveOtherStrings.CREATE_SHOW,
                      subtitle: AmptiveOtherStrings.CREATE_SHOW_DESC,
                      alphabet: 'E',
                    ),
                  )
                ],
              )
            ],
          ),
        ),

        
        bottomNavigationBar: AmptiveRebuilderWidget(
          notifier: activateButton,
          builder: (_, activate, __) => AmptiveElevatedButtonWidget(
            onPressed: activate ? (){} : null,
            buttonTitle: AmptiveOtherStrings.CONTINUE,
            bgColor: AmptiveColors.whiteColor,
            fgColor: AmptiveColors.black,
          ),
        ),
      ),
    );
  }
}




class AmptiveShowOrEventSelectionModel extends StatefulWidget {
  final String defaultImagePath, onSelectedImagePath,
  title, subtitle, alphabet;
  //final  ValueNotifier<bool> isSelected;
  const AmptiveShowOrEventSelectionModel({
    super.key,
    //required this.isSelected,
    required this.defaultImagePath,
    required this.onSelectedImagePath,
    required this.subtitle,
    required this.alphabet,
    required this.title
  });

  @override
  State<AmptiveShowOrEventSelectionModel> createState() => _AmptiveShowOrEventSelectionModelState();
}

class _AmptiveShowOrEventSelectionModelState extends State<AmptiveShowOrEventSelectionModel> 
with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showWidgetB = false;

   @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

   void _toggleWidget() {
    if (_showWidgetB) {
      _controller.reverse().then((value) {
        setState(() {
          _showWidgetB = false;
        });
      });
    } else {
      setState(() {
        _showWidgetB = true;
      });
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    //ValueNotifier<bool> isSelected = ValueNotifier(false);
    return GestureDetector(
      onTap: () => _toggleWidget(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AmptiveCustomContainer(
            radius: 5,
            color: !_showWidgetB ? AmptiveColors.brandBlueColor: const Color(0xFF1F1F23),
            child: AmptiveFadingAnimatedSwitcherWidget(
              duration: 500,
              child: !_showWidgetB
                ? AmptiveImageLoaderWidget(
                  key: UniqueKey(),
                  imagePath: widget.defaultImagePath,
                  boxFit: BoxFit.fill,
                )
                : ScaleTransition(
                  scale: _animation,
                  child: AmptiveImageLoaderWidget(
                    key: UniqueKey(),
                    imagePath: widget.onSelectedImagePath,
                    boxFit: BoxFit.fill,
                  ),
                )
            ),
          ),
          // AmptiveAnimatedCrossFadeWidget(
          //   condition: value,
          //   secondChild: AmptiveImageLoaderWidget(
          //     boxFit: BoxFit.fill,
          //     imagePath: defaultImagePath
          //   ),
          //   firstChild: AmptiveImageLoaderWidget(
          //     imagePath: onSelectedImagePath,
          //     boxFit: BoxFit.fill,
          //   )
          // ),
          Gap(20.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AmptiveCirceAvatarWidget(
                diameter: 20,
                color: AmptiveColors.orangeGradientColorA,
              ),
              const Gap(5),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: AmptiveFontSizes.size13
                ),
              )
            ],
          ),
          const Gap(7),
          Text(
            maxLines: 2,
            widget.subtitle,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AmptiveColors.subtitleColor
            ),
          )
        ],
      ),
    );
  }
}




// class AmptiveShowOrEventSelectionModel extends StatefulWidget {
//   final String defaultImagePath, onSelectedImagePath,
//   title, subtitle, alphabet;
//   //final  ValueNotifier<bool> isSelected;
//   const AmptiveShowOrEventSelectionModel({
//     super.key,
//     //required this.isSelected,
//     required this.defaultImagePath,
//     required this.onSelectedImagePath,
//     required this.subtitle,
//     required this.alphabet,
//     required this.title
//   });

//   @override
//   State<AmptiveShowOrEventSelectionModel> createState() => _AmptiveShowOrEventSelectionModelState();
// }

// class _AmptiveShowOrEventSelectionModelState extends State<AmptiveShowOrEventSelectionModel> 
// with SingleTickerProviderStateMixin{
//   late AnimationController _controller;
//   late Animation<double> _animation;

//    @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 1),
//       vsync: this,
//     );
//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     ValueNotifier<bool> isSelected = ValueNotifier(false);
//     return AmptiveRebuilderWidget(
//       notifier: isSelected,
//       builder: (_, value, __){
//         return GestureDetector(
//           onTap: () => isSelected.value = !value,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AmptiveCustomContainer(
//                 radius: 5,
//                 color: const Color(0xFF1F1F23),
//                 child: AmptiveFadingAnimatedSwitcherWidget(
//                   child: value 
//                     ? AmptiveImageLoaderWidget(
//                       key: UniqueKey(),
//                       imagePath: widget.onSelectedImagePath,
//                       boxFit: BoxFit.fill,
//                     )
//                     : ScaleTransition(
//                       scale: _animation,
//                       child: AmptiveImageLoaderWidget(
//                         key: UniqueKey(),
//                         imagePath: widget.defaultImagePath,
//                         boxFit: BoxFit.fill,
//                       ),
//                     )
//                 ),
//               ),
//               // AmptiveAnimatedCrossFadeWidget(
//               //   condition: value,
//               //   secondChild: AmptiveImageLoaderWidget(
//               //     boxFit: BoxFit.fill,
//               //     imagePath: defaultImagePath
//               //   ),
//               //   firstChild: AmptiveImageLoaderWidget(
//               //     imagePath: onSelectedImagePath,
//               //     boxFit: BoxFit.fill,
//               //   )
//               // ),
//               Gap(20.h),
//               Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   AmptiveCirceAvatarWidget(
//                     diameter: 20,
//                     color: AmptiveColors.orangeGradientColorA,
//                   ),
//                   const Gap(5),
//                   Text(
//                     widget.title,
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                       fontSize: AmptiveFontSizes.size13
//                     ),
//                   )
//                 ],
//               ),
//               const Gap(7),
//               Text(
//                 maxLines: 2,
//                 widget.subtitle,
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: AmptiveColors.subtitleColor
//                 ),
//               )
//             ],
//           ),
//         );
//       }
//     );
//   }
// }

