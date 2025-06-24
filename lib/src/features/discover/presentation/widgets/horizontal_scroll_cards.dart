import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/utils/constants/strings/image_strings.dart';
import 'package:amptive/src/utils/helpers/helper_functions/helper_functions.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_rebuilder_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HorizontalScrollCards extends StatefulWidget {
  const HorizontalScrollCards({super.key});

  @override
  State<HorizontalScrollCards> createState() => _HorizontalScrollCardsState();
}

class _HorizontalScrollCardsState extends State<HorizontalScrollCards> {
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);
  final _adverts = [
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
  Widget build(context) {
    return SizedBox(
      height: 260,
      width: ATHelperFuncs.getScreenWidth(context),
      child: Column(
        children: [
          CarouselSlider.builder(
            itemCount: _adverts.length,
            itemBuilder: (_, pageIndex, __){
              final advert = _adverts.elementAtOrNull(pageIndex);
              return ATImgLoader(imgPath: advert ?? '');
            },
            options: CarouselOptions(
              autoPlay: true,
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlayCurve: Curves.decelerate,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (pageIndex, _) => _indexNotifier.value = pageIndex
            )
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index){
                  return AmptiveRebuilderWidget(
                    notifier: _indexNotifier,
                    builder: (_, value, __){
                      final isActive = index == value;
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
