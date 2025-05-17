import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants/strings/other_strings.dart';
import '../../../../widgets/other_widgets/main_application_widgets/widgets_in_discover_view/society_widgets/trending_society_model.dart';

class AmptiveTrendingSocietyScreen extends StatelessWidget {
  const AmptiveTrendingSocietyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegion(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(
                  'Trending',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                centerTitle: true,
                floating: true,
                leadingWidth: 100,
                leading: const ATBackBtn(leadingText: ATStrings.SOCIETY,)
              ),

              SliverGrid(
                delegate: SliverChildListDelegate.fixed(
                  List.generate(
                    28,
                    (_) => const AmptiveTrendingSocietyModel(trendingPicture: ATImgStrings.jpeg2)
                  ).toList()
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.75
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}