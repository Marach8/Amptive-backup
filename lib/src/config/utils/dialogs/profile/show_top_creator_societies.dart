import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/models/community.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/helper_functions.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/elevated_button_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../services/create_show/create_show_service.dart';
import '../../other_strings.dart';

Future<void> showTopCreatorSocietiesDialog(BuildContext context) async {
  CreateShowService service = GetIt.I<CreateShowService>();
  final List<Community> communities = service.generateCommunities();

  return await showModalBottomSheet(
    backgroundColor: ATColors.hex202020,
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: ATColors.black.withOpacity(0.6),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15), topRight: Radius.circular(15),
    )),
    builder: (BuildContext context) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), topRight: Radius.circular(15),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: ATContainer(
            width: ATHelperFuncs.getScreenWidth(context),
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Platform.isAndroid
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: ATColors.white.withOpacity(0.6),
                        )
                      : ATContainer(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          radius: 5, height: 4, width: 30,
                          color: ATColors.white.withOpacity(0.6),
                          child: const SizedBox.shrink(),
                        ),
                    ),
                  ),
                  const Gap(5),
                  Text(
                    ATStrings.TOP_CREATOR_IN,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Gap(20),
                  ...communities.take(3).map(
                    (Community community) => _CustomRow(
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
  const _CustomRow({
    required this.communityImage,
    required this.communityName
  });
  final String communityName, communityImage;

  @override
  Widget build(BuildContext context) {
    return ATContainer(
      margin: const EdgeInsets.only(bottom: 20),
      width: ATHelperFuncs.getScreenWidth(context),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 50, width: 70,
            child: ATImgLoader(imgPath: communityImage),
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
            bgColor: ATColors.hex307FE2,
            buttonTitle: ATStrings.VIEW,
          )
        ],
      ),
    );
  }
}
