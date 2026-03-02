// import 'package:amptive/src/features/main_app_nav_bar.dart';
// import 'package:amptive/src/features/main_app_shell.dart';
// import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
// import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ATBottomNavItem extends StatelessWidget {
//   const ATBottomNavItem({
//     super.key,
//     required this.selectedImagePath,
//     required this.unselectedImagePath,
//     required this.itemIdentityIndex,
//   });

//   final String selectedImagePath, unselectedImagePath;
//   final int itemIdentityIndex;


//   @override
//   Widget build(BuildContext context) {
//     return BlocSelector<ATNavBarBloc, (int, bool), int>(
//       selector: ((int, bool) state) => state.$1,
//       builder: (_, int currentNavIndex) {
//         final bool isSelected = itemIdentityIndex == currentNavIndex;
//         return GestureDetector(
//           onTap: () => context.read<ATNavBarBloc>().goToPage(itemIdentityIndex),
//           child: ATAnimatedXFade(
//             condition: isSelected,
//             firstChild: ATImgLoader(imgPath: selectedImagePath),
//             secondChild: ATImgLoader(imgPath: unselectedImagePath)
//           ),
//         );
//       }
//     );
//   }
// }
