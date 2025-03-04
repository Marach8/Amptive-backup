import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/full_discover_page_view.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/discover_sliver_header.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_and_tabs_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';


class AmptiveDiscoverViewWidget extends StatefulWidget {
  const AmptiveDiscoverViewWidget({super.key});

  @override
  State<AmptiveDiscoverViewWidget> createState() => _AmptiveDiscoverViewWidgetState();
}

class _AmptiveDiscoverViewWidgetState extends State<AmptiveDiscoverViewWidget> {
  late ValueNotifier<bool> notifier;
  late FocusNode focusNode;
  late TextEditingController controller;

  @override 
  void initState(){
    super.initState();
    notifier = ValueNotifier(false);
    focusNode = FocusNode();
    controller = TextEditingController();

    focusNode.addListener(
      () => notifier.value = focusNode.hasFocus
    );
  }

  @override 
  void dispose(){
    notifier.dispose();
    focusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverAppBar(
                title: Text('Discover'),
                floating: true,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: AmptiveDiscoverSliverHeader(
                  controller: controller,
                  focusNode: focusNode,
                  notifier: notifier
                )
              ),     
          
              SliverToBoxAdapter(child: Gap(20.h)),
          
              SliverToBoxAdapter(
                child: ValueListenableBuilder(
                  valueListenable: notifier,
                  builder: (_, value, __) {
                    return AmptiveFadingAnimatedSwitcherWidget(
                      duration: 200,
                      child: value ? AmptiveRecentSearchesAndTabsView(
                        key: UniqueKey(),
                        controller: controller,
                      ) : AmptiveFullDiscoverPageView(key: UniqueKey())
                      
                    );
                  }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
