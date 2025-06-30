import 'package:flutter/material.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../common_widgets/image_loader_widget.dart';

class DiscoverCategoriesTile extends StatelessWidget {
  const DiscoverCategoriesTile({
    super.key,
    required this.categoryName,
    this.trailing
  });

  final String categoryName;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: <Widget>[
          const ATImgLoader(imgPath: ATImgStrings.GROUP_ICON_BLUE),
          const SizedBox(width: 10,),
          Text(
            categoryName,
            style: Theme.of(context).textTheme.bodyLarge 
          ),
          const Spacer(),
          trailing ?? InkWell(
            onTap: (){},
            child: Icon(Icons.more_horiz, color: ATColors.authHintColor,),
          )
        ],
      ),
    );
  }
}