import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/strings/image_strings.dart';
import '../../../common_widgets/custom_container_widget.dart';
import '../../../common_widgets/list_tile_with_leading_picture_widget.dart';

class ATWhispers extends StatelessWidget {
  const ATWhispers({
    super.key,
  });

  @override
  Widget build(context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (_, __) => ATContainer(
          margin: const EdgeInsets.only(left: 15),
          padding: const EdgeInsets.fromLTRB(15, 0, 15,  0),
          height: 230, width: 285, radius: 10,
          color: ATColors.whiteColor.withOpacity(0.1),
          child: Column(
            children: [
              const AmptiveListTileWithLeadingPictureWidget(
                title: 'karankabir',
                subtitle: 'Listener',
                leadingImagePath: ATImgStrings.jpeg1,
                leadingImagePath: ATImgStrings.jpeg1,
              ),
              const SizedBox(height: 10),
              Text(
                maxLines: 100,
                'I got so excited whan Jack spoke spanish for just no reason, like what!!!!!!>😂😂😂',
                style: Theme.of(context).textTheme.labelMedium
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}