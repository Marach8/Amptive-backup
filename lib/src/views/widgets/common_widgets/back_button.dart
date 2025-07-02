import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/other_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ATBackBtn extends StatelessWidget {
  const ATBackBtn({
    super.key,
    this.leadingText,
    this.leadingStyle,
    this.iconSize
  });
  final String? leadingText;
  final TextStyle? leadingStyle;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.arrow_back_ios, size: iconSize ?? 20),
          Text(
            leadingText ?? ATStrings.BACK,
            style: leadingStyle ?? Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }
}



class ATRoundedBackBtn extends StatelessWidget {
  const ATRoundedBackBtn({super.key, this.bgColor});

  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Material(
        color: bgColor ?? ATColors.black,
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
          onTap: () => context.pop(),
          splashColor: ATColors.hex303030,
          borderRadius: BorderRadius.circular(30),
          child: const SizedBox(
            height: 30, width: 30,
            child: Icon(Icons.keyboard_arrow_left),
          ),
        ),
      ),
    );
  }
}



class ATXBackBtn extends StatelessWidget {
  const ATXBackBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => context.pop(),
        splashColor: ATColors.hex303030,
        borderRadius: BorderRadius.circular(30),
        child: const SizedBox(
          height: 30, width: 30,
          child: Icon(Icons.close),
        ),
      ),
    );
  }
}