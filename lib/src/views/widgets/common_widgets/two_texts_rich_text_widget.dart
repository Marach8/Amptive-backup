import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AmptiveTwoTextRichTextWidget extends StatelessWidget {
  final String text1, text2;
  final void Function()? text2OnTap, text1OnTap;
  final TextStyle? style1, style2;

  const AmptiveTwoTextRichTextWidget({
    super.key,
    required this.text1,
    required this.text2,
    this.text2OnTap,
    this.text1OnTap,
    this.style1, 
    this.style2
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text1,
            style: style1,
            recognizer: TapGestureRecognizer()..onTap = text1OnTap
          ),
          TextSpan(
            text: text2,
            style: style2,
            recognizer: TapGestureRecognizer()..onTap = text2OnTap
          )
        ]
      )
    );
  }
}