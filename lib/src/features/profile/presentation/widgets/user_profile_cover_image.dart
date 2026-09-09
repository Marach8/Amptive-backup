import 'dart:developer';

import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/features/profile/presentation/widgets/edit_profile_cover_image.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
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
    final ProfileImages profileImages = context
      .select<LocalUserDataCubit, ProfileImages>(
        (LocalUserDataCubit cubit) => (
          coverImageUrl: cubit.currentUserData?.coverPhoto,
          profileImageUrl: cubit.currentUserData?.profilePhoto)
      );

    log('This is the profilePhoto on the userdata area ${profileImages.profileImageUrl}');

    return Container(
      height: 150,
      color: ATColors.white.withValues(alpha: 0.5),
      width: context.screenWidth,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          if(profileImages.coverImageUrl != null) ATImgLoader(
            height: 150,
            boxFit: BoxFit.cover,
            width: context.screenWidth,
            imgPath: profileImages.coverImageUrl!,
          ),
          Container(
            height: 150, width: context.screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  ATColors.black,
                  ATColors.hex666666.withValues(alpha: 0)
                ]
              ),
            ),
          ),
          Positioned(
            bottom: -35,
            child: Hero(
              tag: profileImages.profileImageUrl ?? '',
              child: ATContainer(
                  onTap: () => context.pushNamed(
                    ATRoutes.profilePicFullViewScreen,
                    extra: profileImages.profileImageUrl
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
                        imgPath: profileImages.profileImageUrl
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
