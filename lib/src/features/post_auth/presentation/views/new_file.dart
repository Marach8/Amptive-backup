// import 'dart:developer' show log;
// import 'package:amptive/src/config/utils/colors.dart';
// import 'package:amptive/src/config/utils/font_weights.dart';
// import 'package:amptive/src/config/utils/image_strings.dart';
// import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
// import 'package:amptive/src/features/post_auth/presentation/views/new_file.dart';
// import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
// import 'package:flutter/material.dart';

// import '../widgets/notification_card_widget.dart';

// class AnimExperiment1 extends StatefulWidget {
//   const AnimExperiment1({super.key});

//   @override
//   State<AnimExperiment1> createState() => _AnimExperimentState();
// }

// class _AnimExperimentState extends State<AnimExperiment1> with TickerProviderStateMixin {

//   final List<({String title, String description})> _originalItems = <({String title, String description})>[
//     (
//       title: 'Anything you want make you do',
//       description: 'The power of desire is immense, capable of driving individuals to achieve extraordinary feats or, conversely, lead them astray.'
//     ),
//     (
//       title: 'How you go talk like that',
//       description: 'The'
//     ),
//     (
//       title: 'Did I call you to come?',
//       description: 'Uninvited presence can sometimes lead to awkward situations, highlighting the importance of clear invitations and boundaries.'
//     ),
//     (
//       title: 'Nwanne mind your biznaess',
//       description: 'In many'
//     ),
//     (
//       title: 'As far as then no kill God',
//       description: 'This phrase suggests a profound sense of resilience',
//     ),
//     (
//       title: 'You are good in the name',
//       description: 'A compliment suggesting proficiency or skill, often implying that someone lives up to their reputation or the expectations associated with their identity.'
//     ),
//   ];

//   final GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
//   static const double _normalPicSize = 30;
//   static const double _normalTitleFontSize = 12;
//   static const double _normalTrailingFontSize = 10;
//   static const int _slideOutDuration = 1000;
//   final Tween<Offset> slideOutTween = Tween<Offset>(
//     end: Offset.zero, begin: const Offset(0, -3.0)
//   );
//   final Tween<double> scaleOutTween = Tween<double>(begin: 0.5, end: 1.0);

//   void addItem(({String title, String description}) item) {
//     final int index = _originalItems.length;
//     _originalItems.add(item);
//     _animListKey.currentState?.insertItem(index);
//   }

//   void removeFirstItemAndAppendToEnd() {
//     if (_originalItems.isEmpty) return;

//     final dynamic removedItem = _originalItems.first;
//     _originalItems.removeAt(0);

//     _animListKey.currentState?.removeItem(
//       0,
//       (_, Animation<double> animation) {
//         return SlideTransition(
//           position: animation.drive(slideOutTween),
//           child: ScaleTransition(
//             scale: animation.drive(scaleOutTween),
//             child: NotifTile(
//               horizMargin: 10,
//               pictureSize: _normalPicSize,
//               titleFontSize: _normalTitleFontSize,
//               subTitleFontSize: _normalTitleFontSize,
//               timeFontSize: _normalTrailingFontSize,
//               title: removedItem.title,
//               subtitle: removedItem.description,
//             ),
//           ),
//         );
//       },
//       duration: const Duration(milliseconds: _slideOutDuration),
//     );
    
//     Future<void>.delayed(
//       const Duration(milliseconds: _slideOutDuration),
//       () => addItem(removedItem)
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ATAnnotatedRegion(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.only(top: kToolbarHeight),
//           child: Column(
//             children: <Widget>[
//               Text(
//                 'STAY ON THE LOOP', maxLines: 2,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   fontSize: 45,
//                   fontWeight: ATFontWeights.w800
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
//                 child: Text(
//                   'Allow Amptive to send notifications of live audio shows & events ',
//                   textAlign: TextAlign.center,
//                   maxLines: 3,
//                   style: Theme.of(context).textTheme.bodySmall
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Expanded(
//                 child: Container(
//                   width: context.screenWidth * 0.85,
//                     //clipBehavior: Clip.antiAlias,
//                     decoration: BoxDecoration(
//                       color: ATColors.hex0D0D0D.withValues(alpha: 0.71),
//                       border: Border.all(width: 5, color: ATColors.hex323033.withValues(alpha: 0.3)),
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40),
//                       ),
//                     ),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: <Widget>[                      
//                         AnimatedList(
//                           padding: const EdgeInsets.fromLTRB(0, 130, 0, 20),
//                           key: _animListKey,
//                           physics: const NeverScrollableScrollPhysics(),
//                           initialItemCount: _originalItems.length,
//                           itemBuilder: (_, int index, __) {
//                             final dynamic item = _originalItems.elementAt(index);
//                             final double scale = 1.0 - (0.1 * index);                      
//                             return NotifTile(
//                               horizMargin: (index * 8) + 10,
//                               pictureSize: _normalPicSize * scale,
//                               titleFontSize: _normalTitleFontSize * scale,
//                               subTitleFontSize: _normalTitleFontSize * scale,
//                               timeFontSize: _normalTrailingFontSize * scale,
//                               title: item.title,
//                               subtitle: item.description,
//                             );
//                           },
//                         ),
//                         Positioned(
//                           top: 20,
//                           child: ATContainer(
//                             width: 80, height: 18,
//                             color: ATColors.hex2F2F2F,
//                             radius: 30,
//                           )
//                         ),
//                       ]
//                     )
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

