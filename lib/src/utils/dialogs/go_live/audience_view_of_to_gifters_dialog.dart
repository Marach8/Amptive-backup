import 'dart:io';
import 'dart:ui';
import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/font_sizes.dart';
import 'package:amptive/src/utils/helpers/extensions/string_extensions.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/circular_image.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../models/host.dart';
import '../../../services/create_show/create_show_service.dart';
import '../../constants/strings/other_strings.dart';

Future<void> showAudienceViewOfTopGiftersDialog(BuildContext context) async {
  final randomUser = getHostList()[4];

  return await showModalBottomSheet(
      backgroundColor: ATColors.white.withOpacity(0.08),
      constraints: BoxConstraints.expand(
        height: ATHelperFuncs.getScreenHeight(context) * 0.86
      ),
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      barrierColor: ATColors.black.withOpacity(0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50), topRight: Radius.circular(50),
      )),
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: const SizedBox.shrink()
                ),
              ),
            ),
        
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                    const Gap(10),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "🎁",
                            style: Theme.of(context).textTheme.bodyMedium
                          ),
                          const Gap(5),
                          Text(
                            ATStrings.GIFTS,
                            style: Theme.of(context).textTheme.bodyLarge
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                      
                    Text(
                      maxLines: 3,
                      ATStrings.TOP_GIFTERS_DESC,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ATColors.hexC2C2C2
                      ),
                    ),
                    const Gap(20),
                    Text(
                      ATStrings.TOP_GIFTERS,
                      style: Theme.of(context).textTheme.bodyMedium
                    ),
                    const Gap(20),
                    
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: getHostList().length,
                        itemBuilder: (_, listIndex){
                          final gifter = getHostList().elementAt(listIndex);
                          return AmptiveGifterWidget(
                            onTap: (_, __){},
                            gifter: gifter,
                            index: listIndex + 1,
                          );
                        },
                      ),
                    ),
                  ]
                ),
            ),

            Positioned(
              bottom: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                  child: ATContainer(
                    padding: const EdgeInsets.only(left: 25, right: 15, bottom: 20, top: 15),
                    width: ATHelperFuncs.getScreenWidth(context),
                    child: Row(
                      children: [
                        ATCircularImage(
                          imagePath: randomUser.obj.profilePicture ?? '',
                          diameter:50,
                        ),
                        const Gap(10),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                randomUser.obj.name ?? '',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: ATFontSizes.size15
                                )
                              ),
                              Text(
                                ATStrings.SEND_GIFT_2_HOST,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: ATColors.hexC2C2C2
                                )
                              )
                            ],
                          ),
                        ),
                        ATContainer(
                          onTap: (){},
                          radius: 40,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          color: ATColors.hex307FE2,
                          child: Text(
                            ATStrings.SEND_GIFT,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: ATFontSizes.size15
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ),
              ),
            ),  
          ],
        );
      }
    );
}





class AmptiveGifterWidget extends StatelessWidget {
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> gifter;
  final int index;

  const AmptiveGifterWidget({
    super.key,
    required this.onTap,
    required this.gifter,
    required this.index
  });

  @override
  Widget build(context) {
    final amountGifted = 10000 / (index);
    final isInTop3Gifter = index == 1 || index == 2 || index == 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(gifter, gifter.notifier.value),
        child: Row(
          children: [
            isInTop3Gifter ? Text(
              index.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ATColors.yellowColor,
                fontSize: ATFontSizes.size14
              ),
            ) : ATCircleAvatar(
              diameter: 5,
              color: ATColors.white.withOpacity(0.4),
              child: const SizedBox.shrink(),
            ),
            const Gap(5),
            ATContainer(
              clipBehavior: Clip.hardEdge,
              height: 50, width: 50, radius: 30,
              child: FittedBox(
                fit: BoxFit.fill,
                child: ATImgLoader(imgPath: gifter.obj.profilePicture!)
              ),
            ),
            const Gap(10),
            Expanded(
              child: Text(
                gifter.obj.username ?? '',
                style: Theme.of(context).textTheme.titleMedium
              ),
            ),
            Text(
              'N${amountGifted.toString().formatPrice()}',
              style: Theme.of(context).textTheme.bodySmall
            ),
          ],
        ),
      ),
    );
  }
}