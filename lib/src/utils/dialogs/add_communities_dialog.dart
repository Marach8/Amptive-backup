import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../services/create_show/create_show_service.dart';
import '../constants/strings/other_strings.dart';

Future<Community> showAddCommunitiesDialog(BuildContext context) async {

  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
      backgroundColor: AmptiveColors.brandBlack,
      constraints: BoxConstraints.expand(
          height: AmptiveHelperFunctions.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        final listOfItems = service.generateCommunities();
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(children: [
            const Gap(20),
            Text(
              AmptiveOtherStrings.ADD_COMMUNITY,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),
            Text(
              maxLines: 3,
              AmptiveOtherStrings.ADD_COMMUNITY_DESC,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AmptiveColors.hexC2C2C2),
            ),
            const Gap(20),
            ...listOfItems.map((item) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        SizedBox(
                            height: 48,
                            width: 67,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: AmptiveImageLoaderWidget(
                                    imagePath: item.coverPic!))),
                        const Gap(15),
                        Text(
                          item.name!,
                          style: Theme.of(context).textTheme.labelMedium,
                        )
                      ],
                    ),
                  ),
                ))
          ]),
        );
      });
}


