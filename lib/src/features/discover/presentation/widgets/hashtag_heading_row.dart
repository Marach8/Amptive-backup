import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/utils/image_strings.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const Spacer(),
          Semantics(
            button: true,
            label: '${ATStrings.VIEW_ALL} $title',
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: viewAllOnpressed,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 48,
                  minHeight: 48,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(ATStrings.VIEW_ALL,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: ATColors.hexC2C2C2)),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      ATImgStrings.discoverChevronRightIcon,
                      width: 20,
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
