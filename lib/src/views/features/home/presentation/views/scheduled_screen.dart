import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../widgets/common_widgets/back_button.dart';
import '../../../../widgets/common_widgets/custom_container_widget.dart';
import '../widgets/scheduled_program.dart';


class ATScheduledPrograms extends StatelessWidget {
  const ATScheduledPrograms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                floating: true,   
                leadingWidth: 200,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ATBackBtn(
                    leadingText: ATStrings.SCHEDULED,
                    leadingStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ATFontSizes.size23
                    ),
                  )
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: ATContainer(
                    color: ATColors.white,
                    height: 0.15,
                    width: double.infinity,
                    child: const SizedBox.shrink(),
                  ),
                ),     
              ),
            ],
             
            body: ATRefreshIndicator(
              child: ListView( 
                physics: const BouncingScrollPhysics(),             
                padding: EdgeInsets.zero,
                children: [      
                  ...Iterable.generate(
                    10,
                    (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: GestureDetector(
                        onTap: () => context.pushNamed(ATRoutes.SHOW_DETAILED),
                        child: const ScheduledProgram()
                      ),
                    )
                  )
                ]
              ),
            )
          ),
        ),
      ),
    );
  }
}

