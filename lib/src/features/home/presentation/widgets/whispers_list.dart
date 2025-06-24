import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/strings/image_strings.dart';
import '../../../../views/widgets/common_widgets/custom_container_widget.dart';
import '../../../../views/widgets/common_widgets/list_tile_with_leading_picture_widget.dart';

class ATWhispersWidget extends StatelessWidget {
  const ATWhispersWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (_, __) => ATContainer(
          margin: const EdgeInsets.only(left: 15),
          padding: const EdgeInsets.fromLTRB(15, 0, 15,  0),
          height: 230, width: 326, radius: 10,
          color: ATColors.white.withValues(alpha: 0.1),
          child: Column(
            children: <Widget>[
              const TileWithLeadingImage(
                title: 'karankabir',
                subtitle: 'Listener', diameter: 48,
                leadingImagePath: ATImgStrings.jpeg1,
              ),
              const SizedBox(height: 10),
              Text(
                maxLines: 100,
                'I got so excited whan Jack spoke spanish for just no reason, like what!!!!!!>😂😂😂',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ATColors.white, height: 1.5
                )
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}