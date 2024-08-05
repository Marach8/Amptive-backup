import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/app_bar_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_container_with_picture_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/svg_asset_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/appbar_pop_drop_down.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/dashboar_nav_bar_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/home_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class AmptiveDashboardScreen extends StatefulWidget {
  const AmptiveDashboardScreen({super.key});

  @override
  State<AmptiveDashboardScreen> createState() => _AmptiveDashboardScreenState();
}

class _AmptiveDashboardScreenState extends State<AmptiveDashboardScreen> {
  late PageController _pageController;
  late ValueNotifier<int> _pageIndexNotifier;

  @override
  void initState(){
    super.initState();
    _pageController = PageController();
    _pageIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose(){
    _pageController.dispose();
    _pageIndexNotifier.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AmptiveAppBar(
          centerTitle: false,
          leadingWidth: 150.w,
          leading: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgLogo2, height: 20.906, width: 86.32,),
              Gap(4.0),
              AmptiveAppBarDropDownWidget()
            ],
          ),

          actions: [
            GestureDetector(
              onTap: (){},
              child: const AmptiveSvgAssetLoaderWidget(svgPath: AmptiveImageStrings.svgWalletIcon, height: 30, width: 30,)
            ),
            const Gap(24),
            GestureDetector(
              onTap: (){},
              child: const AmptiveCircularContainerWithPictureWidget(
                imagePath: AmptiveImageStrings.jpeg2,
              )
            ),
          ],
        ),


        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => _pageIndexNotifier.value = index,
          children: [
            const AmptiveHomeViewWidget(),
            Container(color: Colors.red,),
            Container(color: Colors.blue,),
            Container(color: Colors.green,),
          ],
        ),

        bottomNavigationBar: AmptiveDashboardBottomNavBarWidget(
          pageIndexNotifier: _pageIndexNotifier,
          pageController: _pageController
        )
      ),
    );
  }
}