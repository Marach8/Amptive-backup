import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_crossfade_widget.dart';
import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/textformfield_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/full_discover_view_widgets/full_discover_page_view.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';


class AmptiveDiscoverView extends StatefulWidget {
  const AmptiveDiscoverView({super.key});

  @override
  State<AmptiveDiscoverView> createState() => _AmptiveDiscoverViewState();
}

class _AmptiveDiscoverViewState extends State<AmptiveDiscoverView> {
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
  Widget build(BuildContext context) {
    return AmptiveAnnotatedRegionWidget(
      child: Scaffold(
        appBar: AppBar(title: const Text('Discover')),
        
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: AmptiveTextFormFieldWidget(
                        focusNode: focusNode,
                        controller: controller,
                        hintText: AmptiveOtherStrings.SEARCH_FOR_EVENTS_ND_SHOWS,
                        prefixIcon: const Icon(Iconsax.search_normal_14),
                        suffixIcon: ValueListenableBuilder(
                          valueListenable: notifier,
                          builder: (_, value, __) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: AmptiveAnimatedCrossFadeWidget(
                                condition: value,
                                secondChild: const SizedBox.shrink(),
                                firstChild: GestureDetector(
                                  onTap: () => controller.clear(),
                                  child: Icon(Icons.close, size: 20, color: AmptiveColors.whiteColor)
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                    ),
                    Gap(10.w),
                    ValueListenableBuilder(
                      valueListenable: notifier,
                      builder: (_, value, __) {
                        return AmptiveAnimatedCrossFadeWidget(
                          condition: value,
                          secondChild: const SizedBox.shrink(),
                          firstChild: Text(
                            AmptiveOtherStrings.CANCEL,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      }
                    )
                  ],
                ),
              ),

              Gap(20.h),

              ValueListenableBuilder(
                valueListenable: notifier,
                builder: (_, value, __) {
                  int index = 0;
                  if(value) index = 1;
                  final listOfWidgets = [
                    AmptiveFullDiscoverPageView(key: UniqueKey(),),
                    AmptiveRecentSearchesView(key: UniqueKey(),)
                  ];
                  return AmptiveAnimatedSwitcherWidget(
                    duration: 2,
                    child: listOfWidgets.elementAt(index),
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}
