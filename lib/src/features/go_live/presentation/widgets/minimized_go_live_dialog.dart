import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/config/utils/font_weights.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/views/widgets/other_widgets/main_application_widgets/widgets_in_discover_view/recent_searches_widgets/container_with_picture.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:amptive/main.dart';
import 'dart:developer' as marach show log;

Future<void> showMinimizedGoLiveState() async {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(
      backgroundColor: ATColors.hex202020,
      elevation: 0,
      duration: const Duration(days: 10000),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(left: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: ATColors.hex2D2D2D)),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const AmptivePictureWidget(
            imagePath: ATImgStrings.weCanDoHardThingsBgImage,
            diameter: 40,
            radius: 2,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'glennodoyle and 2 others',
                  style: TextStyle(
                    color: ATColors.white,
                    fontSize: ATSizes.size13,
                    fontWeight: ATFontWeights.w500,
                  ),
                ),
                Row(
                  children: <Widget>[
                    const ATImgLoader(
                      imgPath: ATImgStrings.filledBroadCast,
                      height: 15,
                      width: 15,
                    ),
                    Flexible(
                      child: _HorizontalScrollCards(
                        // spaceSize: constraints.maxWidth,
                        child: Text(
                          "Don't forget who you are ft. Jacob Scipio and the boy is cooljdkjfkafkdajdjjakdjfkajeiefkdjfkdjakjdkjkja",
                          style: TextStyle(
                            color: ATColors.hexC2C2C2,
                            fontSize: ATSizes.size12,
                            fontWeight: ATFontWeights.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () =>
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar(),
            child: Icon(Icons.close, color: ATColors.white, size: 20),
          )
        ],
      ),
    ),
  );
}

class _HorizontalScrollCards extends StatefulWidget {
  //final double spaceSize;
  const _HorizontalScrollCards({
    required this.child,
    /*required this.spaceSize*/
  });
  final Widget child;

  @override
  State<_HorizontalScrollCards> createState() => _HorizontalScrollCardsState();
}

class _HorizontalScrollCardsState extends State<_HorizontalScrollCards> {
  double viewportFraction = 2;
  final GlobalKey _measurementKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getChildWidth());
  }

  void _getChildWidth() {
    final RenderBox? renderBox =
        _measurementKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      final double childWidth = renderBox.size.width;
      final double screenWidth = MediaQuery.sizeOf(context).width;
      final double foo = (childWidth / screenWidth).clamp(0.1, 1.0);

      marach.log(childWidth.toString());
      marach.log(foo.toString());
      marach.log(screenWidth.toString());
      //marach.log(widget.spaceSize.toString());

      //setState(() => viewportFraction = (childWidth / screenWidth).clamp(0.1, 1.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Hidden widget for measurement (Doesn't interfere with Carousel)
        Offstage(
          child: IntrinsicWidth(
            child: SizedBox(
              key: _measurementKey,
              child: widget.child,
            ),
          ),
        ),

        // CarouselSlider with actual child (without GlobalKey issue)
        CarouselSlider(
          items: <Widget>[widget.child],
          options: CarouselOptions(
            aspectRatio: 15,
            autoPlay: true,
            viewportFraction: viewportFraction,
            autoPlayAnimationDuration: const Duration(seconds: 5),
            scrollPhysics: const NeverScrollableScrollPhysics(),
            autoPlayCurve: Curves.linear,
            autoPlayInterval: const Duration(milliseconds: 50),
          ),
        ),
      ],
    );
  }
}
