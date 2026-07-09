import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:amptive/src/shared/shimmer.dart';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GoLiveWidgetInHome extends StatelessWidget {
  const GoLiveWidgetInHome({super.key});

  @override
  Widget build(BuildContext context) {
    final String? profilePic = context
      .watch<LocalUserDataCubit>().currentUserData?.pictureUrl;
    return ScaleOnPressWidget(
      scaleDownTo: 0.92,
      onTap: () {
        context.pushNamed(ATRoutes.chooseEventOrShowScreen);
      },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ATImgLoader(
                    imgPath: profilePic ?? ATImgStrings.jpeg1,
                    boxFit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: ATContainer(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(0),
                    height: 24,
                    width: 24,
                    radius: 12,
                    color: Colors.white, // Changed to white
                    border: Border.all(
                      color: ATColors.hex0D0D0D, // Kept black border to 'cut out' against background
                      width: 2,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: 10,
                          height: 2.2,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 2.2,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(ATStrings.goLive, style: context.textTheme.titleSmall),
          ],
        ),
    );
  }
}
