import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/features/main_app_nav_bar.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/custom_rebuilder_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalScrollCards extends StatefulWidget {
  const HorizontalScrollCards({super.key});

  @override
  State<HorizontalScrollCards> createState() => _HorizontalScrollCardsState();
}

class _HorizontalScrollCardsState extends State<HorizontalScrollCards> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  final List<String> _adverts = <String>[
    ATImgStrings.discoverCard1,
    ATImgStrings.discoverCard2,
    ATImgStrings.discoverCard3,
  ];

  @override
  void dispose() {
    _indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDiscoverVisible =
        context.select<ATNavBarBloc, bool>((ATNavBarBloc bloc) {
      return bloc.state.$1 == 1 && bloc.state.$2;
    });
    final bool disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final double cardWidth = context.screenWidth * 0.86;
    final double cardHeight = cardWidth * (961 / 1281);
    final double viewportFraction =
        ((cardWidth + 20) / context.screenWidth).clamp(0, 1);

    return SizedBox(
      height: cardHeight + 30,
      width: context.screenWidth,
      child: Column(
        children: <Widget>[
          CarouselSlider.builder(
              itemCount: _adverts.length,
              itemBuilder: (_, int pageIndex, __) {
                final String? advert = _adverts.elementAtOrNull(pageIndex);
                return ClipSmoothRect(
                  radius: SmoothBorderRadius(
                    cornerRadius: 10,
                    cornerSmoothing: 0.8,
                  ),
                  child: ATImgLoader(
                    imgPath: advert ?? '',
                    width: cardWidth,
                    height: cardHeight,
                    boxFit: BoxFit.cover,
                  ),
                );
              },
              options: CarouselOptions(
                  height: cardHeight,
                  viewportFraction: viewportFraction,
                  padEnds: false,
                  autoPlay: isDiscoverVisible && !disableAnimations,
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlayCurve: Curves.easeOutCubic,
                  autoPlayAnimationDuration: const Duration(milliseconds: 450),
                  autoPlayInterval: const Duration(seconds: 5),
                  onPageChanged: (int pageIndex, _) =>
                      _indexNotifier.value = pageIndex)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (int index) {
                return AmptiveRebuilderWidget(
                    notifier: _indexNotifier,
                    builder: (_, int value, __) {
                      final bool isActive = index == value;
                      return ATContainer(
                          margin: EdgeInsets.only(left: index == 0 ? 0 : 5),
                          radius: 8,
                          height: 8,
                          color: isActive ? ATColors.white : ATColors.hex5B5B5B,
                          width: isActive ? 18 : 8,
                          child: const SizedBox.shrink());
                    });
              }),
            ),
          )
        ],
      ),
    );
  }
}
