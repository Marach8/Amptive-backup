import 'dart:ui';
import 'package:amptive/src/config/api_response_and_app_state.dart';
import 'package:amptive/src/features/go_live/cubits/hosted_shows_cubit.dart';
import 'package:amptive/src/features/go_live/data/models/response/show_response_model.dart';
import 'package:amptive/src/features/go_live/go_live_export.dart';
import 'package:amptive/src/global_export.dart';
import 'package:amptive/src/views/widgets/common_widgets/annotated_region__widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/back_button.dart';
import 'package:amptive/src/views/widgets/common_widgets/circle_avatar.dart';
import 'package:amptive/src/views/widgets/common_widgets/image_loader_widget.dart';
import 'package:amptive/src/features/go_live/presentation/widgets/existing_go_live_program_widget.dart';
import 'package:amptive/src/views/widgets/common_widgets/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;
import 'package:amptive/src/views/widgets/common_widgets/sliver_header_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RenderHostedShow extends StatelessWidget {
  const RenderHostedShow({super.key, required this.hostedShow});
  final HostedShow hostedShow;
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
        return BlocBuilder<HostedShowSelectionCubit, String?>(
          builder: (BuildContext blocContext, String? selectedImg) {
            final bool isSelected = hostedShow.coverUrl == selectedImg;
            return ATContainer(
              duration: 200,
              onTap: () => blocContext.read<HostedShowSelectionCubit>().setBgImage(
                isSelected ? null : hostedShow.coverUrl
              ),
              radius: 5,
              border: Border.all(
                color: isSelected ? ATColors.hex307FE2 : ATColors.transparent,
                width: 3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: ATImgLoader(
                      boxFit: BoxFit.fill,
                        height: kst.maxHeight * 0.65,
                        width: context.screenWidth,
                      imgPath: hostedShow.coverUrl ?? '',
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5),
                    color: isSelected ? ATColors.hex1F1F23 : ATColors.transparent,
                    child: Column(
                      children: <Widget>[
                        Text(
                          maxLines: 2,
                          hostedShow.title ?? '',
                          style: context.textTheme.bodyMedium,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              'Created',
                              style: context.textTheme.titleSmall?.copyWith(
                                fontSize: ATSizes.size13,
                                color: ATColors.hexA8A8A8,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CircleAvatar(
                                radius: 2.5,
                                backgroundColor: ATColors.hexA8A8A8,
                              ),
                            ),
                            const SizedBox(width: 5,),
                            Flexible(
                              child: Text(
                                ATHelperFuncs.formatDate(hostedShow.createdAt ?? ''),
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: ATColors.hexA8A8A8,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        );
      }
    );
  }
}


class RenderAHostedShowShimmer extends StatelessWidget {
  const RenderAHostedShowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ATColors.transparent,
              width: 3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ATShimmer(
                height: kst.maxHeight * 0.65,
                radius: 8,
              ),
              const SizedBox(height: 10),
              ATShimmer(
                height: 12, radius: 3,
                width: ATHelperFuncs.getRandomNumber(kst.maxWidth),
              ),
              const SizedBox(height: 5,),
              ATShimmer(
                height: 12, radius: 3,
                width: ATHelperFuncs.getRandomNumber(kst.maxWidth),
              ),
              const SizedBox(height: 10),
              const ATShimmer(height: 10, radius: 3),
            ],
          ),
        );
      }
    );
  }
}


class CreateNewShowWidget extends StatelessWidget {
  const CreateNewShowWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, BoxConstraints kst) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ATContainer(
              onTap: (){
                context.pushNamed(ATRoutes.createShowForm);
              },
              radius: 5, color: ATColors.hex2D2D2D,
              width: context.screenWidth,
              height: kst.maxHeight * 0.65,
              child: const Icon(Icons.add, size: 100),
            ),
            const SizedBox(height: 5,),
            Text(
              ATStrings.createNewShow,
              style: context.textTheme.bodyMedium,
            ),
          ],
        );
      }
    );
  }
}
