// import 'package:amptive/src/utils/constants/strings/route_strings.dart';
// import 'package:flutter/material.dart';
// import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_home_view/home_view_widget.dart';
// import 'home_sub_view/show_detailed_screen.dart';

// class AmptiveHomeRootNavigator extends StatelessWidget {
//   const AmptiveHomeRootNavigator({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Navigator(
//       onGenerateRoute: (RouteSettings settings){
//         WidgetBuilder builder;
//         switch(settings.name){
//           case AmptiveRoutes.newScreen:
//             builder = (_) => const AmptiveShowDetailedScreen();
//             break;
//           default :
//             builder = (_) => const AmptiveHomeViewWidget();
//         }
//         return MaterialPageRoute(builder: builder, settings: settings);
//       },
//     );
//   }
// }