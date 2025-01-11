import 'package:amptive/src/utils/constants/colors.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';

class AmptiveAnimatedPaddingOnPictureWidget extends StatefulWidget {
  final String imagePath;

  const AmptiveAnimatedPaddingOnPictureWidget({
    super.key,
    required this.imagePath
  });

  @override
  State<AmptiveAnimatedPaddingOnPictureWidget> createState() => _SizeAnimationState();
}

class _SizeAnimationState extends State<AmptiveAnimatedPaddingOnPictureWidget> with 
SingleTickerProviderStateMixin{

  late AnimationController sizeController;
  late Animation<double> paddingAnimation;

  @override 
  void initState(){
    super.initState();
    sizeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    paddingAnimation = Tween<double> (
      begin: 1,
      end: 5
    ).animate(
      CurvedAnimation(
        parent: sizeController,
        curve: Curves.ease
      )
    );
  }

  @override 
  void dispose(){
    sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(_) => AnimatedBuilder(
    animation: paddingAnimation,
    builder: (_, __) => Container(
      padding: EdgeInsets.all(paddingAnimation.value),
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: AmptiveColors.orangeColor1,
          width: 2
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: AmptiveImageLoaderWidget(
          imagePath: widget.imagePath,
          boxFit: BoxFit.cover,
          height: 60,
          width: 60,
        ),
      ),
    ),
  );
}