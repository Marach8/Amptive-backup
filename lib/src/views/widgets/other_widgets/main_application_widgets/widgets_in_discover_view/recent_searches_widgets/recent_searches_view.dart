import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';

class RecentSearchesView extends StatelessWidget {
  const RecentSearchesView({
    super.key,
  });

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  ATStrings.RECENT_SEARCHES,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const Spacer(),
                Text(
                  ATStrings.CLEAR,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ATColors.authHintColor
                  ),
                ),
              ],
            ),
            Gap(20.h),
            
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.OFFICE_LADIES,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.jpeg3,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.weCanDoHardThingsBgImage,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: ATImgStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
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