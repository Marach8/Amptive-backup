import 'package:amptive/src/utils/constants/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ATFilterWidget<B extends BlocBase<String>> extends StatelessWidget{
  final String title;
  final TextStyle? style;
  final String? padLeft, padRight;

  const ATFilterWidget({
    super.key,
    required this.title,
    required this.style,
    this.padLeft,
    this.padRight,
  });

  @override
  Widget build(context) {
    return BlocBuilder<B, String>(
      builder: (_, state) {
        final listOfStrings = title.trim().split('');

        return Text.rich(
          TextSpan(
            children: [
              if (padLeft != null) TextSpan(
                text: padLeft,
                style: style,
              ),
              ...listOfStrings.map(
                (stringOfText) {
                  final shouldHighlightString = state.toLowerCase().contains(stringOfText.toLowerCase());
                  return TextSpan(
                    text: stringOfText,
                    style: shouldHighlightString 
                      ? style?.copyWith(color: ATColors.hex307FE2)
                      : style,
                  );
                },
              ),
              if (padRight != null) TextSpan(
                text: padRight,
                style: style,
              ),
            ],
          ),
        );
      },
    );
  }
}