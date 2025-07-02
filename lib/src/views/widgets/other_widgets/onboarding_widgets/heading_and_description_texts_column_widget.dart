import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AmptiveOnboardingHeadingAndDescriptionTextsColumnWidget extends StatelessWidget {

  const AmptiveOnboardingHeadingAndDescriptionTextsColumnWidget({
    super.key,
    required this.title,
    required this.description,
  });
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium,
          textAlign: TextAlign.left,
        ),
        Gap(20.r),
        Text(
          description,
          style: Theme.of(context).textTheme.labelMedium,
          textAlign: TextAlign.left,
        )
      ],
    );
  }
}