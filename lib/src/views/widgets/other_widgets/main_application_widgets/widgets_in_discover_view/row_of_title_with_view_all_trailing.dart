import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/other_strings.dart';

class AmptiveRowOfTitleWithTrendingViewAll extends StatelessWidget {
  final String title;
  final VoidCallback viewAllOnpressed;
  const AmptiveRowOfTitleWithTrendingViewAll({
    super.key,
    required this.title,
    required this.viewAllOnpressed
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
          const Spacer(),
          GestureDetector(
            onTap: viewAllOnpressed,
            child: Row(
              children: [
                Text(
                  ATStrings.VIEW_ALL,
                  style: Theme.of(context).textTheme.labelMedium
                ),
                Icon(Icons.keyboard_arrow_right_sharp, color: ATColors.authHintColor,)
              ],
            ),
          )
        ],
      ),
    );
  }
}