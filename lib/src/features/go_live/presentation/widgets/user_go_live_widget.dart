import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/image_strings.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/views/widgets/common_widgets/custom_container_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoLiveWidget extends StatelessWidget {
  const GoLiveWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){context.pushNamed(ATRoutes.GO_LIVE_WELCOME_SCREEN);},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: const ATImgLoader(
                  imgPath: ATImgStrings.jpeg1,
                  boxFit: BoxFit.cover, height: 60, width: 60,
                ),
              ),
              Positioned(
                bottom: -5,
                child: ATContainer(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(0),
                  height: 20, width: 20, radius: 10,
                  color: ATColors.hex307FE2,
                  border: Border.all(
                    color: ATColors.hex0D0D0D,
                    width: 2,
                  ),
                  child: const Icon(Icons.add, size: 15, applyTextScaling: true),
                ),
              )
            ],
          ),
      
          const SizedBox(height: 10,),
          Text(
            ATStrings.GO_LIVE,
            style: Theme.of(context).textTheme.titleSmall
          ),
        ],
      ),
    );
  }
}