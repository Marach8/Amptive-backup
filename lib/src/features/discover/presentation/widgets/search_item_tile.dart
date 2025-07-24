import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:flutter/material.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../views/widgets/common_widgets/image_loader_widget.dart';

class SearchItemTile extends StatelessWidget {

  const SearchItemTile({
    super.key,
    required this.title,
    required this.leadingImagePath,
    this.isCircular = false,
    this.trailing,
  });
  final String title, leadingImagePath;
  final bool isCircular;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    const double size = 50;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(
              isCircular ? size * 0.6 : 5
            ),
            child: ATImgLoader(
              imgPath: leadingImagePath,
              height: size, width: size,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 8,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size14
                  ),
                ),

                const SizedBox(height: 5,),

                Row(
                  children: <Widget>[
                    Text(
                      'Show',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2,
                        fontWeight: ATFontWeights.w500,
                        fontSize: ATFontSizes.size13,
                        height: 1.5
                      ),
                    ),
                    const SizedBox(width: 5),
                    const ATCircleAvatar(diameter: 3),
                    const SizedBox(width: 5),
                    Text(
                      'MONDAY AT 20:00',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: ATColors.hexC2C2C2,
                        fontWeight: ATFontWeights.w500,
                        fontSize: ATFontSizes.size13,
                        height: 1.5
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 15,),

          trailing ?? InkWell(
            onTap: (){},
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.close, color: ATColors.hexB6B6B6,),
            ),
          ),
        ],
      ),
    );
  }
}




class HashTagSearchItemTile extends StatelessWidget {
  const HashTagSearchItemTile({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: <Widget>[
          ATContainer(
            alignment: Alignment.center,
            height: 50, width: 50,
            boxShape: BoxShape.circle,
            color: ATColors.white,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                ATColors.black,
                BlendMode.srcATop
              ),
              child: const ATImgLoader(
                imgPath: ATImgStrings.HASH_ICON,
                height: 28, width: 28,
              ),
            ),
          ),
          const SizedBox(width: 8,),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${ATStrings.HASH}$title'.toLowerCase(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: ATFontSizes.size14
                  ),
                ),

                const SizedBox(height: 5,),

                Text(
                  ATStrings.HASHTAGS.toLowerCase(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: ATColors.hexC2C2C2,
                    fontWeight: ATFontWeights.w500,
                    fontSize: ATFontSizes.size13,
                    height: 1.5
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 15,),

          trailing ?? InkWell(
            onTap: (){},
            splashColor: ATColors.hex303030,
            borderRadius: BorderRadius.circular(30),
            child: SizedBox(
              height: 30, width: 30,
              child: Icon(Icons.close, color: ATColors.hexB6B6B6,),
            ),
          ),
        ],
      ),
    );
  }
}
