import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/recent_searches_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../utils/constants/strings/image_strings.dart';
import '../../../../../../utils/constants/strings/other_strings.dart';

class AmptiveRecentSearchesView extends StatelessWidget {
  const AmptiveRecentSearchesView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AmptiveOtherStrings.RECENT_SEARCHES,
                  style: Theme.of(context).textTheme.bodyLarge
                ),
                const Spacer(),
                Text(
                  AmptiveOtherStrings.CLEAR,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AmptiveColors.authHintColor
                  ),
                ),
              ],
            ),
            Gap(20.h),
            
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.OFFICE_LADIES,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.jpeg3,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.weCanDoHardThingsBgImage,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.MAN_PHOTO,
              title: 'Glennon Doyle',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.discoverPic1,
              title: 'Former CIA Agent On Trump As many',
            ),
            const AmptiveRecentSearchesListTileWidget(
              leadingImagePath: AmptiveImageStrings.JOE_POMP_SHOW,
              title: 'Former CIA Agent On Trump As many',
              isCircular: true,
            ),
          ],
        ),
      ),
    );
  }
}