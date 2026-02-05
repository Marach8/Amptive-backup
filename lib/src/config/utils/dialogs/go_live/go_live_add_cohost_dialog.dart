// import 'dart:io';
// import 'dart:ui';
// import 'package:amptive/src/bloc/main_app/go_live_bloc/host_view/cohosts_display_bloc.dart';
// import 'package:amptive/src/config/utils/colors.dart';
// import 'package:amptive/src/config/utils/font_sizes.dart';
// import 'package:amptive/src/config/utils/helper_functions.dart';
// import 'package:amptive/src/config/utils/other_strings.dart';
// import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:gap/gap.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../bloc/main_app/go_live_bloc/host_view/available_cohosts_bloc.dart';
// import '../../../../models/host.dart';
// import '../../../../services/create_show/create_show_service.dart';
// import '../../../../views/widgets/common_widgets/loading_indicator.dart';
// import '../../../../views/widgets/common_widgets/custom_rebuilder_widget.dart';
// import '../../../../shared/elevated_button_widget.dart';


// Future<bool?> showGoLiveHostAddCoHostDialog({
//   required BuildContext context,
// }) async {
// final FocusNode focusNode = FocusNode();
// final TextEditingController controller = TextEditingController();

// final ValueNotifier<bool> showSuffixIconNotifier = ValueNotifier(false);
//   focusNode.addListener(
//     () => focusNode.hasFocus
//       ? showSuffixIconNotifier.value = true
//       : showSuffixIconNotifier.value = false
//   );

//   return await showModalBottomSheet<bool>(
//       backgroundColor: ATColors.hex202020,
//       constraints: BoxConstraints.expand(
//         height: ATHelperFuncs.getScreenHeight(context)
//       ),
//       context: context,
//       isScrollControlled: true,
//       useSafeArea: true,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       builder: (BuildContext context) {
//         return BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//           child: Stack(
//             children: <Widget>[
//               Positioned.fill(
//                 child: SingleChildScrollView(
//                   physics: const BouncingScrollPhysics(),
//                   padding: EdgeInsets.only(
//                     bottom: MediaQuery.viewInsetsOf(context).bottom,
//                     left: 15, right: 15, top: 20.h
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Center(
//                         child: GestureDetector(
//                           onTap: () => context.pop(false),
//                           child: Platform.isAndroid
//                               ? Icon(
//                                   Icons.keyboard_arrow_down,
//                                   color: ATColors.white.withOpacity(0.6),
//                                 )
//                               : ATContainer(
//                                   margin: const EdgeInsets.symmetric(vertical: 10),
//                                   radius: 5, height: 4, width: 30,
//                                   color: ATColors.white.withOpacity(0.6),
//                                   child: const SizedBox.shrink(),
//                                 ),
//                           ),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: <Widget>[
//                             Text(
//                               ATStrings.ADD_CO_HOST,
//                               style: Theme.of(context).textTheme.bodyLarge,
//                             ),
//                             Gap(60.w),
//                             BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
//                               builder: (_, List<ObjectWithNotifier<Host>> listOfCoHosts) {
//                                 final int number = listOfCoHosts.where(
//                                   (ObjectWithNotifier<Host> coHost) => (coHost.obj.profilePicture ?? '').isNotEmpty
//                                 ).length;
          
//                                 return Text(
//                                   '$number ${ATStrings.SELECTED}',
//                                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                     color: ATColors.hexC2C2C2
//                                   ),
//                                 );
//                               }
//                             ),
//                           ],
//                         ),
//                         const Gap(20),
          
//                         Text(
//                           maxLines: 3,
//                           ATStrings.ADD_COHOST_DESC,
//                           style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                             color: ATColors.hexC2C2C2
//                           ),
//                         ),
//                         const Gap(20),
          
//                         // search SEARCH
//                         ATTextFormField(
//                           controller: controller,
//                           focusNode: focusNode,
//                           disableBlueBorder: true,
//                           onChanged: (String text) => ATHelperFuncs.callDebouncer(
//                             200,
//                             () => context.read<AmptiveGoLiveAvailableCoHostsBloc>().add(
//                               SearchCohostEvent(searchKey: text)
//                             ),
//                           ),
//                           hintText: ATStrings.SEARCH_4_COHOSTS,
//                           prefixConstraints: const BoxConstraints(maxWidth: 50),
//                           prefixIcon: const Padding(
//                             padding: EdgeInsets.symmetric(horizontal: 15),
//                             child: Icon(Iconsax.search_normal_14),
//                           ),
//                           suffixIcon: AmptiveRebuilderWidget(
//                             notifier: showSuffixIconNotifier,
//                             builder: (_, bool shouldShow, __) {
//                               return ATAnimatedXFade(
//                                 condition: shouldShow,
//                                 secondChild: const SizedBox.shrink(),
//                                 firstChild: GestureDetector(
//                                   onTap: () => controller.clear(),
//                                   child: const Padding(
//                                     padding: EdgeInsets.only(right: 10),
//                                     child: Icon(Icons.close, size: 20),
//                                   ),
//                                 ),
//                               );
//                             }
//                           ),
//                         ),
          
          
//                         BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
//                           builder: (_, List<ObjectWithNotifier<Host>> listOfCohosts) {
//                             final bool showSelectedCohosts = listOfCohosts.any(
//                               (ObjectWithNotifier<Host> cohost) => (cohost.obj.profilePicture ?? '').isNotEmpty
//                             );
          
//                             return ATAnimatedXFade(
//                               condition: showSelectedCohosts,
//                               secondChild: const SizedBox.shrink(),
//                               firstChild: ATContainer(
//                                 height: 43, alignment: Alignment.center,
//                                 margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
//                                 child: SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     children: listOfCohosts.map(
//                                       (ObjectWithNotifier<Host> cohost) {
//                                         final bool showCoHost = (cohost.obj.profilePicture ?? '').isNotEmpty;
//                                         final int index = listOfCohosts.indexOf(cohost);
                                        
//                                         if(!showCoHost){
//                                           return ATContainer(
//                                             alignment: Alignment.center,
//                                             margin: const EdgeInsets.only(right: 15),
//                                             border: Border.all(color: ATColors.white.withOpacity(0.4)),
//                                             height: 43, width: 43, radius: 30,
//                                             child: Text(
//                                               (index + 1).toString(),
//                                               style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                                                 fontSize: ATFontSizes.size12
//                                               ),
//                                             ),
//                                           );
//                                         }
                                  
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 15),
//                                           child: Stack(
//                                             clipBehavior: Clip.none,
//                                             children: <Widget>[
//                                               ATContainer(
//                                                 clipBehavior: Clip.hardEdge,
//                                                 height: 43, width: 43, radius: 30,
//                                                 child: FittedBox(
//                                                   fit: BoxFit.fill,
//                                                   child: ATImgLoader(
//                                                     imgPath: cohost.obj.profilePicture ?? ''
//                                                   )
//                                                 ),
//                                               ),
//                                               Positioned(
//                                                 top: 0, right: -4, 
//                                                 child: ATContainer(
//                                                   onTap: () => context.read<AmptiveGoLiveSelectCoHostBloc>()
//                                                     .hostRemoveCohost(cohost),
//                                                   color: ATColors.textRedColor,
//                                                   height: 17, width: 17,
//                                                   boxShape: BoxShape.circle,
//                                                   child: const FittedBox(
//                                                     fit: BoxFit.scaleDown,
//                                                     child: Icon(Icons.close)
//                                                   ),
//                                                 ),
//                                               )
//                                             ],
//                                           ),
//                                         );
//                                         }
//                                       ).toList(),
//                                     )
//                                   )
//                               ),
//                             );
//                           },
//                         ),
//                         const Gap(20),
          
