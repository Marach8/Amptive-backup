import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AmptiveBackArrowWidget extends StatelessWidget {
  const AmptiveBackArrowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Icon(
        Icons.arrow_back_ios,
        size: 20.r,
      ),
    );
  }
}
