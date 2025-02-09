import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/widgets.dart';

class AmptiveSearchFilterWidget extends StatelessWidget {
  final String title;
  final String searchQuery;
  final TextStyle? style;

  const AmptiveSearchFilterWidget({
    super.key,
    required this.title,
    required this.searchQuery,
    required this.style
  });

  @override
  Widget build(context) {
    final listOfStrings = title.trim().split('');

    return Text.rich(
      TextSpan(
        children: listOfStrings.map(
          (stringOfText){
            final shouldHighlightString = searchQuery.contains(stringOfText.toLowerCase());
            return TextSpan(
              text: stringOfText,
              style: shouldHighlightString ? style?.copyWith(
                color: AmptiveColors.hex307FE2
              ) : style                              
            );
          }
        ).toList()
      )
    );
  }
}