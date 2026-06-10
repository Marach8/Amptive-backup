import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../shared/custom_container_widget.dart';

class SocietyTabsWidget extends StatefulWidget {
  const SocietyTabsWidget({
    super.key,
  });

  @override
  State<SocietyTabsWidget> createState() => _SocietyTabsWidgetState();
}

class _SocietyTabsWidgetState extends State<SocietyTabsWidget> {
  int _selectedIndex = 0;
  late final TabController _tabController;
  static const List<String> _tabs = <String>[
    ATStrings.ALL,
    ATStrings.shows,
    ATStrings.events
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController = DefaultTabController.of(context);
      _tabController.addListener(
          () => setState(() => _selectedIndex = _tabController.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabController tabController = DefaultTabController.of(context);

    return Row(
        mainAxisSize: MainAxisSize.min,
        children: _tabs.map((String tab) {
          final int index = _tabs.indexOf(tab);
          final bool isSelected = index == _selectedIndex;
          return ATContainer(
            onTap: () => setState(() {
              _selectedIndex = index;
              tabController.animateTo(
                index,
                duration: Duration.zero,
              );
            }),
            radius: 20,
            duration: 100,
            margin: const EdgeInsets.only(left: 15),
            color: isSelected
                ? ATColors.white
                : ATColors.hex9E9E9E.withValues(alpha: 0.3),
            padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
            child: Text(
              tab,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected ? ATColors.hex0D0D0D : ATColors.white),
            ),
          );
        }).toList());
  }
}
