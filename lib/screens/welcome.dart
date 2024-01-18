
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/utils.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController(viewportFraction: 1.0, keepPage: true);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return SafeArea(child: Scaffold(
     backgroundColor: AmpColors.brandBlack,
     body: Container(
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           Center(
             child: Container(
               width: 67,
               height: 67,
               margin: const EdgeInsets.only(bottom: 88, top: 50),
               child:  SvgPicture.asset(
                 "assets/Logo.svg",
                 semanticsLabel: 'Amptive Logo',
               ),
             ),
           ),
           Stack(
             children: [
               CircleAvatar(backgroundImage: AssetImage("assets/Logo.svg"),),

             ],
           )
         ],
       ),
     ),
   ));
  }
}