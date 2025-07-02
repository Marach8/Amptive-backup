import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import '../../services/create_show/create_show_service.dart';
import '../constants/strings/other_strings.dart';

Future<Community> showAddCommunitiesDialog(BuildContext context) async {

  CreateShowService service = GetIt.I<CreateShowService>();

  return await showModalBottomSheet(
      backgroundColor: ATColors.hex0D0D0D,
      constraints: BoxConstraints.expand(
          height: ATHelperFuncs.getScreenHeight(context)),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) {
        final List<Community> listOfItems = service.generateCommunities();
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(children: <Widget>[
            const Gap(20),
            Text(
              ATStrings.ADD_COMMUNITY,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Gap(20),
            Text(
              maxLines: 3,
              ATStrings.ADD_COMMUNITY_DESC,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: ATColors.hexC2C2C2),
            ),
            const Gap(20),
            ...listOfItems.map((Community item) => GestureDetector(
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                            height: 48,
                            width: 67,
                            child: FittedBox(
                                fit: BoxFit.fill,
                                child: ATImgLoader(
                                    imgPath: item.coverPic!))),
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


