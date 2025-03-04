import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/more_2_discover_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../utils/constants/strings/other_strings.dart';

class AmptiveCommunityScreen extends StatelessWidget {
  const AmptiveCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: const Text('Communities'),
                centerTitle: true,
                floating: true,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(Icons.keyboard_arrow_left, size: 20)
                ),
              ),
              SliverToBoxAdapter(
                child: Text(
                  maxLines: 3,
                  AmptiveStrings.DISCOVER_COMMUNITIES,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AmptiveColors.grey5Color
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: Gap(10)),
              SliverGrid(
                delegate: SliverChildListDelegate.fixed(
                  List.generate(
                    28,
                    (_) => const AmptiveMore2DiscoverModel(
                      picture: AmptiveImageStrings.COMMUNITY_CARD,
                      padding: EdgeInsets.zero,
                    )
                  ).toList()
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1.28
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}