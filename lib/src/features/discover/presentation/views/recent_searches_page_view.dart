import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/features/discover/presentation/widgets/search_item_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../config/utils/image_strings.dart';
import '../../../../config/utils/other_strings.dart';

class RecentSearchesView extends StatelessWidget {
  const RecentSearchesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  ATStrings.RECENT_SEARCHES,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const Spacer(),
                Text(
                  ATStrings.CLEAR,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ATColors.hexB6B6B6
                  ),
                ),
              ],
            ),
            Gap(20.h),
            
            const SearchItemTile(
              leadingImagePath: ATImgStrings.OFFICE_LADIES,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.jpeg3,
              title: 'Former CIA Agent On Trump As many',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
              title: 'Former CIA Agent On Trump As many',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const HashTagSearchItemTile(
              title: 'Society',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const SearchItemTile(
              leadingImagePath: ATImgStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
          ],
        ),
      ),
    );
  }
}