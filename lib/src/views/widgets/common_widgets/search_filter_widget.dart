import 'package:amptive/src/config/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ATFilterWidget<B extends BlocBase<String>> extends StatelessWidget{

  const ATFilterWidget({
    super.key,
    required this.title,
    required this.style,
    this.padLeft,
    this.padRight,
  });
  final String title;
  final TextStyle? style;
  final String? padLeft, padRight;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, String>(
      builder: (_, String state) {
        final List<String> listOfStrings = title.trim().split('');

        return Text.rich(
          TextSpan(
            children: <InlineSpan>[
              if (padLeft != null) TextSpan(
                text: padLeft,
                style: style,
              ),
              ...listOfStrings.map(
                (String stringOfText) {
                  final bool shouldHighlightString = state.toLowerCase().contains(stringOfText.toLowerCase());
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


class ATSearchIcon extends StatelessWidget {
  const ATSearchIcon({super.key, this.size});

  final double? size;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(15, 0, 20, 0),
    child: Icon(CupertinoIcons.search, size: size),
  );
}