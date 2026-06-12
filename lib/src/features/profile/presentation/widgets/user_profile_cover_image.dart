import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/circular_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/image_strings.dart';

class UserBgProfileCoverImage extends StatelessWidget {
  const UserBgProfileCoverImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String? profilePic = context
      .select<LocalUserDataCubit, String?>(
      (LocalUserDataCubit cubit) 
      => cubit.currentUserData?.profilePhoto,
    );
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: ATColors.white.withValues(alpha: 0.5),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            ATColors.black,
            ATColors.white.withValues(alpha: 0.5),
            ATColors.hexD9D9D9
          ]
        ),
      ),
      width: context.screenWidth,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Positioned(
            bottom: -35,
            child: Hero(
              tag: profilePic ?? '',
              child: ATContainer(
                  onTap: () => context.pushNamed(
                    ATRoutes.profilePicFullViewScreen,
                    extra: profilePic 
                    ?? ATImgStrings.noAvatarImage,
                  ),
                  height: 70, width: 70,
                  boxShape: BoxShape.circle,
                  border: Border.all(
                    color: ATColors.black,
                    width: 3,
                  ),
                  child: GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: ATImgLoader(
                        imgPath: profilePic 
                        ?? ATImgStrings.noAvatarImage,
                        height: 70, width: 70,
                        boxFit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
            )
          ),
        ],
      ),
    );
  }
}
