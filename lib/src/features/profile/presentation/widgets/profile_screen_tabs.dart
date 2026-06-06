import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileScreenTabs extends StatelessWidget {
  const ProfileScreenTabs({super.key, required this.tabs});

  final List<String> tabs;

  @override
  Widget build(BuildContext context) {
    return TabBar(
        indicator: BoxDecoration(
          color: ATColors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        indicatorColor: ATColors.white,
        dividerColor: ATColors.transparent,
        labelColor: ATColors.black,
        unselectedLabelColor: ATColors.white,
        padding: const EdgeInsets.only(left: 15),
        labelPadding: const EdgeInsets.only(right: 10),
        indicatorPadding: const EdgeInsets.only(bottom: 2),
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        tabs: tabs
            .map((String tab) => Tab(
                  child: _TabWidget(
                    text: tab,
                  ),
                ))
            .toList());
  }
}

class _TabWidget extends StatelessWidget {
  const _TabWidget({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = DefaultTextStyle.of(context).style;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
      decoration: BoxDecoration(
          color: ATColors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: ATColors.white.withValues(alpha: 0.1), width: 2)),
      child: Text(text,
          style: textStyle.copyWith(
              fontSize: 13, height: 1,
              fontWeight: FontWeight.w500,
              letterSpacing: 0)),
    );
  }
}
