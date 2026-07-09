import 'package:flutter/material.dart';
import '../../../../shared/custom_container_widget.dart';
import '../../../../shared/image_loader_widget.dart';
import '../../../../shared/scale_on_press_widget.dart';

class TopCreatorWidget extends StatelessWidget {
  const TopCreatorWidget({
    super.key,
    required this.picture,
    required this.creatorName,
    this.onTap,
  });

  final String picture, creatorName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget content = ATContainer(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        children: <Widget>[
          ClipOval(
            child: ATImgLoader(
              imgPath: picture,
              width: 150,
              height: 150,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 150,
            child: Text(
              creatorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      button: onTap != null,
      label: 'Open $creatorName’s program',
      child: onTap == null
          ? content
          : ScaleOnPressWidget(
              scaleDownTo: 0.96,
              onTap: onTap!,
              child: content,
            ),
    );
  }
}
