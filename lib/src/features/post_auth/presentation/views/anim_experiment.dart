// import 'dart:developer' show log;
// import 'package:amptive/src/config/utils/colors.dart';
// import 'package:amptive/src/config/utils/font_weights.dart';
// import 'package:amptive/src/config/utils/image_strings.dart';
// import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
// import 'package:amptive/src/features/post_auth/presentation/views/new_file.dart';
// import 'package:amptive/src/features/post_auth/presentation/widgets/notification_card_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
// import 'package:flutter/material.dart';

// class AnimExperiment extends StatefulWidget {
//   const AnimExperiment({super.key});

//   @override
//   State<AnimExperiment> createState() => _AnimExperimentState();
// }

// class _AnimExperimentState extends State<AnimExperiment> with TickerProviderStateMixin {

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

//   late List<GlobalKey> _notifItemKeys;
//   late List<double> _notifItemsPositon4rmTop;
//   static const double _baseHeight = 150;
//   static const double _normalPicSize = 30;
//   static const double _normalTitleFontSize = 12;
//   static const double _normalTrailingFontSize = 10;

//   @override
//   void initState(){
//     super.initState();
//     _notifItemKeys = List<GlobalKey>.generate(_originalItems.length, (_) => GlobalKey());
//     _notifItemsPositon4rmTop = List<double>.filled(_originalItems.length, 0.0, growable: true);
//   }

//   @override
//   void didChangeDependencies(){
//     super.didChangeDependencies();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _initializePositions4rmTop());
//   }

//   void _initializePositions4rmTop(){
//     double cumulativeHeight = _baseHeight;

//     for (int i = 0; i < _notifItemKeys.length; i++) {
//       final BuildContext? context = _notifItemKeys[i].currentContext;
//       if (context == null) {
//         _notifItemsPositon4rmTop[i] = cumulativeHeight;
//         continue;
//       }

//       final RenderBox box = context.findRenderObject() as RenderBox;
//       final double itemHeight = box.size.height;
//       _notifItemsPositon4rmTop[i] = cumulativeHeight;
//       cumulativeHeight += itemHeight;
//     }

//     if(mounted){setState(() {});}
//   }

//   void _removeFirstItem() {
//     // setState(() {
//     //   _originalItems.removeAt(0);
//     //   _notifItemKeys.removeAt(0);
//     //   _notifItemsPositon4rmTop.removeAt(0);
//     // });
//     _originalItems.removeAt(0);
//     _notifItemKeys.removeAt(0);
//     _notifItemsPositon4rmTop.removeAt(0);
//     _initializePositions4rmTop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     log('--------------------------------');
//     return ATAnnotatedRegion(
//       child: Scaffold(
//         body: Column(
//           children: <Widget>[
//             const SizedBox(height: 50),
//             TextButton(
//               onPressed: () => _removeFirstItem(),
//               child: const Text('Start Animation'),
//             ),
//             Text(
//               'STAY ON THE LOOP', maxLines: 2,
//               textAlign: TextAlign.center,
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                 fontSize: 45,
//                 fontWeight: ATFontWeights.w800
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
//               child: Text(
//                 'Allow Amptive to send notifications of live audio shows & events ',
//                 textAlign: TextAlign.center,
//                 maxLines: 3,
//                 style: Theme.of(context).textTheme.bodySmall
//               ),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: Container(
//                 width: context.screenWidth * 0.85,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: const ShapeDecoration(
//                     color: Color(0xB50C0C0C),
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(width: 5, color: Color(0x4C323033)),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(40),
//                         topRight: Radius.circular(40),
//                       ),
//                     ),
//                     shadows: <BoxShadow>[
//                       BoxShadow(
//                         color: Color(0x3F000000),
//                         blurRadius: 4,
//                         offset: Offset(0, 4),
//                         spreadRadius: 0,
//                       )
//                     ],
//                   ),
//                   child: Stack(
//                     alignment: Alignment.center,
//                     children: <Widget>[
//                       Positioned(
//                         top: 20,
//                         child: ATContainer(
//                           width: 80, height: 18,
//                           color: ATColors.hex2F2F2F,
//                           radius: 30,
//                         )
//                       ),
//                       Positioned(
//                         top: _baseHeight,
//                         child: SizedBox(
//                           height: context.screenHeight * 0.5,
//                           width: context.screenWidth * 0.8,
//                           child: AnimatedListLoop(
//                             originalItems: _originalItems,
//                           ),
//                         )
//                       )

//                       // ..._originalItems.asMap().entries.map(
//                       //   (MapEntry<int, ({String description, String title})> entry) {
//                       //     final int index = entry.key;
//                       //     final ({String description, String title}) item = entry.value;

//                       //     final double scale = 1.0 - (0.1 * index);

