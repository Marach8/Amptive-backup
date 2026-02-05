import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:flutter/material.dart';

class CreateProgramSelectionItem extends StatelessWidget {
  const CreateProgramSelectionItem({
    super.key,
    this.description = '',
    required this.onTap,
    this.trailing,
    this.leading,
    this.descStyle,
  });

  final VoidCallback onTap;
  final Widget? trailing, leading;
  final String description;
  final TextStyle? descStyle;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      radius: 14,
      color: ATColors.white.withValues(alpha: 0.1),
      child: Row(
        children: <Widget>[
          leading ?? Expanded(
            child: Text(
              description,
              style: descStyle ?? context.textTheme.bodySmall?.copyWith(
                color: ATColors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(width: 10,),
    
          trailing ?? Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: ATColors.white.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}