import 'package:amptive/src/config/config_export.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/shared/custom_rebuilder_widget.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HorizontalScrollCards extends StatefulWidget {
  const HorizontalScrollCards({super.key});

  @override
  State<HorizontalScrollCards> createState() => _HorizontalScrollCardsState();
}

class _HorizontalScrollCardsState extends State<HorizontalScrollCards> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  final List<String> _adverts = <String>[
    ATImgStrings.discoverPic1,
    ATImgStrings.discoverPic1,
    ATImgStrings.discoverPic1
  ];


  @override
  void dispose() {
    _indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      width: context.screenWidth,
      child: Column(
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: _adverts.length,
            itemBuilder: (_, int pageIndex, __){
              final String? advert = _adverts.elementAtOrNull(pageIndex);
              return ATImgLoader(imgPath: advert ?? '');
            },
            options: CarouselOptions(
              autoPlay: true,
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlayCurve: Curves.decelerate,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (int pageIndex, _) => _indexNotifier.value = pageIndex
            )
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (int index){
                  return AmptiveRebuilderWidget(
                    notifier: _indexNotifier,
                    builder: (_, int value, __){
                      final bool isActive = index == value;
                      return ATContainer(
                        margin: const EdgeInsets.only(left: 3),
                        radius: 8, height: 8,
                        color: isActive ? ATColors.white : ATColors.hex5B5B5B, 
                        width: isActive ? 25 : 8,
                        child: const SizedBox.shrink()
                      );
                    }
                  );
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}
