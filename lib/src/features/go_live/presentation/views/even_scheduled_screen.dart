// import 'package:amptive/src/config/utils/font_sizes.dart';
// import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../config/utils/colors.dart';
// import '../../../../config/utils/other_strings.dart';
// import '../../../../views/widgets/animation_widgets/other_animation_widgets/animated_create_show_success_image.dart';
// import '../../../../views/widgets/common_widgets/app_bar_widget.dart';
// import '../../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
// import '../../../../views/widgets/common_widgets/elevated_button_widget.dart';
// import '../../../../views/widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_go_live/shows/show_type_visibility.dart';

// class AmptiveShowScheduledScreen extends StatefulWidget {

//   AmptiveShowScheduledScreen(
//       {super.key, showType = ShowType.event, required this.imageFilePath}) {
//     if (showType == ShowType.all || showType == ShowType.show) {
//       this.showType = ShowType.event;
//     } else {
//       this.showType = showType;
//     }
//   }
//   late final ShowType showType;
//   final String imageFilePath;

//   @override
//   State<AmptiveShowScheduledScreen> createState() =>
//       _AmptiveShowScheduledScreenState();
// }

// class _AmptiveShowScheduledScreenState
//     extends State<AmptiveShowScheduledScreen> {
//   late ShowType _showType;
//   BoxFit imageFit = BoxFit.cover;
//   final ValueNotifier<double> _normalSize = ValueNotifier(700.0);

//   @override
//   void initState() {
//     super.initState();
//     _showType = widget.showType;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       imageFit = BoxFit.contain;
//       _normalSize.value = 140.0;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ATAnnotatedRegion(
//       child: Scaffold(
//         appBar: ATAppBar(
//           leading: GestureDetector(
//               onTap: () {
//                 context.pop();
//               },
//               child: const Icon(
//                 Icons.close,
//                 size: 20,
//               )),
//           leadingWidth: 20,
//         ),
//         body: Align(
//           alignment: Alignment.topCenter,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(15),
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: <Widget>[
//                 ATCircleAvatar(
//                   diameter: 45,
//                   color: ATColors.white,
//                   child: Icon(
//                     Icons.calendar_today_outlined,
//                     color: ATColors.black,
//                   ),
//                 ),
//                 const Gap(5),
//                 Text(
//                     isEvent
//                         ? ATStrings.EVENT_SCHEDULED
//                         : 'Your Episode is scheduled!',
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyLarge
//                         ?.copyWith(fontSize: ATFontSizes.size23)),
//                 Text(
//                     isEvent
//                         ? ATStrings.SHARE_EVENT_LINK
//                         : 'Share your episode link to build excitement and attract more attendees.',
//                     maxLines: 2,
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.titleMedium),
//                 const Gap(30),
//                 AmptiveRebuilderWidget(
//                   notifier: _normalSize,
//                   builder: (_, double val, __) {
//                     return AnimatedCreateShowSuccessImage(
//                       width: val,
//                       height: val,
//                       imageFit: imageFit,
//                       imagePath: widget.imageFilePath,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         bottomNavigationBar: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             AmptiveElevatedButtonWidget(
//               onPressed: () {},
//               buttonTitle:
//                   isEvent ? ATStrings.SHARE_EVENT : 'Share episode',
//               bgColor: ATColors.white,
//               fgColor: ATColors.black,
//             ),
//             const Gap(10),
//             GestureDetector(
//               onTap: () {},
//               child: Text(
//                   isEvent
//                       ? ATStrings.VIEW_EVENT_PAGE
//                       : 'View episode page',
//                   style: Theme.of(context).textTheme.bodyMedium),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   bool get isEvent => _showType == ShowType.event;
// }
