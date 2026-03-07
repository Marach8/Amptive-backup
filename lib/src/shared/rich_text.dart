import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ATRichText extends StatelessWidget {
  const ATRichText(
      {super.key,
      required this.items,
      this.textAlign,
      this.textOnTap,
      this.maxLines});
  final Map<String, TextStyle> items;
  final TextAlign? textAlign;
  final int? maxLines;
  final void Function(String)? textOnTap;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        textAlign: textAlign,
        maxLines: maxLines ?? 5,
        TextSpan(
            children: items.entries.map((MapEntry<String, TextStyle> item) {
          return TextSpan(
              text: item.key,
              style: item.value,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (textOnTap != null) {
                    textOnTap!(item.key);
                  }
                });
        }).toList()));
  }
}
