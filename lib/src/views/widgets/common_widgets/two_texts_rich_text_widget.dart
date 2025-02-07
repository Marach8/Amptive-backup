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




class AmptiveMultipleTextsRichText extends StatelessWidget {
  final Map<String, TextStyle> items;
  final TextAlign? textAlign;
  final void Function(int index)? textOnTap;
  const AmptiveMultipleTextsRichText({
    super.key,
    required this.items,
    this.textAlign,
    this.textOnTap
  });

  @override
  Widget build(context) {
    return Text.rich(
      textAlign: textAlign,
      maxLines: 5,
      TextSpan(
        children: items.entries.map(
          (item){
            final index = items.entries.toList().indexOf(item);
            return TextSpan(
              text: item.key,
              style: item.value,
              recognizer: TapGestureRecognizer()..onTap = (){
                if (textOnTap != null){
                  textOnTap!(index);
                }
              }
            );
          }
        ).toList()
      )
    );
  }
}