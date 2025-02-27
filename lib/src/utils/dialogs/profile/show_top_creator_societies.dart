import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/helpers/helper_functions/other_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../constants/strings/other_strings.dart';

Future<void> showTopCreatorSocietiesDialog(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();
  final communities = service.generateCommunities();

  return await showModalBottomSheet(
    backgroundColor: AmptiveColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: AmptiveColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: AmptiveContainer(
            width: AmptiveHelperFunctions.getScreenWidth(context),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Platform.isAndroid
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: AmptiveColors.whiteColor.withOpacity(0.6),
                        )
                      : AmptiveContainer(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          radius: 5, height: 4, width: 30,
                          color: AmptiveColors.whiteColor.withOpacity(0.6),
                          child: const SizedBox.shrink(),
                        ),
                    ),
                  ),
                  const Gap(5),
                  Text(
                    AmptiveStrings.TOP_CREATOR_IN,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  ...communities.take(3).map(
                    (community) => _CustomRow(
                      communityImage: community.coverPic ?? '',
                      communityName: community.name ?? ''
                    )
                  )
                ]
              ),
            )
          ),
        );
      }
    );
}



class _CustomRow extends StatelessWidget {
  final String communityName, communityImage;
  const _CustomRow({
    required this.communityImage,
    required this.communityName
  });

  @override
  Widget build(context) {
    return AmptiveContainer(
      margin: const EdgeInsets.only(bottom: 20),
      width: AmptiveHelperFunctions.getScreenWidth(context),
      child: Row(
        children: [
          SizedBox(
            height: 50, width: 70,
            child: AmptiveImageLoaderWidget(imagePath: communityImage),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              communityName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          AmptiveElevatedButtonWidget(
            onPressed: (){},
            bgColor: AmptiveColors.hex307FE2,
            buttonTitle: AmptiveStrings.VIEW,
          )
        ],
      ),
    );
  }
}
