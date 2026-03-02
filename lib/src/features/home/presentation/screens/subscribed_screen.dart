import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/shared/annotated_region__widget.dart';
import 'package:amptive/src/shared/refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/colors.dart';
import '../../../../shared/back_button.dart';
import '../../../../shared/custom_container_widget.dart';
import '../widgets/subscribed_program.dart';


class ATSubscribedPrograms extends StatelessWidget {
  const ATSubscribedPrograms({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: SafeArea(
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) => <Widget>[
              SliverAppBar(
                floating: true,   
                leadingWidth: 200,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: ATBackBtn(
                    alignment: Alignment.centerLeft,
                    leadingText: ATStrings.SUBSCRIBED,
                    leadingStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: ATSizes.size23
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
                padding: EdgeInsets.zero,
                children: <Widget>[      
                  ...Iterable.generate(
                    10,
                    (_) => Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                      child: GestureDetector(
                        onTap: () => context.pushNamed(ATRoutes.LIVE_SHOW_DETAILED),
                        child: const SubscribedProgram()
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

