import 'package:flutter/material.dart';
import '../../../../config/utils/colors.dart';
import '../../../../config/utils/other_strings.dart';

class HastagHeadingRow extends StatelessWidget {
  const HastagHeadingRow(
      {super.key, required this.title, required this.viewAllOnpressed});

  final String title;
  final VoidCallback viewAllOnpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.bodyLarge),
          const Spacer(),
          GestureDetector(
            onTap: viewAllOnpressed,
            child: Row(
              children: <Widget>[
                Text(ATStrings.VIEW_ALL,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(color: ATColors.hexC2C2C2)),
                Icon(Icons.keyboard_arrow_right_sharp,
                    color: ATColors.hexC2C2C2)
              ],
            ),
          )
        ],
      ),
    );
  }
}
