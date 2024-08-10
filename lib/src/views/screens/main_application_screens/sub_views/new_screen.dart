import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/container_for_rendering_other_widgets.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class NewScreen extends StatelessWidget {
  const NewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AmptiveCustomContainer(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.topRight,
                    height: 360.h,
                    radius: 16,
                    decorationImagePath: AmptiveImageStrings.weCanDoHardThingsBigPicture,
                    child: GestureDetector(                      
                      onTap: (){context.pop();},
                      child: AmptiveCustomContainer(
                        height: 32, width: 32,
                        boxShape: BoxShape.circle,
                        color: AmptiveColors.brandBlackColor.withOpacity(0.7),
                        child: const Icon(Icons.more_horiz),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.sIcon),
                      AmptiveImageLoaderWidget(imagePath: AmptiveImageStrings.weCanDoHardThingsBigPicture),
                      Text(
                        'We Can Do Hard Things',
                        
                      )
                    ],
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}