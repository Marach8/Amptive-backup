import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class SocietyTabsWidget extends StatefulWidget {
  const SocietyTabsWidget({super.key});

  @override
  State<SocietyTabsWidget> createState() => _SocietyTabsWidgetState();
}

class _SocietyTabsWidgetState extends State<SocietyTabsWidget> {
  static const List<String> _tabs = <String>[
    ATStrings.ALL,
    ATStrings.SHOWS,
    ATStrings.EVENTS,
  ];

  @override
  Widget build(BuildContext context) {
    final TabController controller = DefaultTabController.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[
        controller,
        if (controller.animation != null) controller.animation!,
      ]),
      builder: (BuildContext context, Widget? child) {
        final int selectedIndex =
            (controller.animation?.value ?? controller.index.toDouble())
                .round()
                .clamp(0, _tabs.length - 1);
        return TabBar(
          controller: controller,
          physics: const BouncingScrollPhysics(),
          splashFactory: NoSplash.splashFactory,
          tabAlignment: TabAlignment.start,
          labelPadding: EdgeInsets.zero,
          indicator: const BoxDecoration(),
          indicatorColor: ATColors.transparent,
          padding: EdgeInsets.zero,
          isScrollable: true,
          dividerColor: ATColors.transparent,
          tabs: _tabs.asMap().entries.map((MapEntry<int, String> tab) {
            final bool isSelected = selectedIndex == tab.key;
            return Tab(
              height: 48,
              child: Padding(
                padding: EdgeInsets.only(
                  left: tab.key == 0 ? 15 : 0,
                  right: 10,
                ),
                child: ATContainer(
                  radius: 20,
                  duration: 120,
                  curve: Curves.easeOutCubic,
                  color: isSelected
                      ? ATColors.white
                      : ATColors.hex9E9E9E.withValues(alpha: 0.3),
                  padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                  child: Text(
                    tab.value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              isSelected ? ATColors.hex0D0D0D : ATColors.white,
                        ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
