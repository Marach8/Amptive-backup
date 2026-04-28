import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/global_model_objects.dart';
import 'package:flutter/material.dart';
import '../../../../shared/image_loader_widget.dart';

class CommunityCardWidget extends StatelessWidget {
  const CommunityCardWidget({
    super.key,
    required this.picture,
    this.title,
    this.padding,
    this.onTap,
  });

  final String picture;
  final String? title;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      width: 170,
      margin: padding ?? const EdgeInsets.only(left: 10),
      clipBehavior: Clip.hardEdge,
      radius: 10, 
      onTap: onTap,
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: ATImgLoader(imgPath: picture,
            
            ),
          ),
          
          if (title != null)
            Positioned(
              top: 16,
              left: 16,
              child: Text(
                title ?? '',
                style: TextStyle(
                  color: ATColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
