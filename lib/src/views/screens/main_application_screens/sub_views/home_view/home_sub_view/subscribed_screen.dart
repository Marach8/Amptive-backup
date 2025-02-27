import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/utils/constants/strings/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../widgets/common_widgets/app_bar_leading_widget.dart';
import '../../../../../widgets/common_widgets/custom_container_widget.dart';
import '../../../../../widgets/other_widgets/main_application_widgets/widgets_in_home_view/widgets_in_subscribed/subscribed_show_or_event_model_widget.dart';


class AmptiveSubscribedEventOrShowViewWidget extends StatelessWidget {
  const AmptiveSubscribedEventOrShowViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              floating: true,   
              leadingWidth: 200.w,
              leading: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: AmptiveAppBarLeadingWidget(
                  leadingText: AmptiveStrings.SUBSCRIBED,
                  leadingStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: AmptiveFontSizes.size23
                  ),
                )
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0),
                child: AmptiveContainer(
                  color: AmptiveColors.whiteColor,
                  height: 0.15,
                  width: double.infinity,
                  child: const SizedBox.shrink(),
                ),
              ),     
            ),
      
            // SliverPersistentHeader(
            //   pinned: true,
            //   delegate: AmptiveSliverHeader()
            // )
          ],
           
          body: AmptiveRefreshIndicatorWidget(
            child: ListView(              
              padding: EdgeInsets.zero,
              children: [      
                ...Iterable.generate(
                  10,
                  (_) => Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                    child: GestureDetector(
                      onTap: () => context.pushNamed(AmptiveRoutes.showDetailedScreen),
                      child: const AmptiveSubscribedShowOrEventDataModelWidget()
                    ),
                  )
                )
              ]
            ),
          )
        ),
      ),
    );
  }
}

