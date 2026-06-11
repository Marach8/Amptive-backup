import 'package:amptive/src/config/utils/extensions/context_extensions.dart';
import 'package:amptive/src/config/utils/other_strings.dart';
import 'package:amptive/src/config/routing/route_strings.dart';
import 'package:amptive/src/features/auth/cubits/local_user_data_cubit.dart';
import 'package:amptive/src/shared/custom_container_widget.dart';
import 'package:amptive/src/config/utils/colors.dart';
import 'package:amptive/src/config/utils/font_sizes.dart';
import 'package:amptive/src/shared/image_loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/utils/image_strings.dart';

class CreatorProfilePix extends StatelessWidget {
  const CreatorProfilePix({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProfileData? userData =
      context.watch<LocalUserDataCubit>().currentUserData;
    final String? coverPhoto = userData?.coverPhoto;
    return Container(
      decoration: coverPhoto != null ? BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(coverPhoto),
          fit: BoxFit.cover,
        ),
      ) : const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ATImgStrings.weCanDoHardThingsBgImage),
          fit: BoxFit.cover,
        ),
      ),
      height: 150,
      width: context.screenWidth,
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              height: 150,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    ATColors.black,
                    ATColors.transparent
                  ]
                ),
              ),
              width: context.screenWidth,
            ),
            Positioned(
                bottom: -35,
                child: Hero(
                  tag: userData?.pictureUrl ?? '',
                  child: ATContainer(
                      onTap: () => context.pushNamed(
                        ATRoutes.profilePicFullViewScreen,
                        extra: userData?.pictureUrl 
                        ?? ATImgStrings.noAvatarImage,
                      ),
                      height: 70, width: 70,
                      boxShape: BoxShape.circle,
                      border: Border.all(
                        color: ATColors.black,
                        width: 3,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: ATImgLoader(
                          imgPath: userData?.pictureUrl 
                          ?? ATImgStrings.noAvatarImage,
                          height: 70, width: 70,
                          boxFit: BoxFit.cover,
                        ),
                      ),
                    ),
                )
              ),
            Positioned(
                bottom: -35,
                child: ATContainer(
                  color: ATColors.hexFED601,
                  radius: 10,
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 1),
                  border: Border.all(color: ATColors.black, width: 2),
                  child: Text(
                    ATStrings.creator.toUpperCase(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: ATSizes.size10, color: ATColors.black),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
