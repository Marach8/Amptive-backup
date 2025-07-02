import 'package:amptive/src/views/widgets/animation_widgets/common_animation_widgets/animated_switcher.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/tab_view_widgets/discover_tab_widgets.dart';
import 'package:flutter/material.dart';
import 'recent_searches_view.dart';

class AmptiveRecentSearchesAndTabsView extends StatefulWidget {
  const AmptiveRecentSearchesAndTabsView({
    super.key,
    required this.controller
  });
  final TextEditingController controller;

  @override
  State<AmptiveRecentSearchesAndTabsView> createState() => _AmptiveRecentSearchesAndTabsViewState();
}

class _AmptiveRecentSearchesAndTabsViewState extends State<AmptiveRecentSearchesAndTabsView> {
  late ValueNotifier<bool> _showTabs;

  @override 
  void initState(){
    super.initState();
    _showTabs = ValueNotifier(false);

    void updateTabsVisibility() {
      if (widget.controller.text.isNotEmpty) {
        _showTabs.value = true;
      } else {
        _showTabs.value = false;
      }
    }

    widget.controller.addListener(updateTabsVisibility);
  }

  @override 
  void dispose(){
    //_showTabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _showTabs,
      builder: (_, bool value, __) {
        int index = value ? 1 : 0;
        final List<Widget> listOfWidgets = <Widget>[
          RecentSearchesView(key: UniqueKey(),),
          SearchResultsTabsView(key: UniqueKey()),
        ];

        return ATFadingSwitcher(
          child: listOfWidgets.elementAt(index),
        );
      }
    );
  }
}
