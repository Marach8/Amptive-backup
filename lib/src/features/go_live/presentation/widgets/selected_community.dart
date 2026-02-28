import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/auth/data/models/response/communities_response_model.dart' show Community;
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

import '../../../../models/community.dart';

class SelectedCommunityWidget extends StatelessWidget {
  const SelectedCommunityWidget({
    super.key,
    required this.selectedCommunity,
    required this.onClose,
    required this.onView,
  });

  final Community selectedCommunity;
  final VoidCallback onClose, onView;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      radius: 14,
      padding: const EdgeInsets.all(15),
      color: ATColors.white.withValues(alpha: 0.1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: ATImgLoader(
              imgPath: selectedCommunity.image ?? '',
              boxFit: BoxFit.cover,
              width: 100, height: 75,
            ),
          ),
          const SizedBox(width: 18,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  selectedCommunity.name!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 20,),
                ATContainer(
                  onTap: onView, radius: 5,
                  color: ATColors.white.withValues(alpha: 0.1),
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  child: Text(
                    ATStrings.VIEW_COMMUNITY,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: ATColors.white.withValues(alpha: 0.7),
                      height: 1.1
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10,),
          InkWell(
            onTap: onClose,
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(30),
            child: const SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.close),
            ),
          ),
        ],
      ),
    );
  }
}