//                         //Column of cohosts
//                         BlocBuilder<AmptiveGoLiveAvailableCoHostsBloc, AmptiveCohostsState>(
//                           builder: (_, AmptiveCohostsState cohostState) {
//                             if(cohostState is CohostsLoadingState){
//                               return const ATLoadingIndicator();
//                             }
                            
//                             return AmptiveListOfCoHostsWidget(
//                               availableCoHosts: cohostState.cohosts ?? <ObjectWithNotifier<Host>>[]
//                             );
//                           }
//                         ),
//                         Gap(100.h)
//                       ]),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: SizedBox(
//                   height: 80.h,
//                   width: ATHelperFuncs.getScreenWidth(context),
//                   child: ClipRect(
//                     child: BackdropFilter(
//                       filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
//                       child: const SizedBox(height: 100)
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 child: ATContainer(
//                   height: 50.h,
//                   padding: const EdgeInsets.symmetric(horizontal: 15),
//                   width: ATHelperFuncs.getScreenWidth(context),
//                   child: BlocBuilder<AmptiveGoLiveSelectCoHostBloc, List<ObjectWithNotifier<Host>>>(
//                     builder: (_, List<ObjectWithNotifier<Host>> listOfCohosts) {
//                       final bool shouldActivateBtn = listOfCohosts.any(
//                         (ObjectWithNotifier<Host> cohost) => (cohost.obj.profilePicture ?? '').isNotEmpty
//                       );
//                       return AmptiveElevatedButtonWidget(
//                         margin: EdgeInsets.zero,
//                         onPressed: shouldActivateBtn ? () => context.pop(true) : null,
//                         buttonTitle: ATStrings.SEND_INVITE,
//                         bgColor: ATColors.white,
//                         fgColor: ATColors.black,
//                       );
//                     }
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       }
//     );
// }



// class AmptiveListOfCoHostsWidget extends StatelessWidget {

//   AmptiveListOfCoHostsWidget({
//     super.key,
//     required this.availableCoHosts,
//   });
//   final List<ObjectWithNotifier<Host>> availableCoHosts;
//   final CreateShowService service = GetIt.I<CreateShowService>();

//   @override
//   Widget build(BuildContext context) {
//     if (availableCoHosts.isEmpty) {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             ATStrings.NO_SUGGESTIONS,
//             style: Theme.of(context).textTheme.bodyMedium
//           ),
//           Gap(3.h),
//           Text(
//             maxLines: 2,
//             ATStrings.SEARCH_UR_COHOSTS,
//             style: Theme.of(context)
//                 .textTheme
//                 .bodySmall
//                 ?.copyWith(color: ATColors.hexC2C2C2),
//           ),
//         ],
//       );
//     }

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: availableCoHosts.map(
//         (ObjectWithNotifier<Host> coHost) {
//           //final index = availableCoHosts.indexOf(coHost);
//           return Container();
//           // return CohostWithCheckIconWidget(
//           //   coHost: coHost,
//           //   onCohostTap: (bool isSelected) {
//           //     if (isSelected) {         
//           //       context.read<AmptiveGoLiveSelectCoHostBloc>().hostRemoveCohost(coHost);
//           //     } else {
//           //       context.read<AmptiveGoLiveSelectCoHostBloc>().hostAddCohost(coHost);
//           //     }
//           //   },
//           // );
//       }
//     ).toList());
//   }
// }
