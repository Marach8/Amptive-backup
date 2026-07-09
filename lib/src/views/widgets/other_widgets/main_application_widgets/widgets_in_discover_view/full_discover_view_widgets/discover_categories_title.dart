import 'package:flutter/material.dart';
import '../../../../../../config/utils/colors.dart';

class DiscoverCategoriesTile extends StatelessWidget {
  const DiscoverCategoriesTile({
    super.key,
    required this.categoryName,
    this.trailing,
    this.onTap,
  });

  final String categoryName;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Semantics(
              button: onTap != null,
              label: onTap != null ? 'Open $categoryName community' : null,
              child: InkWell(
                onTap: onTap,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      if (onTap != null) ...<Widget>[
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 22,
                          color: ATColors.hexA8A8A8,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          trailing ??
              InkWell(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  color: ATColors.hexB6B6B6,
                ),
              )
        ],
      ),
    );
  }
}
