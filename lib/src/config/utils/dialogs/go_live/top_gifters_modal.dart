import 'dart:ui';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/circle_avatar.dart';
import 'package:amptive/src/shared/modal_dismisser.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import '../../../../models/host.dart';
import '../../../../services/create_show/create_show_service.dart';

Future<void> showHostViewOfTopGiftersDialog(BuildContext context) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020.withValues(alpha: 0.9),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.7,
            builder: (_, ScrollController controller) {
              return Container(
                padding: const EdgeInsets.only(top: 20),
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Align(
                            alignment: Alignment.center,
                            child: ATModalDismisser()),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ATScrollBar(
                            extScrollCntrl: controller,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(15, 0, 10, 20),
                              physics: const BouncingScrollPhysics(),
                              primary: true,
                              itemCount: getHostList().length + 1,
                              itemBuilder: (_, int listIndex) {
                                if (listIndex == 0) {
                                  return const _GiftsDescColumn();
                                }

                                final ObjectWithNotifier<Host> gifter =
                                    getHostList().elementAt(listIndex - 1);

                                return _GifterWidget(
                                  onTap: (_, __) {},
                                  gifter: gifter,
                                  index: listIndex,
                                );
                              },
                            ),
                          ),
                        ),
                      ]),
                ),
              );
            });
      });
}

Future<void> showAudienceViewOfTopGiftersDialog(BuildContext context) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ATColors.hex202020.withValues(alpha: 0.9),
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.7,
                builder: (_, ScrollController controller) {
                  return Container(
                    padding: const EdgeInsets.only(top: 20),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Align(
                                alignment: Alignment.center,
                                child: ATModalDismisser()),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ATScrollBar(
                                extScrollCntrl: controller,
                                child: ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 10, 20),
                                  physics: const BouncingScrollPhysics(),
                                  primary: true,
                                  itemCount: getHostList().length + 1,
                                  itemBuilder: (_, int listIndex) {
                                    if (listIndex == 0) {
                                      return const _GiftsDescColumn();
                                    }

                                    final ObjectWithNotifier<Host> gifter =
                                        getHostList().elementAt(listIndex - 1);

                                    return _GifterWidget(
                                      onTap: (_, __) {},
                                      gifter: gifter,
                                      index: listIndex,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]),
                    ),
                  );
                }),
            Positioned(
              bottom: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                padding: const EdgeInsets.fromLTRB(30, 15, 15, 20),
                width: context.screenWidth,
                decoration: const BoxDecoration(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(25),
                        child: ATImgLoader(
                          imgPath: getHostList()[5].obj.profilePicture!,
                          boxFit: BoxFit.cover,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(getHostList()[5].obj.name ?? '',
                                style: context.textTheme.bodySmall
                                    ?.copyWith(fontSize: ATSizes.size15)),
                            Text(ATStrings.SEND_GIFT_2_HOST,
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: ATColors.hexC2C2C2))
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ATContainer(
                        onTap: () {},
                        radius: 40,
                        color: ATColors.hex307FE2,
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          ATStrings.SEND_GIFT,
                          style: context.textTheme.bodyMedium
                              ?.copyWith(fontSize: ATSizes.size15),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

class _GifterWidget extends StatelessWidget {
  const _GifterWidget(
      {required this.onTap, required this.gifter, required this.index});
  final void Function(ObjectWithNotifier<Host>, bool) onTap;
  final ObjectWithNotifier<Host> gifter;
  final int index;

  @override
  Widget build(BuildContext context) {
    final double amountGifted = 10000 / (index);
    final bool isInTop3Gifter = index == 1 || index == 2 || index == 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: GestureDetector(
        onTap: () => onTap(gifter, gifter.notifier.value),
        child: Row(
          children: <Widget>[
            isInTop3Gifter
                ? Text(
                    index.toString(),
                    style: context.textTheme.bodyMedium?.copyWith(
                        color: ATColors.yellowColor, fontSize: ATSizes.size14),
                  )
                : ATCircleAvatar(
                    diameter: 5,
                    color: ATColors.white.withValues(alpha: 0.4),
                    child: const SizedBox.shrink(),
                  ),
            const SizedBox(
              width: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: ATImgLoader(
                imgPath: gifter.obj.profilePicture!,
                boxFit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(gifter.obj.username ?? '',
                  style: context.textTheme.titleMedium),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
                '${ATStrings.nairaText}${amountGifted.toString().formatPrice()}',
                style: context.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _GiftsDescColumn extends StatelessWidget {
  const _GiftsDescColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: <Widget>[
        Align(
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ATImgLoader(
                imgPath: ATImgStrings.HOST_GIFT_ICON,
                height: 30,
                width: 30,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(ATStrings.GIFTS, style: context.textTheme.bodyLarge),
            ],
          ),
        ),
        Text(
          maxLines: 3,
          ATStrings.TOP_GIFTERS_DESC,
          style: context.textTheme.labelSmall
              ?.copyWith(color: ATColors.hexC2C2C2, letterSpacing: 0),
        ),
        Text(ATStrings.TOP_GIFTERS, style: context.textTheme.bodyMedium),
      ],
    );
  }
}