//                       //     return AnimatedPositioned(
//                       //       duration: const Duration(milliseconds: 200),
//                       //       left: (index * 8) + 10,
//                       //       right: (index * 8) + 10,
//                       //       key: _notifItemKeys[index],
//                       //       top: _notifItemsPositon4rmTop[index],
//                       //       child: NotificationListener<SizeChangedLayoutNotification>(
//                       //         onNotification: (SizeChangedLayoutNotification notification){
//                       //           WidgetsBinding.instance.addPostFrameCallback((_) => _initializePositions4rmTop());
//                       //           return true;
//                       //         },
//                       //         child: SizeChangedLayoutNotifier(
//                       //           child: NotifTile(
//                       //             pictureSize: _normalPicSize * scale,
//                       //             titleFontSize: _normalTitleFontSize * scale,
//                       //             subTitleFontSize: _normalTitleFontSize * scale,
//                       //             timeFontSize: _normalTrailingFontSize * scale,
//                       //             title: item.title,
//                       //             subtitle: item.description,
//                       //           ),
//                       //         ),
//                       //       ),
//                       //     );
//                       //   }
//                       // )
//                     ]
//                   )
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AnimatedListLoop extends StatefulWidget {
//   const AnimatedListLoop({super.key, required this.originalItems});
//   final List<({String title, String description})> originalItems;

//   @override
//   State<AnimatedListLoop> createState() => _AnimatedListLoopState();
// }

// class _AnimatedListLoopState extends State<AnimatedListLoop> {
//   final GlobalKey<AnimatedListState> _animListKey = GlobalKey<AnimatedListState>();
//   static const double _baseHeight = 150;
//   static const double _normalPicSize = 30;
//   static const double _normalTitleFontSize = 12;
//   static const double _normalTrailingFontSize = 10;

//   void addItem(({String title, String description}) item) {
//     final index = widget.originalItems.length;
//     widget.originalItems.add(item);
//     _animListKey.currentState?.insertItem(index);
//   }

//   void removeFirstItemAndAppendToEnd() {
//     if (widget.originalItems.isEmpty) return;

//     final removedItem = widget.originalItems.first;
//     widget.originalItems.removeAt(0);

//     _animListKey.currentState?.removeItem(
//       0,
//       (context, animation) {
//         // Optional: mimic the scaling effect from your builder
//         final double scale = 1.0; //- (0.1 * widget.originalItems.length);

//         return RemoveAnimatedItem(
//           animation: animation,
//           child: NotifTile(
//             horizMargin: 0.0,
//             pictureSize: _normalPicSize * scale,
//             titleFontSize: _normalTitleFontSize * scale,
//             subTitleFontSize: _normalTitleFontSize * scale,
//             timeFontSize: _normalTrailingFontSize * scale,
//             title: removedItem.title,
//             subtitle: removedItem.description,
//           ),
//         );
//       },
//       duration: const Duration(milliseconds: 400),
//     );

//     // // Wait for the remove animation to finish before inserting
//     // Future.delayed(const Duration(milliseconds: 400), () {
//     //   addItem(removedItem);
//     // });
//   }

//   // Widget _buildItem(String item, Animation<double> animation) {
//   //   return SizeTransition(
//   //     sizeFactor: animation,
//   //     child: Card(
//   //       margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
//   //       child: ListTile(
//   //         title: Text(item),
//   //       ),
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         GestureDetector(
//           onTap: (){
//             removeFirstItemAndAppendToEnd();
//           },
//           child: const Icon(Icons.play_arrow),
//         ),
//         Expanded(
//           child: AnimatedList(
//             key: _animListKey,

//             initialItemCount: widget.originalItems.length,
//             itemBuilder: (context, index, animation) {
//               final item = widget.originalItems.elementAt(index);
//               final double scale = 1.0 - (0.1 * index);

//               return NotifTile(
//                 horizMargin: (index * 8) + 10,
//                 pictureSize: _normalPicSize * scale,
//                 titleFontSize: _normalTitleFontSize * scale,
//                 subTitleFontSize: _normalTitleFontSize * scale,
//                 timeFontSize: _normalTrailingFontSize * scale,
//                 title: item.title,
//                 subtitle: item.description,
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

// class RemoveAnimatedItem extends StatelessWidget {
//   final Animation<double> animation;
//   final Widget child;

//   const RemoveAnimatedItem({
//     super.key,
//     required this.animation,
//     required this.child,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final slideAnimation = Tween<Offset>(
//       begin: Offset.zero,
//       end: const Offset(0, -1), // Up by full height
//     ).animate(animation);

//     final scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(animation);

//     return AnimatedBuilder(
//       animation: animation,
//       builder: (context, _) {
//         return FractionalTranslation(
//           translation: slideAnimation.value,
//           child: Transform.scale(
//             scale: scaleAnimation.value,
//             child: child,
//           ),
//         );
//       },
//     );
//   }
// }
