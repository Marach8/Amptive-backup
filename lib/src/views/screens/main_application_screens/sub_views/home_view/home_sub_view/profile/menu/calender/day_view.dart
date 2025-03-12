import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:flutter/material.dart';

class ATCalenderScreen extends StatelessWidget {
  const ATCalenderScreen({super.key});

  @override
  Widget build(context) {
    return ATAnnotatedRegionWidget(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, kToolbarHeight, 15, kBottomNavigationBarHeight),
          child: IndexedStack(
            index: 0,
            children: [
              DayView()
            ],
          ),
        ),
      ),
    );
  }
}

class DayView extends StatelessWidget {
  const DayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard_arrow_left),
            Text(
              'February 2025',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: ATFontSizes.size23
              ),
            )
          ],
        )
      ],
    );
  }
}

